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

if ( (GVAR(noPlayers) || !GVAR(logEvents)) && !(GVAR(forceLogEvents)) ) exitWith {};

// Let's debounce multiple unconscious events firing for this unit
private _lastUnconsciousTime = _unit getVariable ["lastUnconscious", 0];

if (_lastUnconsciousTime > (time - 10)) exitWith {};

private _attacker = _unit getVariable ["lastAttacker", _unit];

private _eventType = switch(_state) do {
    case TRUE : { "unconscious" };
    case FALSE : { "awake" };
};

_unit setVariable ["lastUnconscious", time, false];

private _sameFaction = false;
private _attackerVehicle = 0;

private _entityVictim = _unit getVariable ["r3_entity_id", 0];
private _entityAttacker = _attacker getVariable ["r3_entity_id", 0];

// Let's only log weapons when they are downed, not when they awake
if (_state) then {
    private _formatedShotData = [_unit, _attacker] call FUNC(shotTemplate);

    private _attackerWeapon = _formatedShotData select 0;
    private _attackerDistance = _formatedShotData select 1;

    private _victimFaction = _victim call FUNC(calcSideInt);
    private _attackerFaction = _attacker call FUNC(calcSideInt);

    if !(vehicle _attacker isEqualTo _attacker) then {
        _attackerVehicle = (vehicle _attacker) getVariable ["r3_entity_id", 0];
    };

    if (_victimFaction isEqualTo _attackerFaction) then {
        _sameFaction = true;
    };

    // Store the weapons used to down this unit for later killed events
    _unit setVariable ["attackerWeapon", _attackerWeapon, false];
    _unit setVariable ["attackerDistance", _attackerDistance, false];
    _unit setVariable ["attackerEntity", _entityAttacker, false];
    _unit setVariable ["attackerSameFaction", _sameFaction, false];
    _unit setVariable ["attackerVehicle", _attackerVehicle, false];

    _unit setVariable ["isUnconscious", true, false];

} else {
    private _attackerWeapon = "";
    private _attackerDistance = 0;

    // Unset our previous variables
    _unit setVariable ["attackerWeapon", nil, false];
    _unit setVariable ["attackerDistance", nil, false];
    _unit setVariable ["attackerEntity", nil, false];
    _unit setVariable ["attackerSameFaction", nil, false];

    _unit setVariable ["isUnconscious", false, false];
};

private _data = [
    GVAR(missionId),
    time,
    _eventType,
    _entityAttacker,
    _entityVictim,
    _sameFaction,
    _attackerDistance,
    _attackerWeapon
];

// Send the data to the extension
private _saveData = GVAR(extensionName) callExtension ["events_downed", _data];
