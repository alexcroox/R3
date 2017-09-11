/*
 * Author: Titan
 * Save infantry position
 *
 * Arguments:
 * [0] _entityId <INTEGER>
 * [1] _unit <OBJECT>
 * [2] _isKeyFrame <INTEGER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["_entityId", "_unit"] call FUNC(dbInsertInfantryPosition);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbInsertInfantryPosition";

params [
    ["_entityId", 0],
    ["_unit", ""],
    ["_isKeyFrame", 0]
];

private _unitPos = getPosWorld _x;
private _unitPosX = _unitPos select 0;
private _unitPosY = _unitPos select 1;
private _unitHeading = round getDir _x;

private _previousUnitPosX = _x getVariable ["r3_pos_x", 0];
private _previousUnitPosY = _x getVariable ["r3_pos_y", 0];
private _previousUnitHeading = _x getVariable ["r3_heading", 0];

private _hasMovedEnough = true;
private _distanceMoved = round ([_previousUnitPosX, _previousUnitPosY] distance2D [_unitPosX, _unitPosY]);

if (_distanceMoved < 2) then {
    _hasMovedEnough = false;
};

private _hasLookedAroundEnough = true;
private _headingDifference = abs (_unitHeading - _previousUnitHeading);

if (_headingDifference < 30) then {
    _hasLookedAroundEnough = false;
};

// If the unit's position has changed lets log it
if (_isKeyFrame isEqualTo 1 || _hasMovedEnough || _hasLookedAroundEnough) then {

    _x setVariable ["r3_pos_x", _unitPosX];
    _x setVariable ["r3_pos_y", _unitPosY];
    _x setVariable ["r3_heading", _unitHeading];

    // Send infantry position to the extension
    private _query = [["infantry_positions", GVAR(missionId), _entityId, _unitPosX, _unitPosY, _unitHeading, _isKeyFrame, time], GVAR(extensionSeparator)] call CBA_fnc_join;
    call compile (GVAR(extensionName) callExtension _query);
};
