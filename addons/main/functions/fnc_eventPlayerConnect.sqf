/*
 * Author: Titan
 * Event fired when player connects
 *
 * Arguments:
 * 0: id : Number - unique DirectPlay ID (very large number). It is also the same id used for user placed markers (same as _id param)
 * 1: uid: String - getPlayerUID of the joining client. The same as Steam ID (same as _uid param)
 * 2: name: String - profileName of the joining client (same as _name param)
 * 3: jip: Boolean - didJIP of the joining client (same as _jip param)
 * 4: owner: Number - owner id of the joining client (same as _owner param)
 *
 * Return Value:
 * None
 *
 * Example:
 * [id, uid, name, jip, owner] call FUNC(eventPlayerConnect);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventPlayerConnect";

params [
    ["_id", objNull],
    ["_uid", ""],
    ["_name", "Unknown"],
    ["_jip", false]
];

if ( !GVAR(logEvents) && !(GVAR(forceLogEvents)) ) exitWith {};

// If we don't have the player's UID lets exit
if (_uid == "") exitWith {};

// We only want to show notifications for JIP players
if (_jip) then {

    private _eventType = "connect";

    // Send the query to the extension
    private _query = [["events_connections", GVAR(missionId), time, _eventType, _uid, _name], GVAR(extensionSeparator)] call CBA_fnc_join;
    call compile (GVAR(extensionName) callExtension _query);
};