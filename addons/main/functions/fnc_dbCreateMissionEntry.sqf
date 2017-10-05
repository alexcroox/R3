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

private _missionName = missionName;
private _displayName = getText (missionConfigFile >> "onLoadName");
private _terrainName = worldName;
private _author = getText (missionConfigFile >> "author");
private _dayTime = daytime;
private _addonVersion = QUOTE(VERSION);
private _fileName = format["%1.%2.pbo", _missionName, _terrainName];

// Send the query to the extension
private _missionInfo = [
    _missionName,
    _displayName,
    _terrainName,
    _author,
    _dayTime,
    _addonVersion,
    _fileName
];

private _createMission = GVAR(extensionName) callExtension ["create_mission", _missionInfo];

if !((_createMission select 2) isEqualTo 0) exitWith {

    ERROR_SYSTEM_CHAT("The AAR tool (R3) failed to add this mission to your database, this mission will not be captured");
    DBUG(format[ARR_2("Failed to get replay ID: %1", _createMission select 2)], _functionLogName);
};

GVAR(missionId) = _createMission select 0;

["replaySetup"] call CBA_fnc_localEvent;

//ERROR_SYSTEM_CHAT("R3 is recording this mission");
DBUG(format[ARR_2("Mission db entry created: %1", GVAR(missionId))], _functionLogName);
