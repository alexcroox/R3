/*
 * Author: Titan
 * Save player to players table
 *
 * Arguments:
 * [0] _uid <STRING>
 * [1] _name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["_unit"] call FUNC(dbSavePlayer);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbSavePlayer";

params [
    ["_uid", ""],
    ["_name", "Unknown"]
];

// We only want to save this player once
if (_uid == "" || _uid in GVAR(playerSavedIds)) exitWith {};

GVAR(playerSavedIds) pushBack _uid;

// Send the query to the extension
private _query = format["%1¤¤¤%2¤¤¤%3", "playerUpdate", _uid, _name];
call compile ("R3DBConnector" callExtension _query);

DBUG(format[ARR_2("Saved player to db: %1", _name)], _functionLogName);
