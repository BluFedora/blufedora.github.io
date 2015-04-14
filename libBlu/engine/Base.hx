package libBlu.engine;

import libBlu.debug.Console;
import libBlu.managers.KeyManager;
import libBlu.scripting.HxsEngine;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Lib;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */ 
class Base extends Sprite
{	
	public static var AppWidth(get, never):Int;
	public static var AppHeight(get, null):Int;
	public static var scriptEngine:HxsEngine;
	public static var MAIN:Base;
	
	private var keysManager:KeyManager;

	public function new() 
	{
		super();
		stage.addEventListener(Event.RESIZE, onResize);
		keysManager = new KeyManager();
		scriptEngine = new HxsEngine();
		initScript();
		MAIN = this;
	}
	
	public function initScript():Void
	{
		scriptEngine.exposeMethod(
			["Main", "appWidth", "appHeight"], 
			[this,    AppWidth,   AppHeight ]
		);
		
		Console.init(this, 33);
	}
	
	private function keyDown(keyCode:Int):Bool
	{	
		return keysManager.key[keyCode];
	}
	
	private function onResize(e:Event):Void 
	{
		Console.instance.resize();
	}
	
	//* Getters and Setters *//
	
	private static inline function get_AppWidth():Int 
	{
		return Lib.current.stage.stageWidth;
	}
	
	private static inline function get_AppHeight():Int 
	{
		return Lib.current.stage.stageHeight;
	}
	
}