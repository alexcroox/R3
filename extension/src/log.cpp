#include "log.h"

#include "Poco/Path.h"
#include "Poco/DateTimeFormatter.h"
#include "Poco/LocalDateTime.h"

namespace r3 {
namespace log {

namespace {
    const std::string LOGGER_NAME = "r3_extension_log";
}

    std::shared_ptr<spdlog::logger> logger;

    spdlog::level::level_enum getLogLevel(const std::string& logLevel) {
        if (logLevel == "debug") { return spdlog::level::debug; }
        if (logLevel == "trace") { return spdlog::level::trace; }
        return spdlog::level::info;
    }

    std::string getLogFileName() {
        std::string fileName = LOGGER_NAME;
        Poco::DateTimeFormatter::append(fileName, Poco::LocalDateTime(), "_%Y-%m-%d_%H-%M-%S");
        return fileName;
    }

    bool initialze(const std::string& extensionFolder, const std::string& logLevel) {
        logger = spdlog::rotating_logger_mt(LOGGER_NAME, fmt::format("{}{}{}", extensionFolder, Poco::Path::separator(), getLogFileName()), 1024 * 1024 * 20, 1);
        logger->flush_on(spdlog::level::trace);
        logger->set_level(getLogLevel(logLevel));
        return true;
    }

    void finalize() {
    };

} // namespace log
} // namespace r3
