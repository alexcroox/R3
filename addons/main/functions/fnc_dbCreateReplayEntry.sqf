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

_query = str formatText["2:SQL:INSERT INTO replays (missionName, map, dateStarted) VALUES ('%1', '%2', NOW())", missionName, worldName];
_setupReplay = call compile ("extDB3" callExtension _query);

diag_log _setupReplay;

if !((_setupReplay select 0) isEqualTo 2) exitWith { DBUG("Failed to setup replay ID", _functionLogName); };

_query = str formatText["5:%1", _setupReplay select 1];

waitUntil {

	_replayId = call compile ("extDB3" callExtension _query);

	diag_log _replayId select 0;

	((_replayId select 0) isEqualTo 1);
};

diag_log _replayId;

DBUG("Replay db entry setup", _functionLogName);