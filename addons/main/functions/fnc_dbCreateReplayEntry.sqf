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
private _functionLogName = "AAR > dbCreateReplayEntry";

// Send the query to the extension
private _query = [["replay", missionName, worldName, daytime, QUOTE(VERSION)], GVAR(extensionSeparator)] call CBA_fnc_join;
private _insertResult = call compile ("R3DBConnector" callExtension _query);

if ((_queryResult select 0) isEqualTo 0) exitWith { DBUG(format[ARR_2("Failed to get replay insert Id %1", _queryResult)], _functionLogName); };

GVAR(replayId) = _insertResult select 2;

["replaySetup"] call CBA_fnc_localEvent;

DBUG(format[ARR_2("Replay db entry setup %1", GVAR(replayId))], _functionLogName);
