#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(logEvents) = true;
GVAR(replayId) = 0;
GVAR(eventSavingQueue) = [];
GVAR(playerSavedIds) = [];

// Frequency of unit movement logging
GVAR(insertFrequencyInfantry) = 1;
GVAR(insertFrequencyGroundVehicle) = 1;
GVAR(insertFrequencyAirVehicle) = 1;

ADDON = true;
