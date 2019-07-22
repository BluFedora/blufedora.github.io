package com.blufedora;

import js.html.XMLHttpRequest;

/**
 * ...
 * @author ...
 */
class Utils 
{
	public static inline function loadJson(path:String, callback:String->Void, async:Bool = true)
	{
		var xobj = new XMLHttpRequest();
		
		xobj.overrideMimeType("application/json");
		xobj.open("GET", path, async);
		
		xobj.onreadystatechange = function () 
		{
			if (xobj.readyState == XMLHttpRequest.DONE && xobj.status == 200) 
			{
				callback(xobj.responseType);
			}
		};
		
		xobj.send(null);  
	}
}