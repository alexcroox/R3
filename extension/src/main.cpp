#include "extension.h"

//#define R3_CONSOLE
#ifndef R3_CONSOLE

// Windows
#ifdef _WIN32

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

BOOL APIENTRY DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) {
    switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
        r3::extension::initialize();
        break;

    case DLL_PROCESS_DETACH:
        r3::extension::finalize();
        break;
    }
    return true;
}

extern "C" {
    __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
};

void __stdcall RVExtension(char *output, int outputSize, const char *function) {
    outputSize -= 1;
    r3::extension::call(output, outputSize, function);
};

// Linux with GCC
#else

extern "C" {
    void RVExtension(char *output, int outputSize, const char *function);
}

void RVExtension(char *output, int outputSize, const char *function) {
    outputSize -= 1;
    r3::extension::call(output, outputSize, function);
}

__attribute__((constructor))
static void extension_init() {
    r3::extension::initialize();
}

__attribute__((destructor))
static void extension_finalize() {
    r3::extension::finalize();
}

#endif

#else

#include <iostream>
#include <string>

int main(int argc, char* argv[]) {
    std::string line = "";
    const int outputSize = 10000;
    char *output = new char[outputSize];

    r3::extension::initialize();
    std::cout
        << "Type 'exit' to close console." << std::endl
        << "You first have to connect to the DB with 'connect'" << std::endl
        << std::endl << std::endl;
    while (line != "exit") {
        std::getline(std::cin, line);
        r3::extension::call(output, outputSize, line.c_str());
        std::cout << "R3: " << output << std::endl;
    }
    r3::extension::finalize();
    return 0;
}

#endif