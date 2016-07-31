#include "script_component.hpp"

if!(isServer) exitWith { ERROR_WITH_TITLE("AAR - ERROR", "Addon must be run server side only!"); };

diag_log format["mp? %1", isMultiplayer];

// Setup database and don't continue if it fails
call FUNC(dbInit);
[FUNC(dbCreateReplayEntry), FUNC(setupEventHandlers)] call CBA_fnc_waitUntilAndExecute;