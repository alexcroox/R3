#include "extension.h"

#include <fstream>
#include "shlobj.h"

#include "log.h"

#include "Poco/File.h"
#include "Poco/StringTokenizer.h"
#include "Poco/UnicodeConverter.h"
#include "Poco/Util/PropertyFileConfiguration.h"


namespace r3 {
namespace extension {

namespace {
    const std::string EXTENSION_FOLDER = "R3Extension";

    Queue<Request> requests;
    std::thread sqlThread;
    std::string requestParamSeparator;
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
            Poco::File file(fmt::format("{}\\{}", localAppData, EXTENSION_FOLDER));
            file.createDirectories();
            return file.path();
        }
        return localAppData;
    }

    bool initialize() {
        std::string extensionFolder(getExtensionFolder());
        Poco::AutoPtr<Poco::Util::PropertyFileConfiguration> config(new Poco::Util::PropertyFileConfiguration(fmt::format("{}\\{}", extensionFolder, "config.properties")));
        requestParamSeparator = config->getString("r3.sqf.separator");
        std::string host = config->getString("r3.db.host");
        int port = config->getInt("r3.db.port");
        std::string database = config->getString("r3.db.database");
        std::string user = config->getString("r3.db.username");
        std::string password = config->getString("r3.db.password");
        size_t timeout = config->getUInt("r3.db.timeout");
        sql::initialize(host, port, database, user, password, timeout);
        log::initialze(extensionFolder, config->getString("r3.log.level"));
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
