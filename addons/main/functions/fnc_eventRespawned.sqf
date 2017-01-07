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

if (GVAR(noPlayers) || !GVAR(logEvents)) exitWith {};

// We only want to handle ai or players respawning
if ( (_newEntity isEqualTo ObjNull) or !(getObjectType _newEntity isEqualTo 8) ) exitWith {};

// Reset eventsSetup flag for infantry only (vehicles lose their EH's on respawn, units do not)
if (_newEntity isKindOf "Man") then {

    diag_log format["Infantry respawned %1", _newEntity];

    _newEntity setVariable ["eventsSetup", true, false];

    // ACE unconcious EH gets overwritten on respawn so we need to re-assign it
    [_newEntity] call FUNC(addInfantryACEEventHandlers);
};

DBUG("Unit respawned", _functionLogName);
