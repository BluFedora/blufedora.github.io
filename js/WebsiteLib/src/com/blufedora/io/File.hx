/******************************************************************************/
/*!
 * @file   File.hx
 * @author Shareef Abdoul-Raheem (http://blufedora.github.io/)
 * @brief
 *   Main entry point to the my website's interativity.
 *
 * @version 0.0.1
 * @date    2020-12-25
 *
 * @copyright Copyright (c) 2019-2020
 */
/******************************************************************************/
package com.blufedora.io;

import js.html.XMLHttpRequest;

/**
 * File utilities to make it so I write less boilerplate.
 * @author Shareef Abdoul-Raheem
 */
class File 
{
  public static inline function loadJson(path:String, callback:String->Void)
	{
		var xobj = new XMLHttpRequest();
		
		xobj.overrideMimeType("application/json");
		xobj.open("GET", path, true);
		
		xobj.onreadystatechange = function () 
		{
			if (xobj.readyState == XMLHttpRequest.DONE && xobj.status == 200) 
			{
				callback(xobj.responseText);
			}
		};
		
		xobj.send(null);  
	}
}