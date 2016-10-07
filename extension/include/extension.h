#ifndef EXTENSION_H
#define EXTENSION_H

#include "sql.h"
#include "Queue/Queue.h"


#define R3_EXTENSION_VERSION       "1.0.0"

namespace r3 {

    const std::string REQUEST_COMMAND_POISON = "poison";

    const std::string RESPONSE_TYPE_ERROR = "error";
    const std::string RESPONSE_TYPE_OK = "ok";

    const std::string EMPTY_SQF_DATA = "\"\"";

    struct Request {
        std::string command;
        std::vector<std::string> params;
    };

    struct Response {
        std::string type;
        std::string data;
    };

namespace extension {

    bool initialize();
    void finalize();
    void call(char *output, int outputSize, const char *function);
    Request popRequest();

} // namespace extension
} // namespace r3

#endif // EXTENSION_H