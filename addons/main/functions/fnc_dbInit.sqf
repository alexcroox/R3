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

    ERROR_SYSTEM_CHAT("The AAR tool (R3) failed to start, the extension failed to load or is missing");
    DBUG(format[ARR_2("Failed to init: %1", _seperator select 1)], _functionLogName);
};

GVAR(extensionSeparator) = _seperator select 1;

DBUG(format[ARR_2("Seperator %1", GVAR(extensionSeparator))], _functionLogName);

private _connect = call compile (GVAR(extensionName) callExtension "connect");

if ((_connect select 0) isEqualTo "error") exitWith {

    ERROR_SYSTEM_CHAT("The AAR tool (R3) failed to connect to your database, this mission will not be captured");
    DBUG(format[ARR_2("Failed to connect to db: %1", _connect select 1)], _functionLogName);
};

["dbSetup"] call CBA_fnc_localEvent;