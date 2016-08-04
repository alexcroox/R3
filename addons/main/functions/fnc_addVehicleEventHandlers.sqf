/*
 * Author: Titan
 * Setup vehicle event handlers
 *
 * Arguments:
 * 0: vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(addVehicleEventHandlers);
 *
 * Public: No
 */

#include "script_component.hpp"
_functionLogName = "AAR > addVehicleEventHandlers";

private ["_vehicle"];
_vehicle = param [0, objNull];

_isSetupAlready = _vehicle getVariable ["eventsSetup", false];

if !(_isSetupAlready) then {

    _vehicle setVariable ["eventsSetup", true, false];

    if(_vehicle isKindOf "Air") then {
        _vehicle addEventHandler ["IncomingMissile", FUNC(eventIncomingMissile)];
    };
};
