/*
 * Author: Titan
 * Return side integer for unit. Used to keep db and data sizes 
 * down to a minimum 
 *
 * Arguments:
 * 0: _unit <OBJECT>
 *
 * Return Value:
 * _sideInt <INTEGER>
 *
 * Example:
 * _unit call FUNC(calcSideInt);
 *
 * Public: No
 */

if(side group _this == EAST) exitWith {0};
if(side group _this == WEST) exitWith {1};
if(side group _this == INDEPENDENT) exitWith {2};
if(side group _this == CIVILIAN) exitWith {3};