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

// Get all units and vehicles with a driver slot (includes turrets and parachutes etc)
private _allDrivableVehicles = vehicles select {!(fullCrew [_x, "driver", true] isEqualTo [])};
private _allUnitsAndVehicles = allUnits + allDeadMen + _allDrivableVehicles;

// Loop through all units and vehicles on the map
{
    private _doNotTrack = _x getVariable ["r3_do_not_track", false];

    if ( !(_doNotTrack) && (!(GVAR(noPlayers)) || GVAR(forceLogEvents)) ) then {

        // Store unique entity id against the unit to identify them in playback
        private _entityId = _x getVariable ["r3_entity_id", false];
        private _isVehicle = _x getVariable ["r3_is_vehicle", true];
        private _unitPreviousUID = _x getVariable ["r3_entity_uid", ""];
        private _unitUID = getPlayerUID _x;
        private _playerSpawnedIntoAIUnit = !(_unitUID isEqualTo _unitPreviousUID);
        private _isValid = true;
        private _roundedTime = round time;
        private _isKeyFrame = 0;

        if (_roundedTime % GVAR(secondsBetweenKeyFrames) == 0 && _roundedTime > 0) then {
            _isKeyFrame = 1;
        };

        // This is the first time we've seen this unit, or if a player has spawned into an AI unit,
        // lets do some one time calculations
        if (_entityId isEqualTo false || _playerSpawnedIntoAIUnit) then {

            // This is an infantry unit
            if (_x isKindOf "CaManBase") then {
                _isVehicle = false;
            };

            // Let's never touch objects that aren't living or a drivable vehicle
            if (
                _x isKindOf "Logic" ||
                _x isKindOf "WeaponHolderSimulated" ||
                _x isKindOf "Thing" ||
                (typeOf _x) find "Ejection" > -1
            ) then {
                _x setVariable ["r3_do_not_track", true];
                _isValid = false;
            };

            if (_isValid) then {

                if !(_playerSpawnedIntoAIUnit) then {

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
                } else {

                    // If a player has just assumed control of an AI infantry unit
                    // we need to update our infantry entry in the db with the player details
                    if (
                        !(_isVehicle) &&
                        !(_entityId isEqualTo false) &&
                        !(_entityId isEqualTo 0) &&
                        count _unitUID > 0
                    ) then {
                        [_entityId, _x] spawn FUNC(dbInsertInfantry);
                    };
                };

                _x setVariable ["r3_entity_uid", _unitUID];
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
