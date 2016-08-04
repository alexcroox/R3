/*
 * Author: Titan
 * Setup mission event handlers
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(addMissionEventHandlers);
 *
 * Public: No
 */

#include "script_component.hpp"
_functionLogName = "AAR > addMissionEventHandlers";

DBUG("Setting up mission event handlers", _functionLogName);

addMissionEventHandler ["PlayerConnected", FUNC(eventPlayerConnect)];
addMissionEventHandler ["PlayerDisconnected", FUNC(eventPlayerDisconnect)];
addMissionEventHandler ["EntityKilled", FUNC(eventKilled)];
addMissionEventHandler ["Ended", FUNC(eventMissionEnd)];
