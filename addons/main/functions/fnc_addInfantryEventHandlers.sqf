/*
 * Author: Titan
 * Setup unit event handlers
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit] call FUNC(addInfantryEventHandlers);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > addInfantryEventHandlers";

params [
    ["_unit", objNull]
];

private _isSetupAlready = _unit getVariable ["eventsSetup", false];

if !(_isSetupAlready) then {

    _unit setVariable ["eventsSetup", true, false];

    _unit addMPEventHandler ["MPHit", FUNC(eventHit)];
    _unit addEventHandler ["IncomingMissile", FUNC(eventIncomingMissile)];

    _unit addEventHandler ["Fired", FUNC(eventFired)];

    [_unit] call FUNC(addInfantryACEEventHandlers);
};
