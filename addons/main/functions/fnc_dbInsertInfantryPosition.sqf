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

private _unitPos = getPosWorld _unit;
private _unitPosX = _unitPos select 0;
private _unitPosY = _unitPos select 1;
private _unitHeading = round getDir _unit;

private _previousUnitPosX = _unit getVariable ["r3_pos_x", 0];
private _previousUnitPosY = _unit getVariable ["r3_pos_y", 0];
private _previousUnitHeading = _unit getVariable ["r3_heading", 0];

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

    private _isDead = 0;
    private _isUnconcious = _unit getVariable ["isUnconscious", false];

    if (!alive _unit || _isUnconcious) then {
        _isDead = 1;
    };

    _unit setVariable ["r3_pos_x", _unitPosX];
    _unit setVariable ["r3_pos_y", _unitPosY];
    _unit setVariable ["r3_heading", _unitHeading];

    private _data = [
        GVAR(missionId),
       _entityId,
       _unitPosX,
       _unitPosY,
       _unitHeading,
       _isKeyFrame,
       _isDead,
       round time
    ];

    // Send the data to the extension
    private _saveData = GVAR(extensionName) callExtension ["infantry_positions", _data];
};
