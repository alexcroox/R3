/*
 * Author: Titan
 * Loop for saving mission update time to assist with mission length
 * calculations and for blocking the viewing of missions in progress
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(missionUpdateLoop);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > missionUpdateLoop";

DBUG("Starting mission update loop", _functionLogName);

[{
    if ( (GVAR(noPlayers) || !GVAR(logEvents)) && !(GVAR(forceLogEvents)) ) exitWith {};

    private _data = [
        GVAR(missionId),
        round time
    ];

    // Send the data to the extension
    private _saveData = GVAR(extensionName) callExtension ["update_mission", _data];

}, 10] call CBA_fnc_addPerFrameHandler;
