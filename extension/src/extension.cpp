#include "extension.h"

#include <fstream>
#include "shlobj.h"

#include "log.h"

#include "Poco/Path.h"
#include "Poco/File.h"
#include "Poco/StringTokenizer.h"
#include "Poco/UnicodeConverter.h"
#include "Poco/Util/PropertyFileConfiguration.h"


namespace r3 {
namespace extension {

namespace {
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

    std::vector<std::string>& split(const std::string &s, const std::string& delim, std::vector<std::string> &elems) {
        Poco::StringTokenizer tokenizer(s, delim, Poco::StringTokenizer::TOK_TRIM);
        for (auto token : tokenizer) {
            elems.push_back(token);
        }
        return elems;
    }

    std::string getExtensionFolder() {
        wchar_t wpath[MAX_PATH];
        std::string localAppData = ".";
        if (SUCCEEDED(SHGetFolderPathW(NULL, CSIDL_LOCAL_APPDATA, NULL, 0, wpath))) {
            Poco::UnicodeConverter::toUTF8(wpath, localAppData);
            Poco::File file(fmt::format("{}{}{}", localAppData, Poco::Path::separator(), EXTENSION_FOLDER));
            file.createDirectories();
            return file.path();
        }
        return localAppData;
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
            configError += fmt::format("Config file is missing from '{}'!", configFilePath);
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
        else if (request.command == "player" || request.command == "event") {
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
