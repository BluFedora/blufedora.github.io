package com.blufedora;

import js.Browser;

/**
 * ...
 * @author BluFedora (Shareef Raheem)
 */
class TweenUtils 
{
	public static function parse(target:Dynamic, prop:String):Int
	{
		var val:Int = untyped parseInt(Browser.window.getComputedStyle(target).getPropertyValue(prop), 10);
		return (val == Math.NaN) ? 0 : val;
	}

	public static function parseFloat(target:Dynamic, prop:String):Float
	{
		var val = Std.parseFloat(Browser.window.getComputedStyle(target).getPropertyValue(prop));
		return (val == Math.NaN) ? 0.0 : val;
	}
}