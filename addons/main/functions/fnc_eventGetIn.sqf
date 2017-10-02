/*
 * Author: Titan
 * Event fired when unit gets in a vehicle
 *
 * Arguments:
 * 0: vehicle: Object - Vehicle the unit entered
 * 1: position: String - Can be either "driver", "gunner" or "cargo"
 * 2: unit: Object - Unit the event handler is assigned to
 * 3: turret: Array - turret path
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(eventGetIn);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventGetIn";

params [
    ["_vehicle", objNull],
    ["_position", "driver"],
    ["_unit", objNull]
];

if ( (GVAR(noPlayers) || !GVAR(logEvents)) && !(GVAR(forceLogEvents)) ) exitWith {};

if (_unit isEqualTo objNull) exitWith {};

private _entityUnit = _unit getVariable ["r3_entity_id", 0];
private _entityVehicle = _vehicle getVariable ["r3_entity_id", 0];

private _type = "get_in";

private _data = [
    GVAR(missionId),
    round time,
    _type,
    _entityUnit,
    _entityVehicle
];

// Send the data to the extension
private _saveData = GVAR(extensionName) callExtension ["events_get_in_out", _data];
