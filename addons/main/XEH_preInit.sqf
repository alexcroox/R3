#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(logEvents) = true;
GVAR(noPlayers) = false;
GVAR(replayId) = 0;
GVAR(extensionName) = "r3_extension";
GVAR(extensionSeparator) = "";
GVAR(playerSavedIds) = [];
GVAR(maxUnitCountPerEvent) = 25;
GVAR(maxMarkerCountPerEvent) = 10;

// Frequency of unit movement logging (seconds)
GVAR(insertFrequencyMarkers) = 10;
GVAR(timeSinceLastMarkerInsert) = 0;

ADDON = true;