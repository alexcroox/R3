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

if (GVAR(noPlayers) || !GVAR(logEvents)) exitWith {};

if (_victim isEqualTo objNull) exitWith {};

private _attackerPos = getPosWorld _attacker;

private _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon vehicle _attacker) >> "DisplayName");
// Remove any rogue double quotes that mess with json
_attackerWeapon = (_attackerWeapon splitString """") joinString "";

private _attackerAmmoType = (
    _ammo call {
        private _type = getText (configFile >> "CfgAmmo" >> _this >> "simulation");
        _type = switch (_type) do {
            case "shotRocket" : {"Rocket"};
            case "shotMissile" : {"Missile"};
        };
        _type
    }
);

// Form JSON for saving
private _json = format['{"pos":%1,"weapon":"%2","ammoType":"%3"}',
    _attackerPos,
    _attackerWeapon,
    _attackerAmmoType
];

private _entityA = _victim getVariable ["r3_entity_id", 0];
private _entityB = _attacker getVariable ["r3_entity_id", 0];

// Send the json to our extension for saving to the db
["incoming_missile", _entityA, _entityB, _attackerAmmoType, _json] call FUNC(dbInsertEvent);
