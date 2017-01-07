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

private _victimUid = getPlayerUID _victim;
private _attackerUid = getPlayerUID _attacker;
private _attackerPos = getPos _attacker;
private _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon vehicle _attacker) >> "DisplayName");
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
private _json = format['
    {
        "victim": {
            "unit": "%1",
            "id": "%2"
        },
        "attacker": {
            "unit": "%3",
            "id": "%4",
            "pos": %5,
            "weapon": "%6",
            "ammoType": "%7"
        }
    }',
    _victim,
    _victimUid,
    _attacker,
    _attackerUid,
    _attackerPos,
    _attackerWeapon,
    _attackerAmmoType
];

// Send the json to our extension for saving to the db
["incoming_missile", _json, _victimUid] call FUNC(dbInsertEvent);


