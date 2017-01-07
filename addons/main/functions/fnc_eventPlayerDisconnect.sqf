/*
 * Author: Titan
 * Event fired when player disconnects
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
 * [id, uid, name, jip, owner] call FUNC(eventPlayerDisconnect);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventPlayerDisconnect";

params [
    ["_id", objNull],
    ["_uid", ""]
];

if !(GVAR(logEvents)) exitWith {};

if (_uid == "") exitWith {};

private _json = format['{"id": "%1"}', _uid];

// Send the json to our extension for saving to the db
["player_disconnected", _json, _uid] call FUNC(dbInsertEvent);

//DBUG(format[ARR_2("Player disconnected: %1", _name)], _functionLogName);