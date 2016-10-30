package newCore.events;

import openfl.events.Event;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class RenderEvent extends Event
{
	public static inline var RENDER:String = "render";
	public static inline var CHANGE:String = "change";
	public static inline var CLEAR:String = "clear";

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) 
	{
		super(type, bubbles, cancelable);	
	}
	
	override public function clone():Event 
	{
		//return super.clone();
		return new RenderEvent(type, bubbles, cancelable);
	}
	
}
/* How To Use:
 * 
 * dispatchEvent(new TemplateEvent(TemplateEvent.EVENTTYPE, event));
 * addEventListener(ChangeWinEvent.CHANGE_WINDOW, handleChangeWindows);
*/