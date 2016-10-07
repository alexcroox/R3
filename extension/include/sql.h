#ifndef SQL_H
#define SQL_H

#include <string>
#include <mutex>


namespace r3 {

    struct Request;
    struct Response;

namespace sql {

    bool initialize(const std::string& host_, uint32_t port_, const std::string& database_, const std::string& user_, const std::string& password_, size_t timeout_);
    void finalize();
    void run();
    std::mutex& getSessionMutex();
    bool isConnected();
    std::string connect();
    Response processRequest(const Request& request);

} // namespace sql
} // namespace r3

#endif // SQL_H
