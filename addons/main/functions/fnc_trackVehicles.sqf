/*
 * Author: Titan
 * Loops through all vehicles on the map and saves to db event buffer
 *
 * Arguments:
 * 0: vehicleType <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["air"] call FUNC(trackVehicles);
 *
 * Public: No
 */

#include "script_component.hpp"
_functionLogName = "AAR > trackVehicles";

private ["_trackVehicleType"];
_trackVehicleType = param [0, "ground"];

diag_log format["tracking %1", _trackVehicleType];

_movementData = "";

// Loop through all vehicles on the map
{
    // Is there anyone inside the vehicle? We don't want to track empty vehicles
    if (count crew _x < 1) exitWith { diag_log format["empty vehicle %1", _x]; };

    // Are we asking for ground vehicles and does this vehicle drive?
    if ( _trackVehicleType == "ground" && !(_x isKindOf "Car" || _x isKindOf "Tank" || _x isKindOf "Boat_F") ) exitWith {};

    // Are we tracking air vehicles and does this vehicle fly?
    if ( _trackVehicleType == "air" && !(_x isKindOf "Helicopter" || _x isKindOf "Plane") ) exitWith {};

    _vehicleUid = getPlayerUID _x;
    _vehiclePos = getPos _x;
    _vehicleDirection = round getDir _x;
    _vehicleClass = typeOf _x;

    _vehicleIcon = (
        _x call {

            if (_trackVehicleType == "ground") then {
                if(_this isKindOf "Car_F") exitWith { "iconCar" };
                if(_this isKindOf "Tank_F") exitWith { "iconArmour" };
                if(_this isKindOf "Boat_F") exitWith { "iconBoat" };
            };

            if (_trackVehicleType == "air") then {
                if(_this isKindOf "Helicopter_Base_F") exitWith {"iconHelicopter"};
                if(_this isKindOf "Plane_Base_F") exitWith {"iconPlane"}
            };

            "iconUnknown";
        }
    );

    _vehicleFaction = _x call FUNC(calcSideInt);
    _vehicleGroupId = groupID group _x;
    _vehicleCrew = (
        _x call {
            _crew = [];
            {
                if(isPlayer _x) then {
                    if(_this getCargoIndex _x == -1) then {
                        _crew pushBack getPlayerUID _x;
                    };
                };
            } forEach crew _this;
            _crew
        }
    );
    _vehicleCargo = (
        _x call {
            _cargo = [];
            {
                if(isPlayer _x) then {
                    if(_this getCargoIndex _x >= 0) then {
                        _cargo pushBack getPlayerUID _x;
                    };
                };
            } forEach crew _this;
            _cargo
        }
    );

    // Form JSON for saving
    // It sucks we have to use such abbreviated keys but we need to save as much space as pos!
    _singleVehicleMovementData = format['
        {
            "%1": {
                "id": "%2",
                "pos": "%3",
                "dir": %4,
                "cls": "%5"
                "ico": "%6",
                "fac": "%7",
                "grp": "%8",
                "crw": "%9",
                "cgo": "%10"
            }
        }',
        _x,
        _vehicleUid,
        _vehiclePos,
        _vehicleDirection,
        _vehicleClass,
        _vehicleIcon,
        _vehicleFaction,
        _vehicleGroupId,
        _vehicleCrew,
        _vehicleCargo
    ];

    // We don't want leading commas in our JSON
    _seperator = if (_movementData == "") then { "" } else { "," };

    // Combine this unit's data with our current running movements data
    _movementData = [[_movementData, _singleVehicleMovementData], _seperator] call CBA_fnc_join;
} forEach vehicles;

if (_movementData != "") then {
    GVAR(messageQueue) pushBack [0, "positions_vehicles", _movementData, time];
};
