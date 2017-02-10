/*
 * Author: Titan
 * Save vehicle to vehicles table
 *
 * Arguments:
 * [0] _entityId <INTEGER>
 * [1] _vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["_entityId", "_vehicle"] call FUNC(dbInsertVehicle);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > dbInsertVehicle";

params [
    ["_entityId", 0],
    ["_vehicle", ""]
];

private _vehicleClass = typeOf _x;

// We want the iconpathname (without the .paa and without the full path) just the name of the icon
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
        if (_this isKindOf "Plane_CAS_01_base_F" || _this isKindOf "Plane_CAS_02_base_F" || _this isKindOf "Plane_CAS_03_base_F") exitWith { "iconPlaneAttack" };
        if (_this isKindOf "APC_Tracked_01_base_F" || _this isKindOf "APC_Tracked_02_base_F" || _this isKindOf "APC_Tracked_03_base_F") exitWith { "iconAPC" };
        if (_this isKindOf "Truck_01_base_F" || _this isKindOf "Truck_02_base_F"  || _this isKindOf "Truck_03_base_F") exitWith { "iconTruck" };
        if (_this isKindOf "MRAP_01_base_F" || _this isKindOf "MRAP_02_base_F" || _this isKindOf "MRAP_03_base_F") exitWith { "iconMRAP" };
        if (_this isKindOf "MBT_01_arty_base_F" || _this isKindOf "MBT_02_arty_base_F" || _this isKindOf "MBT_03_arty_base_F") exitWith { "iconTankArtillery" };
        if (_this isKindOf "MBT_01_base_F" || _this isKindOf "MBT_02_base_F" || _this isKindOf "MBT_03_base_F") exitWith { "iconTank" };
        if (_this isKindOf "StaticCannon") exitWith { "iconStaticCannon" };
        if (_this isKindOf "StaticAAWeapon") exitWith { "iconStaticAA" };
        if (_this isKindOf "StaticATWeapon") exitWith { "iconStaticAT" };
        if (_this isKindOf "StaticMGWeapon") exitWith { "iconStaticMG" };
        if (_this isKindOf "StaticWeapon") exitWith { "iconStaticWeapon" };
        if (_this isKindOf "StaticGrenadeLauncher") exitWith { "iconStaticGL" };
        if (_this isKindOf "Steerable_Parachute_F" || _this isKindOf "NonSteerable_Parachute_F") exitWith { "iconParachute" };

        // Fallbacks
        if (_this isKindOf "Boat_F" || _this isKindOf "Ship_F") exitWith { "iconBoat" };
        if (_this isKindOf "Truck_F") exitWith { "iconTruck" };
        if (_this isKindOf "Tank" || _this isKindOf "Tank_F") exitWith { "iconTank" };
        if (_this isKindOf "Car" || _this isKindOf "Car_F") exitWith { "iconCar" };
        if (_this isKindOf "Helicopter_Base_F") exitWith { "iconHelicopter" };
        if (_this isKindOf "Plane_Base_F" || _this isKindOf "Plane") exitWith { "iconPlane" };

        //diag_log format["unknown vehicle type: %1", typeOf _this];
        "iconUnknown";
    }
);

// Send the query to the extension
private _query = [["vehicles", GVAR(missionId), _entityId, _vehicleClass, _vehicleIcon, _vehicleIconName, time], GVAR(extensionSeparator)] call CBA_fnc_join;
call compile (GVAR(extensionName) callExtension _query);
