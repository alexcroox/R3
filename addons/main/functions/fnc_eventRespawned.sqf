/*
 * Author: Titan
 * Event fired when unit respawns
 *
 * Arguments:
 * 0: newEntity <OBJECT>
 * 1: oldEntity <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_newEntity, _oldEntity] call FUNC(eventRespawned);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventRespawned";

params [
    ["_newEntity", objNull],
    ["_oldEntity", objNull]
];

// We only want to handle ai or players respawning
if ( (_newEntity isEqualTo ObjNull) or !(getObjectType _newEntity isEqualTo 8) ) exitWith {};

// Reset eventsSetup flag
_newEntity setVariable ["eventsSetup", false, false];

DBUG("Unit respawned", _functionLogName);
