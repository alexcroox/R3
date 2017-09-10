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

    // Send the query to the extension
    private _query = [["update_replay", GVAR(missionId), round time], GVAR(extensionSeparator)] call CBA_fnc_join;
    call compile (GVAR(extensionName) callExtension _query);

}, 10] call CBA_fnc_addPerFrameHandler;
