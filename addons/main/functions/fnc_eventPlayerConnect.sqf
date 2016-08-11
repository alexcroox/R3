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

if (_uid == "") exitWith { DBUG(format[ARR_2("No player UID, ignoring connect event %1", _id)], _functionLogName); };

// We only want to show notifications for JIP players
if (_jip) then {

    private _json = format['
        {
            "unit": "%1",
            "id": "%2"
        }',
        _id,
        _uid
    ];

    // Add it to our event buffer for saving
    GVAR(eventSavingQueue) pushBack [_uid, "player_connected", _json, time];

    DBUG(format[ARR_2("Player connected: %1", _name)], _functionLogName);
};


