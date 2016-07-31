#include "script_component.hpp"

if!(isServer) exitWith { ERROR_WITH_TITLE("AAR - ERROR", "Addon must be run server side only!"); };

// Setup database and don't continue if it fails
call FUNC(dbInit);
[] spawn FUNC(dbCreateReplayEntry);

// Capture when dbCreateReplayEntry has finished
["dbSetup", FUNC(setupEventHandlers)] call CBA_fnc_addEventHandler;