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

private _query = format["2:SQL:playerInsert:%1:%2", _uid, _name];
private _savePlayer = call compile ("extDB3" callExtension _query);

diag_log format["Saved player to db: %1", _name];
