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

if ( (GVAR(noPlayers) || !GVAR(logEvents)) && !(GVAR(forceLogEvents)) ) exitWith {};

// Handle respawnOnStart
if (_victim == objNull) exitWith {};

// We only want to log ai or players being killed, not fences being run over!
if (
    (_attacker isEqualTo ObjNull) ||
    !(
        _victim isKindOf "CaManBase" ||
        _victim isKindOf "LandVehicle" ||
        _victim isKindOf "Air" ||
        _victim isKindOf "Ship" ||
        _victim isKindOf "Boat"
    )
) exitWith {};

if (_victim == _attacker) then {
    _attacker = _victim getVariable ["lastAttacker", _victim];
};

private _formatedShotData = [_victim, _attacker] call FUNC(shotTemplate);

private _attackerWeapon = _formatedShotData select 0;
private _attackerDistance = _formatedShotData select 1;

private _entityVictim = _victim getVariable ["r3_entity_id", 0];
private _entityAttacker = _attacker getVariable ["r3_entity_id", 0];

private _victimFaction = _victim call FUNC(calcSideInt);
private _attackerFaction = _attacker call FUNC(calcSideInt);
private _sameFaction = 0;

if (_victimFaction isEqualTo _attackerFaction) then {
    _sameFaction = 1;
};

if (_entityVictim == 0) then {
    diag_log format["Invalid victim %1", _victim];
};

private _eventType = "killed";

// Send the query to the extension
private _query = [["events_downed", GVAR(missionId), time, _eventType, _entityAttacker, _entityVictim, _sameFaction, _attackerDistance, _attackerWeapon], GVAR(extensionSeparator)] call CBA_fnc_join;
call compile (GVAR(extensionName) callExtension _query);
