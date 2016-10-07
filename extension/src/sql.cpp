#include "sql.h"

#include "extension.h"
#include "log.h"

#include "Poco/Nullable.h"
#include "Poco/Data/Session.h"
#include "Poco/Data/MySQL/MySQLException.h"
#include "Poco/Data/MySQL/Connector.h"


namespace r3 {
namespace sql {

namespace {
    std::string host, database, user, password;
    uint32_t port;
    size_t timeout;
    Poco::Data::Session* session;
    std::mutex sessionMutex;
    std::atomic<bool> connected;
}

    uint32_t parseUnsigned(const std::string& str) {
        uint32_t number = 0;
        if (!Poco::NumberParser::tryParseUnsigned(str, number)) {
            return 0;
        }
        return number;
    }

    double parseFloat(const std::string& str) {
        double number = 0;
        if (!Poco::NumberParser::tryParseFloat(str, number)) {
            return 0;
        }
        return number;
    }

    Poco::Nullable<double> getNumericValue(const std::vector<std::string>& parameters, const size_t& idx) {
        if (parameters.size() > idx && !parameters[idx].empty()) {
            double number = 0;
            if (!Poco::NumberParser::tryParseFloat(parameters[idx], number)) {
                return Poco::Nullable<double>();
            }
            return Poco::Nullable<double>(number);
        }
        return Poco::Nullable<double>();
    }

    Poco::Nullable<std::string> getCharValue(const std::vector<std::string>& parameters, const size_t& idx) {
        if (parameters.size() > idx && !parameters[idx].empty()) {
            return Poco::Nullable<std::string>(parameters[idx]);
        }
        return Poco::Nullable<std::string>();
    }

    bool initialize(const std::string& host_, uint32_t port_, const std::string& database_, const std::string& user_, const std::string& password_, size_t timeout_) {
        host = host_;
        port = port_;
        database = database_;
        user = user_;
        password = password_;
        timeout = timeout_;
        return true;
    }

    void finalize() {
        delete session;
        Poco::Data::MySQL::Connector::unregisterConnector();
    }

    void run() {
        auto request = extension::popRequest();
        while (request.command != REQUEST_COMMAND_POISON) {
            {
                std::lock_guard<std::mutex> lock(sessionMutex);
                processRequest(request);
            }
            request = extension::popRequest();
        }
    }

    std::mutex& getSessionMutex() {
        return sessionMutex;
    }

    bool isConnected() {
        return connected;
    }

    std::string connect() {
        if (connected) { return ""; }
        log::logger->info("Connecting to MySQL server at '{}@{}:{}/{}'.", user, host, port, database);
        connected = false;
        try {
            Poco::Data::MySQL::Connector::registerConnector();
            session = new Poco::Data::Session("MySQL", fmt::format("host={};port={};db={};user={};password={};compress=true;auto-reconnect=true", host, port, database, user, password), timeout);
            connected = true;
        }
        catch (Poco::Data::ConnectionFailedException& e) {
            std::string message = fmt::format("Failed to connect to MySQL server! Error code: '{}', Error message: {}", e.code(), e.displayText());
            log::logger->error(message);
            connected = false;
            return message;
        }
        catch (Poco::Data::MySQL::ConnectionException& e) {
            std::string message = fmt::format("Failed to connect to MySQL server! Error code: '{}', Error message: {}", e.code(), e.displayText());
            log::logger->error(message);
            connected = false;
            return message;
        }
        return "";
    }

    Response processRequest(const Request& request) {
        Response response{ RESPONSE_TYPE_OK, EMPTY_SQF_DATA };
        auto realParamsSize = request.params.size() - 1;
        log::logger->trace("Request command '{}' params size '{}'!", request.command, request.params.size());
        try {
            if (request.command == "replay" && realParamsSize == 4) {
                std::string missionName = request.params[1];
                std::string map = request.params[2];
                double dayTime = getNumericValue(request.params, 3);
                std::string addonVersion = request.params[4];
                log::logger->debug("Inserting into 'replays' values missionName '{}', map '{}', dayTime '{}', addonVersion '{}'.", missionName, map, dayTime, addonVersion);
                *session << "INSERT INTO replays(missionName, map, dayTime, dateStarted, addonVersion) VALUES(?, ?, ?, NOW(), ?)",
                    Poco::Data::Keywords::use(missionName),
                    Poco::Data::Keywords::use(map),
                    Poco::Data::Keywords::use(dayTime),
                    Poco::Data::Keywords::use(addonVersion),
                    Poco::Data::Keywords::now;
                uint32_t replayId = 0;
                *session << "SELECT LAST_INSERT_ID()",
                    Poco::Data::Keywords::into(replayId),
                    Poco::Data::Keywords::now;
                log::logger->debug("New replay id is '{}'.", replayId);
                response.data = std::to_string(replayId);
            }
            else if (request.command == "player" && realParamsSize == 2) {
                std::string id = request.params[1];
                std::string name = request.params[2];
                log::logger->debug("Inserting into 'players' values id '{}', name '{}'.", id, name);
                *session << "INSERT INTO players(id, name, lastSeen) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE lastSeen = NOW()",
                    Poco::Data::Keywords::use(id),
                    Poco::Data::Keywords::use(name),
                    Poco::Data::Keywords::now;
            }
            else if (request.command == "event" && realParamsSize == 5) {
                uint32_t replayId = parseUnsigned(request.params[1]);
                std::string playerId = request.params[2];
                std::string type = request.params[3];
                std::string value = request.params[4];
                double missionTime = parseFloat(request.params[5]);
                log::logger->debug("Inserting into 'events' values replayId '{}', playerId '{}', type '{}', value '{}', missionTime '{}'.", replayId, playerId, type, value, missionTime);
                *session << "INSERT INTO events(replayId, playerId, type, value, missionTime, added) VALUES (?, ?, ?, ?, ?, NOW())",
                    Poco::Data::Keywords::use(replayId),
                    Poco::Data::Keywords::use(playerId),
                    Poco::Data::Keywords::use(type),
                    Poco::Data::Keywords::use(value),
                    Poco::Data::Keywords::use(missionTime),
                    Poco::Data::Keywords::now;
            }
            else {
                log::logger->debug("Invlaid command type '{}'!", request.command);
                response.type = RESPONSE_TYPE_ERROR;
                response.data = fmt::format("\"Invalid command type!\"");
            }
        }
        catch (Poco::Data::MySQL::MySQLException& e) {
            log::logger->error("Error executing prepared statement! Error code: '{}', Error message: {}", e.code(), e.displayText());
            response.type = RESPONSE_TYPE_ERROR;
            response.data = fmt::format("\"Error executing prepared statement! {}\"", e.displayText());
        }
        return response;
    }

} // namespace sql
} // namespace r3
