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

private _connect = call compile ("R3DBConnector" callExtension format["%1", "connect"]);

if ((_connect select 0) isEqualTo 0) exitWith {

    ERROR_WITH_TITLE("AAR Init Error", "The AAR tool (R3) failed to connect to your database, this mission will not be captured");
    DBUG("Failed to connect to db", _functionLogName);
};

GVAR(replayId) = _connect select 2;

["dbSetup"] call CBA_fnc_localEvent;
