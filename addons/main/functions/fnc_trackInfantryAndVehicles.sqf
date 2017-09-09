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

private _allUnitsAndVehicles = allUnits + vehicles;

// Loop through all units and vehicles on the map
{
    private _doNotTrack = _x getVariable ["r3_do_not_track", false];

    if ( !(_doNotTrack) && (!(GVAR(noPlayers)) || GVAR(forceLogEvents)) ) then {

        // Store unique entity id against the unit to identify them in playback
        private _entityId = _x getVariable ["r3_entity_id", false];
        private _isVehicle = _x getVariable ["r3_is_vehicle", true];
        private _isValid = true;
        private _isKeyFrame = (round time % GVAR(secondsBetweenKeyFrames) == 0);

        DBUG(format[ARR_2("time:%1 between:%2 calculated:%3", time, GVAR(secondsBetweenKeyFrames), (time % GVAR(secondsBetweenKeyFrames) == 0))], _functionLogName);

        // This is the first time we've seen this unit,
        // lets do some one time calculations
        if (_entityId isEqualTo false) then {

            // This is an infantry unit
            if (_x isKindOf "CaManBase") then {
                _isVehicle = false;
            };

            // Let's never touch objects that aren't living or a drivable vehicle
            if (_x isKindOf "Logic" || (_isVehicle && _x isKindOf "WeaponHolderSimulated")) then {
                _x setVariable ["r3_do_not_track", true];
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

                // We don't want to track units when they are in a vehicle
                if (isNull objectParent _x) then {
                    [_entityId, _x, _isKeyFrame] call FUNC(dbInsertInfantryPosition);
                }
            } else {
                [_entityId, _x, _isKeyFrame] call FUNC(dbInsertVehiclePosition);
            };
        };
    }; // do not track
} forEach _allUnitsAndVehicles;
