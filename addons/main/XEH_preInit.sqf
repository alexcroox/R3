#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(logEvents) = true;
GVAR(forceLogEvents) = false;
GVAR(noPlayers) = false;
GVAR(missionId) = 0;
GVAR(extensionName) = "r3_extension";
GVAR(entityCount) = 0;
GVAR(secondsBetweenKeyFrames) = 30;

GVAR(maxMarkerCountPerEvent) = 10;
GVAR(insertFrequencyMarkers) = 10;
GVAR(timeSinceLastMarkerInsert) = 0;

ADDON = true;
