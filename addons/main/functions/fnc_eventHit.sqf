/*
 * Author: Titan
 * Event fired when unit hit. We store the attacker on the unit
 * because we cannot reliably get unit's attacker when ACE is used
 *
 * Arguments:
 * 0: victim <OBJECT>
 * 1: attacker <OBJECT>
 * 2: damage <INTEGER>
 * 3: instigator <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_victim, _attacker, _damage, _instigator] call FUNC(eventHit);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventHit";

params [
    ["_victim", objNull],
    ["_causedBy", objNull],
    ["_damage", 0],
    ["_instigator", objNull]
];

if ( (GVAR(noPlayers) || !GVAR(logEvents)) && !(GVAR(forceLogEvents)) ) exitWith {};

_victim setVariable ["lastAttacker", _instigator, false];
