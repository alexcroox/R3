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

// We only want to log ai or players being killed, not fences being run over!
if ( (_attacker isEqualTo ObjNull) or !(getObjectType _victim isEqualTo 8) ) exitWith {};

// Only add ACE3 event handlers if ACE is loaded server side
if (!isNull (configFile >> "CfgPatches" >> "ace_main")) then {

    // We need to get the attacker reliably
    _attacker = if (isNull _attacker) then {
        _victim getVariable ["ace_medical_lastDamageSource", _attacker];
    } else { _attacker };
};

private _formatedShotData = [_victim, _attacker] call FUNC(shotTemplate);

private _victimUid = _formatedShotData select 0;
private _json = _formatedShotData select 1;

// Save details to db
GVAR(eventSavingQueue) pushBack [_victimUid, "unit_killed", _json, time];

//DBUG("Unit killed and saved to db", _functionLogName);
