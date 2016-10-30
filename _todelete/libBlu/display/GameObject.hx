package libBlu.display;

import libBlu._interface.IObject;
import libBlu.engine.Base;
import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class GameObject extends Vec implements IObject
{
	private var id:Int = 0;
	
	public var bindedScript:Array<String>;
	public var hasScript:Bool = false;
	
	public var bottom(get, null):Float;
	public var right(get, null):Float;
	public var left(get, null):Float;
	public var top(get, null):Float;
	public var mid(get, null):Vec;
	
	public var height:Float;
	public var width:Float;
	public var name:String;
	
	public var active:Bool;

	public function new(x:Float, y:Float, width:Float, height:Float) 
	{
		this.height = height;
		this.width = width;
		bindedScript = [];
		active = true;
		super(x, y);
	}
	
	public function update():Void { }
	
	public function destroy():Void
	{
		bindedScript = [];
		name = "DELETED";
		active = false;
		height = 0;
		width = 0;
	}
	
	public function bindScript(value:String):Void
	{
		bindedScript.push(value);
		hasScript = true;
	}
	
	/**
	* Getters and Setters 
	*/
	
	private inline function get_mid():Vec 
	{
		return new Vec((this.width / 2) + this.x, (this.height / 2) + this.y);
	}
	
	private inline function get_top():Float 
	{
		return this.y;
	}
	
	private inline function get_bottom():Float 
	{
		return this.y + this.height;
	}
	
	private inline function get_left():Float 
	{
		return this.x;
	}
	
	private inline function get_right():Float 
	{
		return this.x + this.width;
	}
	
}