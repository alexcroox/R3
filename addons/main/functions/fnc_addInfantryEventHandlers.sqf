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

    // Let's remove the existing EHs incase eventsSetup variable lies to us
    _unit removeAllEventHandlers "MPHit";

    _unit setVariable ["eventsSetup", true, false];

    _unit addMPEventHandler ["MPHit", FUNC(eventHit)];

    // Only add ACE3 event handlers if ACE is loaded server side
    if (!isNull (configFile >> "CfgPatches" >> "ace_main")) then {
        ["ace_unconscious", FUNC(eventUnconscious)] call CBA_fnc_addEventHandler;
    };
};
