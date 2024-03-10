package blufedora.animation;

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
	}
	
	private function get_x():Float 
	{
		return TweenUtils.parseFloat(this._object, "marginLeft");
	}
	
	private function set_x(value:Float):Float 
	{
		this._object.style.marginLeft = value + "px";
		return value;
	}
	
	private function get_y():Float 
	{
		return TweenUtils.parseFloat(this._object, "margin-top");
	}
	
	private function set_y(value:Float):Float 
	{
		this._object.style.marginTop = value + "px";
		return value;
	}
}