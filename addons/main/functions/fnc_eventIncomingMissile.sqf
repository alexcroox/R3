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
 * call FUNC(eventIncomingMissile);
 *
 * Public: No
 */

#include "script_component.hpp"
_functionLogName = "AAR > eventIncomingMissile";

private ["_victim", "_ammo", "_attacker"];
_victim = param [0, objNull];
_ammo = param [1, ""];
_attacker = param [2, objNull];

if (_victim isEqualTo objNull) exitWith { DBUG(format[ARR_2("No unit, ignoring missile event %1", _ammo)], _functionLogName); };

_victimUid = getPlayerUID _victim;
_attackerUid = getPlayerUID _attacker;
_attackerPos = getPos _attacker;
_attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon vehicle _attacker) >> "DisplayName");
_attackerAmmoType = (
    _ammo call {
        _type = getText (configFile >> "CfgAmmo" >> _this >> "simulation");
        _type = switch (_type) do {
            case "shotRocket" : {"Rocket"};
            case "shotMissile" : {"Missile"};
        };
        _type
    }
);

// Form JSON for saving
_json = format['
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

// Add it to our event buffer for saving
GVAR(eventSavingQueue) pushBack [_victimUid, "incoming_missile", _json, time];

DBUG(format[ARR_2("Incoming missile: %1", _victim)], _functionLogName);


