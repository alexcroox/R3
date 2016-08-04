/*
 * Author: Titan
 * Event fired when unit killed
 *
 * Arguments:
 * 0: victim <OBJECT>
 * 1: attacker <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(eventKilled);
 *
 * Public: No
 */

#include "script_component.hpp"
_functionLogName = "AAR > eventKilled";

private ["_victim", "_attacker"];
_victim = param [0, ObjNull, [ObjNull]];
_attacker = param [1, ObjNull, [ObjNull]];

// We only want to log ai or players being killed, not fences being run over!
if ( (_attacker isEqualTo ObjNull) or !(getObjectType _victim isEqualTo 8) ) exitWith {};

// Victim details
_victimUid = getPlayerUID _victim;
_victimPos = getPos _victim;
_victimType = getText (configFile >> "CfgVehicles" >> (typeOf _victim) >> "DisplayName");
_victimFaction = _victim call FUNC(calcSideInt);

// Attacker details
_attackerPos = getPos _attacker;
_attackerType = getText (configFile >> "CfgVehicles" >> (typeOf _attacker) >> "DisplayName");
_attackerFaction = _attacker call FUNC(calcSideInt);
_attackerDistance = round (getPos _victim distance getPos _attacker);

if (vehicle _attacker == _attacker) then {
    _attackerUid = getPlayerUID _attacker;
} else {
    _attackerUid = getPlayerUID gunner vehicle _attacker;
};

if(vehicle _attacker == _attacker) then {
    _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon _attacker) >> "DisplayName")
} else {
    _attackerWeapon = getText (configFile >> "CfgWeapons" >> (currentWeapon vehicle _attacker) >> "DisplayName")
};

// Form JSON for saving
_json = format['
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

// Save details to db
GVAR(eventSavingQueue) pushBack [_victimUid, "unit_killed", _json, time];

//DBUG("Unit killed and saved to db", _functionLogName);
