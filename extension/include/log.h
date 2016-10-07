#ifndef LOGGER_H
#define LOGGER_H

#include "spdlog/spdlog.h"

namespace r3 {
namespace log {
    extern std::shared_ptr<spdlog::logger> logger;

    bool initialze(const std::string& extensionFolder, const std::string& logLevel);
    void finalize();
    std::string getLogFileName();
    spdlog::level::level_enum getLogLevel(const std::string& logLevel);

} // namespace log
} // namespace r3

#endif // LOGGER_H
