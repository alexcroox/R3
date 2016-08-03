/*
 * Author: Titan
 * Inserts replay entry into database
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(dbCreateReplayEntry);
 *
 * Public: No
 */

#include "script_component.hpp"
_functionLogName = "AAR > dbCreateReplayEntry";

_query = str formatText["2:SQL:INSERT INTO replays (missionName, map, dateStarted) VALUES ('%1', '%2', NOW()); SELECT LAST_INSERT_ID();", missionName, worldName];
_setupReplay = call compile ("extDB3" callExtension _query);

diag_log _setupReplay;

if !((_setupReplay select 0) isEqualTo 2) exitWith { DBUG("Failed to setup replay ID", _functionLogName); };

_query = str formatText["4:%1", _setupReplay select 1];

// We need to wait for the query to return, if it hasn't returned yet we will receive [3] (wait)
waitUntil {

    _replayId = call compile ("extDB3" callExtension _query);

    diag_log format["check %1 - %2", _query, _replayId];

    if !((_replayId select 0) isEqualTo 3) then {

        GVAR(replayId) = _replayId select 1;
        TRUE;
    } else {
        FALSE;
    }
};

// Raise event here?
["dbSetup"] call CBA_fnc_localEvent;

DBUG(format[ARR_2("Replay db entry setup %1", GVAR(replayId))], _functionLogName);
