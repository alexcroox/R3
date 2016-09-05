/*
 * Author: Titan
 * Return formatted shot data (victim/attacker details)
 *
 * Arguments:
 * 0: victim <OBJECT>
 * 1: attacker <OBJECT>
 *
 * Return Value:
 * see last line?
 *
 * Example:
 * [_victim, _attacker] call FUNC(shotTemplate);
 *
 * Public: No
 */

params [
    ["_victim", objNull],
    ["_attacker", objNull]
];

diag_log format["shot %1", _victim];

// Victim details
private _victimUid = getPlayerUID _victim;
private _victimPos = getPos _victim;
private _victimType = getText (configFile >> "CfgVehicles" >> (typeOf _victim) >> "DisplayName");
private _victimFaction = _victim call FUNC(calcSideInt);

// Attacker details
private _attackerPos = getPos _attacker;
private _attackerType = getText (configFile >> "CfgVehicles" >> (typeOf _attacker) >> "DisplayName");
private _attackerFaction = _attacker call FUNC(calcSideInt);
private _attackerDistance = round (getPos _victim distance getPos _attacker);

if (vehicle _attacker == _attacker) then {
    private _attackerUid = getPlayerUID _attacker;
} else {
    private _attackerUid = getPlayerUID gunner vehicle _attacker;
};

if(vehicle _attacker == _attacker) then {
    private _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon _attacker) >> "DisplayName")
} else {
    private _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon vehicle _attacker) >> "DisplayName")
};

// Form JSON for saving
private _json = format['
    {
        "victim": {
            "unit": "%1",
            "id": "%2",
            "pos": %3,
            "type": "%4",
            "faction": %5
        },
        "attacker": {
            "unit": "%6",
            "id": "%7",
            "pos": %8,
            "type": "%9",
            "faction": %10,
            "weapon": "%11",
            "distance": %12
        }
    }',
    _victim,
    _victimUid,
    _victimPos,
    _victimType,
    _victimFaction,
    _attacker,
    _attackerUid,
    _attackerPos,
    _attackerType,
    _attackerFaction,
    _attackerWeapon,
    _attackerDistance
];

[_victimUid, _json];
