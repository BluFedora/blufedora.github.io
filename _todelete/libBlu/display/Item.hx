package libBlu.display;

import libBlu._assetIO.Asset;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Item extends GameObject
{
	public var script(get, set):String;
	public var type:Int;
	
	private var _scriptPath:String;

	public function new(x:Float, y:Float, width:Float, height:Float, ?type:Int = 0) 
	{
		super(x, y, width, height);
		this.type = type;
	}
	
	public function onPickup():String
	{
		return script;
	}
	
	//* Getters and Setters *//
	
	private function get_script():String 
	{
		return Asset.getText(_scriptPath);
	}
	
	private function set_script(path:String):String 
	{
		_scriptPath = path;
		return Asset.getText(path);
	}
	
}