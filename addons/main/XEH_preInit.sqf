#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(databaseSettingName) = "aarDb";

// We need this variable to persist through mission reloads
if (isNil {uiNamespace getVariable QGVAR(databaseRandomLockKey)}) then {
    uiNamespace setVariable [QGVAR(databaseRandomLockKey), floor(random 100)];
};

GVAR(replayId) = 0;
GVAR(messageQueue) = [];

ADDON = true;
