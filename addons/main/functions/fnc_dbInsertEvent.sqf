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
 * ["event", _data] call FUNC(dbInsertEvent);
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

private _query = format["%1¤¤¤%2¤¤¤%3¤¤¤%4¤¤¤%5¤¤¤%6", "event", GVAR(replayId), _playerId, _type, _data call CBA_fnc_trim, time];

// Send the query to the extension
call compile ("R3DBConnector" callExtension _query);