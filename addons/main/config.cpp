#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_common"};
        author[] = {"Titan"};
        authorUrl = "http://google.com";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
