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

if (GVAR(noPlayers) || !GVAR(logEvents)) exitWith {};

if (_ammo isEqualTo "GrenadeHand" || _ammo find "Smoke" > -1 || _ammo find "HE" > -1) then {

    _findFinalPosition = [_projectile, _ammo, _unit] spawn {

        params ["_projectile", "_ammo", "_unit"];
        private ["_grenadePos"];

        // Track the protectile and wait until it's stopped moving
        waitUntil { (getPos _projectile select 2) < 0.1 };
        private _grenadePos = getPos _projectile;
        
        // Is the position invalid?
        if ((_grenadePos select 0) == 0) exitWith {};

        private _uid = getPlayerUID _unit;

        private _type = "smoke";

        if (_ammo find "HE" > -1) then {
            _type = "grenade";
        };

        diag_log _grenadePos;
        private _json = format['
            {
                "unit": "%1",
                "id": "%2",
                "type": "%3",
                "ammo": "%4",
                "position": %5
            }',
            _unit,
            _uid,
            _type,
            _ammo,
            _grenadePos
        ];

        // Send the json to our extension for saving to the db
        ["projectile", _json, _uid] call FUNC(dbInsertEvent);
    };
};
