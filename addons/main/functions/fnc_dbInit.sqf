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

// Get our custom seperator from the extension
private _seperator = call compile (GVAR(extensionName) callExtension "separator");

if ((_seperator select 0) isEqualTo "error") exitWith {

    ERROR_WITH_TITLE("AAR Init Error", "The AAR tool (R3) failed to start, the extension failed to load or is missing");
    DBUG("Failed to init", _functionLogName);
};

GVAR(extensionSeparator) = _seperator select 1;

DBUG(format[ARR_2("Seperator %1", GVAR(extensionSeparator))], _functionLogName);

private _connect = call compile (GVAR(extensionName) callExtension "connect");

if ((_connect select 0) isEqualTo "error") exitWith {

    ERROR_WITH_TITLE("AAR Connect Error", "The AAR tool (R3) failed to connect to your database, this mission will not be captured");
    DBUG("Failed to connect to db", _functionLogName);
};

["dbSetup"] call CBA_fnc_localEvent;