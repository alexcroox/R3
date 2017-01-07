/*
 * Author: Titan
 * Event fired when unit hit. We store the attacker on the unit
 * because we cannot reliably get unit's attacker when ACE is used
 *
 * Arguments:
 * 0: victim <OBJECT>
 * 1: attacker <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_victim, _attacker] call FUNC(eventHit);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventHit";

params [
    ["_victim", objNull],
    ["_attacker", objNull]
];

if (GVAR(noPlayers) || !GVAR(logEvents)) exitWith {};

_victim setVariable ["lastAttacker", _attacker, false];
