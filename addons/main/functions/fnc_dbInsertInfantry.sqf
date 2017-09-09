/*
 * Author: Titan
 * Save unit to infantry table
 *
 * Arguments:
 * [0] _entityId <INTEGER>
 * [1] _unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["_entityId", "_unit"] call FUNC(dbInsertInfantry);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbInsertInfantry";

params [
    ["_entityId", 0],
    ["_unit", ""]
];

private _unitUid = getPlayerUID _unit;
private _unitName = name _unit;
private _unitIconRaw = getText (configFile >> "CfgVehicles" >> (typeOf _unit) >> "icon");
private _unitIcon = _unitIconRaw splitString "\" joinString "";
private _unitFaction = _unit call FUNC(calcSideInt);
private _unitClass = getText (configFile >> "CfgVehicles" >> (typeOf _unit) >> "DisplayName");
private _unitGroupId = groupID group _unit;
private _unitIsLeader = (if((leader group _unit) == _unit) then { 1 } else { 0 });
private _unitData = "";
private _unitWeapon = primaryWeapon _unit;
private _unitLauncher = secondaryWeapon _unit;

// Send the query to the extension
private _query = [["infantry", GVAR(missionId), _unitUid, _entityId, _unitName, _unitFaction, _unitClass, _unitGroupId, _unitIsLeader, _unitIcon, _unitWeapon, _unitLauncher, _unitData, time], GVAR(extensionSeparator)] call CBA_fnc_join;
call compile (GVAR(extensionName) callExtension _query);
