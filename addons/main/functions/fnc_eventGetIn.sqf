/*
 * Author: Titan
 * Event fired when unit gets in a vehicle
 *
 * Arguments:
 * 0: unit: Object - Unit the event handler is assigned to
 * 1: position: String - Can be either "driver", "gunner" or "cargo"
 * 2: vehicle: Object - Vehicle the unit entered
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
    ["_unit", objNull]
];

if (_unit isEqualTo objNull) exitWith { DBUG(format[ARR_2("Invalid unit, ignoring get in event %1", _unit)], _functionLogName); };

private _uid = getPlayerUID _unit;

private _json = format['
    {
        "unit": "%1",
        "id": "%2"
    }',
    _unit,
    _uid
];

// Add it to our event buffer for saving
GVAR(eventSavingQueue) pushBack [_uid, "get_in", _json, time];


