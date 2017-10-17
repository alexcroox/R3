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

private _init = GVAR(extensionName) callExtension ["init", []];

if ((_init select 0) isEqualTo -1) then {

    private _initErrorArray = _init select 1;
    private _initErrorMessage = _initErrorArray select 1;

    ERROR_SYSTEM_CHAT(format["The AAR tool (R3) failed to initialise, %1", _initErrorMessage]);
    DBUG(format[ARR_2("Failed to initialise: %1", _initErrorMessage)], _functionLogName);
};

private _connect = GVAR(extensionName) callExtension ["connect", []];

if ((_connect select 0) isEqualTo -1) exitWith {

    ERROR_SYSTEM_CHAT("The AAR tool (R3) failed to connect to your database, this mission will not be captured");
    DBUG(format[ARR_2("Failed to connect to db: %1", _connect select 2)], _functionLogName);
};

["dbSetup"] call CBA_fnc_localEvent;