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
_functionLogName = "AAR > dbInit";

// Reset and complete any outstanding actions (if mission restarted)
"extDB3" callExtension format["9:UNLOCK:%1", GVAR(databaseRandomLockKey)];
"extDB3" callExtension "9:RESET";

// Check our extDB3 version, if it fails its not loaded and we should halt here
_version = "extDB3" callExtension "9:VERSION";

if(_version == "") exitWith { DBUG("Failed to load, no connection to extDB3", _functionLogName); };

DBUG(format[ARR_2("Connecting to db using config profile: %1", GVAR(databaseSettingName))], _functionLogName);

// Connect to Database
_addDatabase = call compile ("extDB3" callExtension format["9:ADD_DATABASE:%1", GVAR(databaseSettingName)]);

// Extension will return [0] if connection failed
if ((_addDatabase select 0) isEqualTo 0) exitWith { DBUG("Failed to connect to database, check your config", _functionLogName); };

DBUG("Connected to database successfully", _functionLogName);

_addDbProtocol = call compile ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:%1:SQL_CUSTOM:SQL:aar.ini", GVAR(databaseSettingName)]);

if ((_addDbProtocol select 0) isEqualTo 0) exitWith { DBUG("Failed to set database protocol", _functionLogName); };

_addDbProtocol = call compile ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:%1:SQL:SQLRAW", GVAR(databaseSettingName)]);

// Lock the extension so no further SYSTEM commands can be issued
"extDB3" callExtension format["9:LOCK:%1", GVAR(databaseRandomLockKey)];
