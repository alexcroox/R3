/*
 * Author: Titan
 * Prep event data for sending to db extension
 *
 * Arguments:
 * 0: type <STRING>
 * 1: entityA <INT>
 * 2: entityB <INT>
 * 3: keyData <STRING>
 * 4: extraData <STRING>
 *
 * Return Value:
 * none
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbInsertEvent";

params [
    ["_type", ""],
    ["_entityA", 0],
    ["_entityB", 0],
    ["_keyData", ""],
    ["_extraData", ""]
];

if(_type == "") exitWith {};

// Send the query to the extension
private _query = [["event", GVAR(missionId), _type, _entityA, _entityB, _keyData, _extraData, time], GVAR(extensionSeparator)] call CBA_fnc_join;
call compile (GVAR(extensionName) callExtension _query);
