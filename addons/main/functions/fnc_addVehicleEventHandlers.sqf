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
 * [_vehicle] call FUNC(addVehicleEventHandlers);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > addVehicleEventHandlers";

params [
    ["_vehicle", objNull]
];

private _isSetupAlready = _vehicle getVariable ["eventsSetup", false];

if !(_isSetupAlready) then {

    // Let's remove the existing EHs incase eventsSetup variable lies to us
    _vehicle removeAllEventHandlers "GetIn";

    _vehicle setVariable ["eventsSetup", true, false];

    _vehicle addEventHandler ["GetIn", FUNC(eventGetIn)];

    if(_vehicle isKindOf "Air") then {
        _vehicle addEventHandler ["IncomingMissile", FUNC(eventIncomingMissile)];
    };
};
