/*
 * Author: Titan
 * Return formatted shot data (victim/attacker details)
 *
 * Arguments:
 * 0: victim <OBJECT>
 * 1: attacker <OBJECT>
 *
 * Return Value:
 * [_victimUid, _json]
 *
 * Example:
 * [_victim, _attacker] call FUNC(shotTemplate);
 *
 * Public: No
 */

#include "script_component.hpp"

params [
    ["_victim", objNull],
    ["_attacker", objNull]
];

private _attackerDistance = round (getPos _victim distance getPos _attacker);

private _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon vehicle _attacker) >> "DisplayName");

if(vehicle _attacker == _attacker) then {
    _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon _attacker) >> "DisplayName")
};

// Remove any rogue double quotes that mess with json
_attackerWeapon = (_attackerWeapon splitString """") joinString "";

[_attackerWeapon, _attackerDistance];
