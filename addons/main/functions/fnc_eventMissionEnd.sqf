/*
 * Author: Titan
 * Event fired when mission ends
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(eventMissionEnd);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventMissionEnd";

GVAR(logEvents) = false;

DBUG("Mission ended", _functionLogName);
