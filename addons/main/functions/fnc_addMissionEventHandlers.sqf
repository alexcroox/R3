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
private _functionLogName = "AAR > addMissionEventHandlers";

DBUG("Setting up mission event handlers", _functionLogName);

addMissionEventHandler ["PlayerConnected", FUNC(eventPlayerConnect)];
addMissionEventHandler ["HandleDisconnect", FUNC(eventPlayerDisconnect)];
addMissionEventHandler ["EntityKilled", FUNC(eventKilled)];
addMissionEventHandler ["EntityRespawned", FUNC(eventRespawned)];
addMissionEventHandler ["Ended", FUNC(eventMissionEnd)];
