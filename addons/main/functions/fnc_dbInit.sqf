/*
 * Author: Titan
 * Establishes connection to the database
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(dbInit);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbInit";

private _version = GVAR(extensionName) callExtension "version";

if (_version == "") exitWith {

    ERROR_WITH_TITLE("AAR Init Error", "The AAR tool (R3) failed to start, the extension failed to load or is missing");
    DBUG("Failed to init", _functionLogName);
};

private _connect = call compile (GVAR(extensionName) callExtension "connect");

if !(_connect select 1) exitWith {

    ERROR_WITH_TITLE("AAR Connect Error", "The AAR tool (R3) failed to connect to your database, this mission will not be captured");
    DBUG("Failed to connect to db", _functionLogName);
};

["dbSetup"] call CBA_fnc_localEvent;
