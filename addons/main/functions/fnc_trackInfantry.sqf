/*
 * Author: Titan
 * Loops through all infantry units on the map and saves to db event buffer
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(movementsInfantry);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > movementsInfantry";

// We have a string length limit with our database extension so we need to break up
// large amounts of units into multiple calls
private _unitCount = 0;
private _movementData = "";

// Loop through all units on the map
{
    [_x] call FUNC(addInfantryEventHandlers);

    if (vehicle _x == _x) then {

        private _unitUid = getPlayerUID _x;
        private _unitPos = getPos _x;
        private _unitDirection = round getDir _x;
        private _unitIcon = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "icon");
        private _unitFaction = _x call FUNC(calcSideInt);
        private _unitGroupId = groupID group _x;
        private _unitIsLeader = (if((leader group _x) == _x) then { true } else { false });

        // Form JSON for saving
        // It sucks we have to use such abbreviated keys but we need to save as much space as pos!
        private _singleUnitMovementData = format['
            {
                "unit": "%1",
                "id": "%2",
                "pos": %3,
                "dir": %4,
                "ico": "%5",
                "fac": "%6",
                "grp": "%7",
                "ldr": "%8"
            }',
            _x,
            _unitUid,
            _unitPos,
            _unitDirection,
            _unitIcon,
            _unitFaction,
            _unitGroupId,
            _unitIsLeader
        ];

        // We don't want leading commas in our JSON
        private _seperator = if (_movementData == "") then { "" } else { "," };

        // Combine this unit's data with our current running movements data
        _movementData = [[_movementData, _singleUnitMovementData], _seperator] call CBA_fnc_join;

        _unitCount = _unitCount + 1;

        // If we've reached our limit for the number of units in a single db entry lets flush and continue
        if (_unitCount == GVAR(maxUnitCountPerEvent)) then {

            // Save details to db
            private _movementDataJsonArray = format["[%1]", _movementData];
            GVAR(eventSavingQueue) pushBack [0, "positions_infantry", _movementDataJsonArray, time];

            _unitCount = 0;
            _movementData = "";
        };
    };
} forEach allUnits;

// Do we still have outstanding unit movements we need to save?
if (_movementData != "") then {
    private _movementDataJsonArray = format["[%1]", _movementData];
    GVAR(eventSavingQueue) pushBack [0, "positions_infantry", _movementDataJsonArray, time];
};
