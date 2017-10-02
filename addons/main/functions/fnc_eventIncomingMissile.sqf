/*
 * Author: Titan
 * Event fired when vehicle has incoming missile
 *
 * Arguments:
 * 0: unit: Object - Object the event handler is assigned to
 * 1: ammo: String - Ammo type that was fired on the unit
 * 2: whoFired: Object - Object that fired the weapon
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, _ammo, _whoFired] call FUNC(eventIncomingMissile);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventIncomingMissile";

params [
    ["_victim", objNull],
    ["_ammo", ""],
    ["_attacker", objNull]
];

if ( (GVAR(noPlayers) || !GVAR(logEvents)) && !(GVAR(forceLogEvents)) ) exitWith {};

if (_victim isEqualTo objNull) exitWith {};

private _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon vehicle _attacker) >> "DisplayName");
// Remove any rogue double quotes that mess with json
_attackerWeapon = (_attackerWeapon splitString """") joinString "";

private _attackerAmmoType = (
    _ammo call {
        private _type = getText (configFile >> "CfgAmmo" >> _this >> "simulation");
        _type = switch (_type) do {
            case "shotRocket" : {"rocket"};
            case "shotMissile" : {"missile"};
        };
        _type
    }
);

private _entityVictim = _victim getVariable ["r3_entity_id", 0];
private _entityAttacker = _attacker getVariable ["r3_entity_id", 0];

private _data = [
    GVAR(missionId),
    round time,
    _attackerAmmoType,
    _entityAttacker,
    _entityVictim,
    _attackerWeapon
];

// Send the data to the extension
private _saveData = GVAR(extensionName) callExtension ["events_missile", _data];
