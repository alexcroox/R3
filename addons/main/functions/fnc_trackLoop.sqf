/*
 * Author: Titan
 * Handle throttling of positional update logging
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

GVAR(timeSinceLastInfantryInsert) = time;
GVAR(timeSinceLastGroundVehicleInsert) = time;
GVAR(timeSinceLastAirVehicleInsert) = time;
GVAR(timeSinceLastMarkerInsert) = time;

// Just log markers once (for now)
call FUNC(trackMarkers);

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

            // We save unit positions at different frequencies depending on their vehicle
            if (time >= GVAR(timeSinceLastInfantryInsert) + GVAR(insertFrequencyInfantry)) then {
                call FUNC(trackInfantry);
                GVAR(timeSinceLastInfantryInsert) = time;
            };

            if (time >= GVAR(timeSinceLastGroundVehicleInsert) + GVAR(insertFrequencyGroundVehicle)) then {
                ["ground"] call FUNC(trackVehicles);
                GVAR(timeSinceLastGroundVehicleInsert) = time;
            };

            if (time >= GVAR(timeSinceLastAirVehicleInsert) + GVAR(insertFrequencyAirVehicle)) then {
                ["air"] call FUNC(trackVehicles);
                GVAR(timeSinceLastAirVehicleInsert) = time;
            };

        } else {
            GVAR(noPlayers) = true;
        };
    };
}, 0.2] call CBA_fnc_addPerFrameHandler;