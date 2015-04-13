/******************************************************************************/
/*!
 * @file   CSSUnits.hx
 * @author Shareef Abdoul-Raheem (http://blufedora.github.io/)
 * @brief
 *   Enumeration of all the types of css unit types.
 *
 * @version 0.0.1
 * @date    2020-12-25
 *
 * @copyright Copyright (c) 2019-2020
 */
/******************************************************************************/
package blufedora.animation;

/**
 * ...
 * @author Shareef Abdoul-Raheem (BluFedora)
 */
enum abstract CSSUnits(String)
{
	var PERCENT = "%";
	var CM 		  = "cm";
	var EM 		  = "em";
	var REM 	  = "rem";
	var EX 		  = "ex";
	var CH 		  = "ch";
	var INT 	  = "in";
	var MM 		  = "mm";
	var PC 		  = "pc";
	var PT 		  = "pt";
	var PX 		  = "px";
	var VH 		  = "vh";
	var VW 		  = "vw";
	var VMIN 	  = "vmin";
	var VMAX 	  = "vmax";
}