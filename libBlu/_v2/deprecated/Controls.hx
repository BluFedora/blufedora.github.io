package libBlu._v2.deprecated;

import libBlu.ui.Key;
import openfl.events.KeyboardEvent;
import openfl.Lib;

/**
 * ...
 * @author Blufedora
 */
class Controls
{
	public static inline var SHIFT:Int = 0;
	public static inline var CTRL:Int = 1;
	public static inline var ALT:Int = 2;
	
	public var modifer:Array<Bool> = [];
	public var key:Array<Bool> = [];
	
	private var controlsEnabled:Bool = true;
	public var spaceDown:Bool;
	public var rightDown:Bool;
	public var downDown:Bool;
	public var leftDown:Bool;
	public var upDown:Bool;
	public var eDown:Bool;

	public function new() 
	{
		addListeners();
	}
	
	private function keyDown(e:KeyboardEvent):Void 
	{	
		key[e.keyCode] = true;
		
		if (e.shiftKey)
			modifer[SHIFT] = true;
			
		if (e.ctrlKey)
			modifer[CTRL] = true;
			
		if (e.altKey)
			modifer[ALT] = true;
		
		if (e.keyCode == Key.D || e.keyCode == Key.RIGHT_ARROW)
		{
			rightDown = true;
		}
		
		if (e.keyCode == Key.S || e.keyCode == Key.DOWN_ARROW)
		{
			downDown = true;
		}
		
		if (e.keyCode == Key.A || e.keyCode == Key.LEFT_ARROW)
		{
			leftDown = true;
		}
		
		if (e.keyCode == Key.W || e.keyCode == Key.UP_ARROW)
		{
			upDown = true;
		}
		
		if (e.keyCode == Key.SPACEBAR)
		{
			spaceDown = true;
		}
		
		if (e.keyCode == Key.E)
		{
			eDown = true;
		}
		
		if (e.keyCode == Key.F)
		{
			/*switch(Lib.current.stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				case true: Lib.current.stage.displayState = StageDisplayState.NORMAL; 
				case false: Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN; 
			}*/
		}
	}
	
	private function keyUp(e:KeyboardEvent):Void 
	{
		key[e.keyCode] = false;
		
		if (e.shiftKey)
			modifer[SHIFT] = false;
			
		if (e.ctrlKey)
			modifer[CTRL] = false;
			
		if (e.altKey)
			modifer[ALT] = false;
		
		if (e.keyCode == Key.A || e.keyCode == Key.LEFT_ARROW)
		{
			leftDown = false;
		}
		
		if (e.keyCode == Key.S || e.keyCode == Key.DOWN_ARROW)
		{
			downDown = false;
		}
		
		if (e.keyCode == Key.D || e.keyCode == Key.RIGHT_ARROW)
		{
			rightDown = false;
		}
		
		if (e.keyCode == Key.W || e.keyCode == Key.UP_ARROW)
		{
			upDown = false;
		}
		
		if (e.keyCode == Key.SPACEBAR)
		{
			spaceDown = false;
		}
		
		if (e.keyCode == Key.E)
		{
			eDown = false;
		}
	}
	
	public function removeListeners()
	{
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
	public function addListeners()
	{
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
}