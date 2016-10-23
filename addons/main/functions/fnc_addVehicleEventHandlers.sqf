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
private _doNotTrack = _vehicle getVariable ["r3_do_not_track", false];

if !(_isSetupAlready && !_doNotTrack) then {

    _vehicle setVariable ["eventsSetup", true, false];

    _vehicle addEventHandler ["GetIn", FUNC(eventGetIn)];
    _vehicle addEventHandler ["GetOut", FUNC(eventGetOut)];

    _vehicle addEventHandler ["IncomingMissile", FUNC(eventIncomingMissile)];
};
