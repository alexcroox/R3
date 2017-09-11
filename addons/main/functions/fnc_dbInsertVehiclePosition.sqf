/*
 * Author: Titan
 * Save vehicle position
 *
 * Arguments:
 * [0] _entityId <INTEGER>
 * [1] _vehicle <OBJECT>
 * [2] _isKeyFrame <INTEGER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["_entityId", "_vehicle"] call FUNC(dbInsertVehiclePosition);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbInsertVehiclePosition";

params [
    ["_entityId", 0],
    ["_vehicle", ""],
    ["_isKeyFrame", 0]
];

private _vehiclePos = getPosWorld _vehicle;
private _vehiclePosX = _vehiclePos select 0;
private _vehiclePosY = _vehiclePos select 1;
private _vehiclePosZ = _vehiclePos select 2;
private _vehicleHeading = round getDir _vehicle;

private _getVehicleDriver = driver _vehicle;
private _vehicleDriver = _getVehicleDriver getVariable ["r3_entity_id", 0];

// We only care about logging human crew and cargo
private _vehicleCrew = (
    _x call {
        private _crew = [];
        {
            if(isPlayer _x) then {
                if(_this getCargoIndex _x == -1) then {
                    _crew pushBack (_x getVariable ["r3_entity_id", 0]);
                };
            };
        } forEach crew _this;
        _crew
    }
);

private _vehicleCrewString = "";

if (count _vehicleCrew > 0) then {

    _vehicleCrewString = format["%1", _vehicleCrew];
};

private _vehicleCargo = (
    _x call {
        private _cargo = [];
        {
            if(isPlayer _x) then {
                if(_this getCargoIndex _x >= 0) then {
                    _cargo pushBack (_x getVariable ["r3_entity_id", 0]);
                };
            };
        } forEach crew _this;
        _cargo
    }
);

private _vehicleCargoString = "";

if (count _vehicleCargo > 0) then {

    _vehicleCargoString = format["%1", _vehicleCargo];
};

private _previousVehiclePosX = _vehicle getVariable ["r3_pos_x", 0];
private _previousVehiclePosY = _vehicle getVariable ["r3_pos_y", 0];
private _previousVehicleHeading = _vehicle getVariable ["r3_heading", 0];
private _previousCrew = _vehicle getVariable ["r3_crew", ""];
private _previousCargo = _vehicle getVariable ["r3_cargo", ""];

// If the vehicle's position has changed lets log it
if (
    _isKeyFrame isEqualTo 1 ||
    _previousVehiclePosX != _vehiclePosX ||
    _previousVehiclePosY != _vehiclePosY ||
    _previousVehicleHeading != _vehicleHeading ||
    _previousCrew != _vehicleCrewString ||
    _previousCargo != _vehicleCargoString) then {

    _vehicle setVariable ["r3_pos_x", _vehiclePosX];
    _vehicle setVariable ["r3_pos_y", _vehiclePosY];
    _vehicle setVariable ["r3_heading", _vehicleHeading];

    _vehicle setVariable ["r3_crew", _vehicleCrewString];
    _vehicle setVariable ["r3_cargo", _vehicleCargoString];

    // Send infantry position to the extension
    private _query = [["vehicle_positions", GVAR(missionId), _entityId, _vehiclePosX, _vehiclePosY, _vehiclePosZ, _vehicleHeading, _isKeyFrame, _vehicleDriver, _vehicleCrewString, _vehicleCargoString, time], GVAR(extensionSeparator)] call CBA_fnc_join;
    call compile (GVAR(extensionName) callExtension _query);
};
