/*
 * Author: Titan
 * Loops through all infantry and vehicles
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(trackInfantryAndVehicles);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > trackInfantryAndVehicles";

private _all = allUnits + vehicles;

// Loop through all units and vehicles on the map
{
    private _doNotTrack = _x getVariable ["r3_do_not_track", false];

    if !(_doNotTrack) then {

        // Store unique entity id against the unit to identify them in playback
        private _entityId = _x getVariable ["r3_entity_id", false];
        private _isVehicle = _x getVariable ["r3_is_vehicle", true];
        private _isValid = true;
        private _isKeyFrame = 0;

        // This is the first time we've seen this unit,
        // lets do some one time calculations
        if !(_entityId) then {

            // This is an infantry unit
            if (_x isKindOf "CaManBase") then {
                _isVehicle = false;
            };

            // Let's never touch objects that aren't living or a drivable vehicle
            if (_x isKindOf "Logic" || (_isVehicle && _x isKindOf "WeaponHolderSimulated")) then {
                _x setVariable ["r3_do_not_track", true];
                _isValid = false;
            };

            // We don't want to touch empty vehicles until they are used
            if (_isVehicle && count crew _x == 0) then {
                _isValid = false;
            };

            if (_isValid) then {

                // Set an incrementing unique ID against each unit to be used as
                // a unique index on the web server
                GVAR(entityCount) = GVAR(entityCount) + 1;
                _entityId = GVAR(entityCount);

                _x setVariable ["r3_is_vehicle", _isVehicle];
                _x setVariable ["r3_entity_id", _entityId];

                if (_isVehicle) then {
                    [_entityId, _x] spawn FUNC(dbInsertVehicle);
                    [_x] call FUNC(addVehicleEventHandlers);
                } else {
                    [_entityId, _x] spawn FUNC(dbInsertInfantry);
                    [_x] call FUNC(addInfantryEventHandlers);
                };
            };
        };

        if (_isValid) then {

            if !(_isVehicle) then {
                [_entityId, _x, _isKeyFrame] call FUNC(dbInsertInfantryPosition);
            } else {
                [_entityId, _x, _isKeyFrame] call FUNC(dbInsertVehiclePosition);
            };
        };
    }; // do not track
} forEach _all;
