/*
 * Author: Titan
 * Setup ACE event handlers
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit] call FUNC(addInfantryACEEventHandlers);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > addInfantryACEEventHandlers";

params [
    ["_unit", objNull]
];

// Only add ACE3 event handlers if ACE is loaded server side
if (!isNull (configFile >> "CfgPatches" >> "ace_main")) then {
    ["ace_unconscious", FUNC(eventUnconscious)] call CBA_fnc_addEventHandler;

    diag_log format["Added ACE EH to %1", _unit];
};
