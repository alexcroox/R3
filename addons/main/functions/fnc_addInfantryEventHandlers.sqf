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
 * call FUNC(addInfantryEventHandlers);
 *
 * Public: No
 */

#include "script_component.hpp"
_functionLogName = "AAR > addInfantryEventHandlers";

private ["_unit"];
_unit = param [0, objNull];

_isSetupAlready = _unit getVariable ["eventsSetup", false];

if !(_isSetupAlready) then {

    _unit setVariable ["eventsSetup", true, false];

    _unit addEventHandler ["GetInMan", FUNC(eventGetIn)];
};
