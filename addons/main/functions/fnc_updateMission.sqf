/*
 * Author: Titan
 * Updates mission table with current timestamp and latest mission time
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(updateMission);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > updateMission";

diag_log format["mission update %1 %2", GVAR(missionId), round time];

// Send the query to the extension
private _query = [["update_replay", GVAR(missionId), round time], GVAR(extensionSeparator)] call CBA_fnc_join;
call compile (GVAR(extensionName) callExtension _query);
