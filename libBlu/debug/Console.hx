package libBlu.debug;

import libBlu.ui.ConsoleUI;
import openfl.display.DisplayObjectContainer;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Console
{
	public static var instance:ConsoleUI;
	
	public static function init(parent:DisplayObjectContainer = null, heightPercent:Int = 30):Void
	{
		if (instance == null)
		{
			trace("Debug Console Initialized Press 'Tab'");
			instance = new ConsoleUI(heightPercent);
		}
		
		if (parent != null) parent.addChild(instance);
		instance.hide();
	}
}