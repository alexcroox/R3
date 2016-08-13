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
private _functionLogName = "AAR > trackVehicles";

params [
    ["_trackVehicleType", "ground"]
];

// We have a string length limit with our database extension so we need to break up
// large amounts of units into multiple calls
private _unitCount = 0;
private _movementData = "";

// Loop through all vehicles on the map
{
    // Is there anyone inside the vehicle? We don't want to track empty vehicles
    if (count crew _x > 0) then {

        [_x] call FUNC(addVehicleEventHandlers);

        // Are we asking for ground vehicles and does this vehicle drive?
        if ( _trackVehicleType == "ground" && !(_x isKindOf "Car" || _x isKindOf "Tank" || _x isKindOf "Boat_F") ) exitWith {};

        // Are we tracking air vehicles and does this vehicle fly?
        if ( _trackVehicleType == "air" && !(_x isKindOf "Helicopter" || _x isKindOf "Plane") ) exitWith {};

        private _vehicleUid = getPlayerUID _x;
        private _vehiclePos = getPos _x;
        private _vehicleDirection = round getDir _x;
        private _vehicleClass = typeOf _x;

        private _vehicleIconPathRaw = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "icon");
        private _splitIconPath = _vehicleIconPathRaw splitString "\.";

        private _vehicleIconName = _vehicleIconPathRaw;

        if (count _splitIconPath > 2) then {
            _vehicleIconName = _splitIconPath select (count _splitIconPath - 2);
        };

        private _vehicleIcon = (
            _x call {

                if (_this isKindOf "Heli_Attack_01_base_F" || _this isKindOf "Heli_Attack_02_base_F" || _this isKindOf "Heli_Attack_03_base_F") exitWith { "iconHelicopterAttack" };
                if (_this isKindOf "Heli_Transport_01_base_F" || _this isKindOf "Heli_Transport_02_base_F" || _this isKindOf "Heli_Transport_03_base_F") exitWith { "iconHelicopterTransport" };
                if (_this isKindOf "Plane_CAS_01_base_F") exitWith { "iconPlaneAttack" };
                if (_this isKindOf "Plane_CAS_02_base_F") exitWith { "iconPlaneAttack" };
                if (_this isKindOf "Plane_CAS_03_base_F") exitWith { "iconPlaneAttack" };
                if (_this isKindOf "APC_Tracked_03_base_F") exitWith { "iconAPC" };
                if (_this isKindOf "APC_Tracked_02_base_F") exitWith { "iconAPC" };
                if (_this isKindOf "APC_Tracked_01_base_F") exitWith { "iconAPC" };
                if (_this isKindOf "Truck_01_base_F") exitWith { "iconTruck" };
                if (_this isKindOf "Truck_02_base_F") exitWith { "iconTruck" };
                if (_this isKindOf "Truck_03_base_F") exitWith { "iconTruck" };
                if (_this isKindOf "MRAP_01_base_F") exitWith { "iconMRAP" };
                if (_this isKindOf "MRAP_02_base_F") exitWith { "iconMRAP" };
                if (_this isKindOf "MRAP_03_base_F") exitWith { "iconMRAP" };
                if (_this isKindOf "MBT_01_arty_base_F") exitWith { "iconTankArtillery" };
                if (_this isKindOf "MBT_02_arty_base_F") exitWith { "iconTankArtillery" };
                if (_this isKindOf "MBT_03_arty_base_F") exitWith { "iconTankArtillery" };
                if (_this isKindOf "MBT_01_base_F") exitWith { "iconTank" };
                if (_this isKindOf "MBT_02_base_F") exitWith { "iconTank" };
                if (_this isKindOf "MBT_03_base_F") exitWith { "iconTank" };
                if (_this isKindOf "StaticCannon") exitWith { "iconStaticCannon" };
                if (_this isKindOf "StaticAAWeapon") exitWith { "iconStaticAA" };
                if (_this isKindOf "StaticATWeapon") exitWith { "iconStaticAT" };
                if (_this isKindOf "StaticMGWeapon") exitWith { "iconStaticMG" };
                if (_this isKindOf "StaticWeapon") exitWith { "iconStaticWeapon" };
                if (_this isKindOf "StaticGrenadeLauncher") exitWith { "iconStaticGL" };

                if (_this isKindOf "Boat_F") exitWith { "iconBoat" };
                if (_this isKindOf "Truck_F") exitWith { "iconTruck" };
                if (_this isKindOf "Tank" || _this isKindOf "Tank_F") exitWith { "iconTank" };
                if (_this isKindOf "Car" || _this isKindOf "Car_F") exitWith { "iconCar" };
                if (_this isKindOf "Helicopter_Base_F") exitWith { "iconHelicopter" };
                if (_this isKindOf "Plane_Base_F" || _this isKindOf "Plane") exitWith { "iconPlane" };

                //diag_log format["unknown vehicle type: %1", typeOf _this];
                "iconUnknown";
            }
        );

        private _vehicleFaction = _x call FUNC(calcSideInt);
        private _vehicleGroupId = groupID group _x;
        private _vehicleCrew = (
            _x call {
                private _crew = [];
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
        private _vehicleCargo = (
            _x call {
                private _cargo = [];
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
        private _singleVehicleMovementData = format['
            {
                "unit": "%1",
                "id": "%2",
                "pos": %3,
                "dir": %4,
                "cls": "%5",
                "ico": "%6",
                "icp": "%11",
                "fac": "%7",
                "grp": "%8",
                "crw": %9,
                "cgo": %10
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
            _vehicleCargo,
            _vehicleIconName
        ];

        // We don't want leading commas in our JSON
        private _seperator = if (_movementData == "") then { "" } else { "," };

        // Combine this unit's data with our current running movements data
        _movementData = [[_movementData, _singleVehicleMovementData], _seperator] call CBA_fnc_join;

        _unitCount = _unitCount + 1;

        // If we've reached our limit for the number of units in a single db entry lets flush and continue
        if (_unitCount == GVAR(maxUnitCountPerEvent)) then {

            // Save details to db
            private _movementDataJsonArray = format["[%1]", _movementData];
            GVAR(eventSavingQueue) pushBack [0, "positions_vehicles", _movementDataJsonArray, time];

            _unitCount = 0;
            _movementData = "";
        };
    };
} forEach vehicles;

if (_movementData != "") then {
    private _movementDataJsonArray = format["[%1]", _movementData];
    GVAR(eventSavingQueue) pushBack [0, "positions_vehicles", _movementDataJsonArray, time];
};
