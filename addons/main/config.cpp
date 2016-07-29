#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_common"};
        author[] = {"Titan"};
        authorUrl = "https://github.com/alexcroox/Titan_AAR";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
