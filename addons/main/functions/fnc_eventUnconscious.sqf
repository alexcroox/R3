/*
 * Author: Titan
 * Event fired when unit goes eventUnconscious (if ACE is running on server and clients)
 *
 * Arguments:
 * 0: unit: Object - Unit the event handler is assigned to
 * 1: state: Bool - Unit's unconscious state changed (TRUE: unconscious, FALSE: awake)
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(eventUnconscious);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventUnconscious";

params [
    ["_unit", objNull],
    ["_state", FALSE]
];

private _attacker = _unit getVariable ["ace_medical_lastDamageSource", objNull];

private _formatedShotData = [_unit, _attacker] call FUNC(shotTemplate);

private _victimUid = _formatedShotData select 0;
private _json = _formatedShotData select 1;

private _eventType = switch(_state) do {
    case TRUE : { "unit_unconscious" };
    case FALSE : { "unit_awake" };
};

// Save details to db
GVAR(eventSavingQueue) pushBack [_victimUid, _eventType, _json, time];
