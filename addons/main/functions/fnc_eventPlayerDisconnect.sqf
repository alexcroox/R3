/*
 * Author: Titan
 * Event fired when player disconnects
 *
 * Arguments:
 * 0: unit: Unit formerly occupied by player
 * 1: id : Number - unique DirectPlay ID (very large number). It is also the same id used for user placed markers (same as _id param)
 * 2: uid: String - getPlayerUID of the joining client. The same as Steam ID (same as _uid param)
 * 3: name: String - profileName of the joining client (same as _name param)
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
    ["_unit", objNull],
    ["_id", objNull],
    ["_uid", ""],
    ["_name", ""]
];

if ( !GVAR(logEvents) && !(GVAR(forceLogEvents)) ) exitWith {};

if (_uid == "") exitWith {};

private _eventType = "disconnect";

private _data = [
    GVAR(missionId),
    time,
    _eventType,
    _uid,
    _name
];

// Send the data to the extension
private _saveData = GVAR(extensionName) callExtension ["events_connections", _data];