/*
 * Author: Titan
 * Prep event data for sending to db extension
 *
 * Arguments:
 * 0: type <STRING>
 * 1: data <STRING>
 * 2: playerId <INT>
 *
 * Return Value:
 * none
 *
 * Example:
 * ["positions_vehicles", _json] call FUNC(dbInsertEvent);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbInsertEvent";

params [
    ["_type", ""],
    ["_data", ""],
    ["_playerId", 0]
];

// Send the query to the extension
private _query = [["event", GVAR(replayId), _playerId, _type, _data, time], GVAR(extensionSeparator)] call CBA_fnc_join;
call compile (GVAR(extensionName) callExtension _query);