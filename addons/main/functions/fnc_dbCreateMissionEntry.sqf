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
 * call FUNC(dbCreateMissionEntry);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbCreateMissionEntry";

// Send the query to the extension
private _query = [["replay", missionName, worldName, daytime, QUOTE(VERSION)], GVAR(extensionSeparator)] call CBA_fnc_join;
private _insertResult = call compile (GVAR(extensionName) callExtension _query);

if ((_insertResult select 0) isEqualTo "error") exitWith {

    ERROR_SYSTEM_CHAT("The AAR tool (R3) failed to add this mission to your database, this mission will not be captured");
    DBUG(format[ARR_2("Failed to get replay ID: %1", _insertResult select 1)], _functionLogName);
};

GVAR(missionId) = _insertResult select 1;

["replaySetup"] call CBA_fnc_localEvent;

//ERROR_SYSTEM_CHAT("R3 is recording this mission");
DBUG(format[ARR_2("Replay db entry setup %1", GVAR(missionId))], _functionLogName);
