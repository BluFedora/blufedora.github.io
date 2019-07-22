package com.blufedora;

import js.html.Element;

/**
 * ...
 * @author BluFedora (Shareef Raheem)
 */
class JSAnimObject 
{
	public var x(get, set):Float;
	public var y(get, set):Float;

	private var _object:Element;
	
	public function new(object:Element) 
	{
		this._object = object;
		//this._object.style.position = "absolute" or "relative";
	}
	
	private function get_x():Float 
	{
		return TweenUtils.parseFloat(this._object, "left");
	}
	
	private function set_x(value:Float):Float 
	{
		this._object.style.left = value + "px";
		return value;
	}
	
	private function get_y():Float 
	{
		return TweenUtils.parseFloat(this._object, "top");
	}
	
	private function set_y(value:Float):Float 
	{
		this._object.style.top = value + "px";
		return value;
	}
}