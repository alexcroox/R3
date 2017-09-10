/*
 * Author: Titan
 * Event fired when a unit on foot fires their weapon
 *
 * Arguments:
 * 0: unit <OBJECT>
 * 1: weapon <STRING>
 * 2: muzzle <STRING>
 * 3: mode <STRING>
 * 4: ammo <STRING>
 * 5: magazine <STRING>
 * 6: projectile <OBJECT>
 *
 * Return Value:
 * None
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > eventFired";

params [
    ["_unit", objNull],
    ["_weapon", ""],
    ["_muzzle", ""],
    ["_mode", ""],
    ["_ammo", ""],
    ["_magazine", ""],
    ["_projectile", objNull]
];

if ( (GVAR(noPlayers) || !GVAR(logEvents)) && !(GVAR(forceLogEvents)) ) exitWith {};

//private _isNade = (_weapon == "Throw" || _ammo isKindOf "GrenadeCore");
//diag_log format["is nade? %1", _isNade];

if (_ammo find "Grenade" > -1 || _ammo find "Smoke" > -1 || _ammo find "HE" > -1) then {

    _findFinalPosition = [_projectile, _ammo, _unit] spawn {

        params ["_projectile", "_ammo", "_unit"];
        private _grenadePos = [];

        private _grenadeType = "grenade";

        if (_ammo find "Smoke" > -1) then {
            _grenadeType = "smoke";
        };

        if (_grenadeType == "grenade") then {

            // Track the protectile and wait until it explodes (grenade)
            waitUntil {

                if (!isNull (_projectile)) then {
                    _grenadePos = getPos _projectile;
                };

                isNull _projectile;
            };

        } else {

            // Track the protectile and wait until it's stopped moving (smoke)
            waitUntil {

                if (!isNull (_projectile)) then {
                    _grenadePos = getPos _projectile;
                };

                ((getPos _projectile select 2) < 0.1 || !alive _projectile)
            };
        };

        // Is the position invalid?
        if ((_grenadePos select 0) == 0 || count _grenadePos < 2) exitWith {};

        private _posX = _grenadePos select 0;
        private _posY = _grenadePos select 1;

        private _entityId = _unit getVariable ["r3_entity_id", 0];

        // Send the query to the extension
        private _query = [["events_projectile", GVAR(missionId), time, _grenadeType, _entityId, _posX, _posY, _ammo], GVAR(extensionSeparator)] call CBA_fnc_join;
        call compile (GVAR(extensionName) callExtension _query);
    };
};
