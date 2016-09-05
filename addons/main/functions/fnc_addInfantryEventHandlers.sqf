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

    _unit addEventHandler ["GetInMan", FUNC(eventGetIn)];

    // Only add ACE3 event handlers if ACE is loaded server and client side
    if (!isNull (configFile >> "CfgPatches" >> "ace_main")) then {
        ["ace_unconscious", FUNC(eventUnconscious)] call CBA_fnc_addEventHandler;
    };
};
