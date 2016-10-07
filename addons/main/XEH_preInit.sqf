#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(logEvents) = true;
GVAR(replayId) = 0;
GVAR(extensionName) = "r3_extension";
GVAR(extensionSeparator) = "&^`";
GVAR(playerSavedIds) = [];

// Frequency of unit movement logging (seconds)
GVAR(insertFrequencyInfantry) = 1;
GVAR(insertFrequencyGroundVehicle) = 1;
GVAR(insertFrequencyAirVehicle) = 1;
GVAR(insertFrequencyMarkers) = 10;

ADDON = true;
