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
 * [_victim, _attacker] call FUNC(eventKilled);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventKilled";

params [
    ["_victim", objNull],
    ["_attacker", objNull]
];

if (GVAR(noPlayers) || !GVAR(logEvents)) exitWith {};

// Handle respawnOnStart
if (_victim == objNull) exitWith {};

// We only want to log ai or players being killed, not fences being run over!
if ( (_attacker isEqualTo ObjNull) || !(_victim isKindOf "CaManBase" || _victim isKindOf "LandVehicle" || _victim isKindOf "Air" || _victim isKindOf "Ship" || _victim isKindOf "Boat") ) exitWith {};

if (_victim == _attacker) then {
    _attacker = _victim getVariable ["lastAttacker", _victim];
};

private _formatedShotData = [_victim, _attacker] call FUNC(shotTemplate);

private _attackerWeapon = _formatedShotData select 0;
private _attackerDistance = _formatedShotData select 1;


private _entityA = _victim getVariable ["r3_entity_id", 0];
private _entityB = _attacker getVariable ["r3_entity_id", 0];

// Send the json to our extension for saving to the db
["unit_killed", _entityA, _entityB, _attackerWeapon, _attackerDistance] call FUNC(dbInsertEvent);
