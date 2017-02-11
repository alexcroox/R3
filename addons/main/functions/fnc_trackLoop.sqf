/*
 * Author: Titan
 * Main loop for positional logging
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(trackLoop);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > trackLoop";

DBUG("Starting track loop", _functionLogName);

// Just log markers once (for now)
//call FUNC(trackMarkers);

[{
    if (GVAR(logEvents)) then {

        // We only want to log movements if there are players in the map
        private _playerCount = 0;

        {
            if (isPlayer _x) then {
                _playerCount = _playerCount + 1;
            };

        } forEach playableUnits;

        if (_playerCount > 0) then {

            GVAR(noPlayers) = false;

            call FUNC(trackInfantryAndVehicles);

        } else {
            GVAR(noPlayers) = true;
        };
    };
}, 1] call CBA_fnc_addPerFrameHandler;
