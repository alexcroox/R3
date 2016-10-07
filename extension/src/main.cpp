#include "Extension.h"

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

//#define R3_CONSOLE
#ifndef R3_CONSOLE

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