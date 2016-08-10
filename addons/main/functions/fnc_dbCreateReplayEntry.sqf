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

private _query = format["2:SQL:replayInsert:%1:%2:%3", missionName, worldName, daytime];
private _setupReplay = call compile ("extDB3" callExtension _query);

uisleep (random .03);

private _key = _setupReplay select 1;
private _queryResult = "";
private _dbWaitLoop = true;

// We need to wait for the query to return, if it hasn't returned yet we will receive [3] (wait)
while {_dbWaitLoop} do {

    _queryResult = "extDB3" callExtension format["4:%1", _key];

    if (_queryResult isEqualTo "[5]") then {

        // extDB3 returned that result is Multi-Part Message
        _queryResult = "";
        while {true} do {
            _pipe = "extDB3" callExtension format["5:%1", _key];
            if (_pipe isEqualTo "") exitWith { _dbWaitLoop = false };
            _queryResult = _queryResult + _pipe;
        };
    } else {

        if (_queryResult isEqualTo "[3]") then {
            uisleep 0.1;
        } else {
            _dbWaitLoop = false;
        };
    };
};

_queryResult = call compile _queryResult;

if ((_queryResult select 0) isEqualTo 0) exitWith { DBUG(format[ARR_2("Failed to get replay insert Id %1", _queryResult)], _functionLogName); };

GVAR(replayId) = (_queryResult select 1) select 0;

["replaySetup"] call CBA_fnc_localEvent;

DBUG(format[ARR_2("Replay db entry setup %1", GVAR(replayId))], _functionLogName);
