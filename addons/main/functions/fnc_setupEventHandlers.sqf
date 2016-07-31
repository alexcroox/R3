/*
 * Author: Titan
 * Setup mission and player event handlers
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(setupEventHandlers);
 *
 * Public: No
 */

#include "script_component.hpp"
_functionLogName = "AAR > setupEventHandlers";

DBUG("Setting up event handlers", _functionLogName);

addMissionEventHandler ["PlayerConnected", FUNC(eventPlayerConnect)];
addMissionEventHandler ["PlayerDisconnected", FUNC(eventPlayerDisconnect)];
addMissionEventHandler ["EntityKilled", FUNC(eventKilled)];
addMissionEventHandler ["Ended", FUNC(eventMissionEnd)];