#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(databaseSettingName) = "aarDb";

// We need this variable to persist through mission reloads
if (isNil {uiNamespace getVariable QGVAR(databaseRandomLockKey)}) then {
    uiNamespace setVariable [QGVAR(databaseRandomLockKey), floor(random 100)];
};

diag_log uiNamespace getVariable QGVAR(databaseRandomLockKey);

GVAR(logEvents) = true;
GVAR(replayId) = 0;
GVAR(eventSavingQueue) = [];

// Frequency of unit movement logging
GVAR(insertFrequencyInfantry) = 5;
GVAR(insertFrequencyGroundVehicle) = 3;
GVAR(insertFrequencyAirVehicle) = 1;
GVAR(maxUnitCountPerEvent) = 30;

ADDON = true;
