package libBlu._v2;

import openfl.events.Event;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class TemplateEvent extends Event
{
  public static inline var EVENTTYPE:String = "temp";
  
  public var _someData:Dynamic;

  public function new(type:String, someData:Dynamic, bubbles:Bool=false, cancelable:Bool=false) 
  {
    super(type, bubbles, cancelable);
    _someData = someData;
  }
  
  override public function clone():Event 
  {
    //return super.clone();
    return new TemplateEvent(type, bubbles, cancelable);
  }
  
}

/* How To Use:
 * 
 * dispatchEvent(new TemplateEvent(TemplateEvent.EVENTTYPE, "DataHere"));
 * addEventListener(ChangeWinEvent.CHANGE_WINDOW, handleChangeWindows);
*/