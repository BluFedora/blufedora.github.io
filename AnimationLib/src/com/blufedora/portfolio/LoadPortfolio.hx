package com.blufedora.portfolio;

import haxe.Json;
import js.html.XMLHttpRequest;

/**
 * ...
 * @author BluFedora (Shareef Raheem)
 */
class LoadPortfolio 
{
	public static inline function load(path, element, creatFunc):Void
	{
		var xobj = new XMLHttpRequest();
		xobj.overrideMimeType("application/json");
		xobj.open("GET", path, true);
		xobj.onreadystatechange = function()
		{
			if (xobj.readyState == 4 && xobj.status == 200) 
			{
				var data:Array<Dynamic> = Json.parse(xobj.responseText);
				
				for (i in 0...data.length)
				{
					creatFunc(element, data[i]);
				}
			}
		};
		xobj.send(null);
	}
}