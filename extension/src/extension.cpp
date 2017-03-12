#include "extension.h"

#include <fstream>
#include <regex>

#ifdef _WIN32
#include "shlobj.h"
#endif

#include "log.h"

#include "Poco/Environment.h"
#include "Poco/Path.h"
#include "Poco/File.h"
#include "Poco/StringTokenizer.h"
#include "Poco/UnicodeConverter.h"
#include "Poco/Util/PropertyFileConfiguration.h"


namespace r3 {
namespace extension {

namespace {
    const std::string EXTENSION_FOLDER_ENV_VAR = "R3_EXTENSION_HOME";
    const std::string EXTENSION_FOLDER = "R3Extension";
    const std::string CONFIG_FILE = "config.properties";
    const std::string DEFAULT_REQUEST_PARAM_SEPARATOR = "`";

    Queue<Request> requests;
    std::thread sqlThread;
    std::string requestParamSeparator;
    std::string configError = "";
}

    void respond(char* output, const std::string& type, const std::string& data) {
        std::string message = fmt::format("[\"{}\",{}]", type, data);
        message.copy(output, message.length());
        output[message.length()] = '\0';
    }

    void split(const std::string &str, const std::string& separator, std::vector<std::string> &elems) {
        std::regex separatorRegex(separator);
        elems = { std::sregex_token_iterator(str.begin(), str.end(), separatorRegex, -1), std::sregex_token_iterator() };
    }

    std::string getExtensionFolder() {
        if (Poco::Environment::has(EXTENSION_FOLDER_ENV_VAR)) {
            return Poco::Environment::get(EXTENSION_FOLDER_ENV_VAR);
        }
#ifdef _WIN32
        std::string extensionFolder = fmt::format(".{}", Poco::Path::separator());
        wchar_t wpath[MAX_PATH];
        if (!SUCCEEDED(SHGetFolderPathW(NULL, CSIDL_LOCAL_APPDATA, NULL, 0, wpath))) {
            return extensionFolder;
        }
        Poco::UnicodeConverter::toUTF8(wpath, extensionFolder);
#else
        std::string extensionFolder = Poco::Environment::get("HOME", ".");
#endif
        Poco::File file(fmt::format("{}{}{}", extensionFolder, Poco::Path::separator(), EXTENSION_FOLDER));
        file.createDirectories();
        return file.path();
    }

    std::string getStringProperty(Poco::AutoPtr<Poco::Util::PropertyFileConfiguration> config, const std::string& key) {
        if (!config->has(key)) {
            std::string message = fmt::format("Config file is missing property '{}'.", key);
            configError += " " + message;
            log::logger->error(message);
            return "";
        }
        return config->getString(key);
    }

    uint32_t getUIntProperty(Poco::AutoPtr<Poco::Util::PropertyFileConfiguration> config, const std::string& key) {
        if (!config->has(key)) {
            std::string message = fmt::format("Config file is missing property '{}'!", key);
            configError += " " + message;
            log::logger->error(message);
            return 0;
        }
        try {
            return config->getUInt(key);
        } catch (Poco::SyntaxException e) {
            std::string message = fmt::format("Property '{}' value '{}' is not a number!", key, config->getString(key));
            configError += " " + message;
            log::logger->error(message);
            return 0;
        }
    }

    bool initialize() {
        std::string extensionFolder(getExtensionFolder());
        std::string configFilePath(fmt::format("{}{}{}", extensionFolder, Poco::Path::separator(), CONFIG_FILE));
        Poco::File file(configFilePath);
        if (!file.exists()) {
            std::string message = fmt::format("Config file is missing from '{}'!", configFilePath);
            configError += message;
            log::initialze(extensionFolder, "info");
            log::logger->error(message);
            return false;
        }
        Poco::AutoPtr<Poco::Util::PropertyFileConfiguration> config(new Poco::Util::PropertyFileConfiguration(configFilePath));

        std::string logLevel = config->getString("r3.log.level", "info");
        log::initialze(extensionFolder, logLevel);

        requestParamSeparator = config->getString("r3.sqf.separator", DEFAULT_REQUEST_PARAM_SEPARATOR);

        std::string host = getStringProperty(config, "r3.db.host");
        uint32_t port = getUIntProperty(config, "r3.db.port");
        std::string database = getStringProperty(config, "r3.db.database");
        std::string user = getStringProperty(config, "r3.db.username");
        std::string password = getStringProperty(config, "r3.db.password");
        size_t timeout = getUIntProperty(config, "r3.db.timeout");
        sql::initialize(host, port, database, user, password, timeout);

        log::logger->info("Starting r3_extension version '{}'.", R3_EXTENSION_VERSION);
        return true;
    }

    void finalize() {
        if (sql::isConnected()) {
            requests.push(Request{ REQUEST_COMMAND_POISON });
            sqlThread.join();
            sql::finalize();
        }
        log::logger->info("Stopped r3_extension version '{}'.", R3_EXTENSION_VERSION);
    }

    void call(char* output, int outputSize, const char* function) {
        if (!configError.empty()) {
            respond(output, RESPONSE_TYPE_ERROR, fmt::format("\"{}\"", configError));
            return;
        }
        Request request{ "" };
        split(std::string(function), requestParamSeparator, request.params);
        if (!request.params.empty()) {
            request.command = request.params[0];
        }
        if (request.command == "version") {
            respond(output, RESPONSE_TYPE_OK, fmt::format("\"{}\"", R3_EXTENSION_VERSION));
            return;
        }
        else if (request.command == "separator") {
            respond(output, RESPONSE_TYPE_OK, fmt::format("\"{}\"", requestParamSeparator));
            return;
        }
        else if (request.command == "connect") {
            if (sql::isConnected()) {
                respond(output, RESPONSE_TYPE_OK, "true");
                return;
            }
            std::string message = sql::connect();
            if (message.empty()) {
                sqlThread = std::thread(sql::run);
                respond(output, RESPONSE_TYPE_OK, "true");
                return;
            }
            respond(output, RESPONSE_TYPE_ERROR, message);
            return;
        }
        else if (!sql::isConnected()) {
            respond(output, RESPONSE_TYPE_ERROR, "\"Not connected to the database!\"");
            return;
        }
        else if (request.command == "replay") {
            Response response;
            {
                std::lock_guard<std::mutex> lock(sql::getSessionMutex());
                response = sql::processRequest(request);
            }
            respond(output, RESPONSE_TYPE_OK, response.data);
            return;
        }
        else if (request.command == "infantry" || request.command == "infantry_positions" || request.command == "vehicles" || request.command == "vehicle_positions" || request.command == "events_connections" || request.command == "events_get_in_out" || request.command == "events_projectile" || request.command == "events_downed" || request.command == "events_missile") {
            requests.push(request);
            respond(output, RESPONSE_TYPE_OK, EMPTY_SQF_DATA);
            return;
        }
        respond(output, RESPONSE_TYPE_ERROR, "\"Unkown command\"");
    }

    Request popRequest() {
        return requests.pop();
    }

} // namespace extension
} // namespace r3
