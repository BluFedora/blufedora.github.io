package libBlu.debug ;

import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Debug extends TextField
{
  public var times:Array<Float> = [];
  private var memPeak:Float = 0;

  public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000, inSelectable:Bool = false) 
  {
    super();
    
    defaultTextFormat = new TextFormat("_sans", 12, inCol);
    //addEventListener(Event.ENTER_FRAME, onEnter);
    backgroundColor = 0xE6FFF2;
    selectable = inSelectable;
    alpha = .6;
    background = true;
    text = "FPS: ";
    width = 160;
    height = 80;
    x = inX;
    y = inY;
  }
  
  public function onEnter():Void
  {  
    var now = Timer.stamp();
    times.push(now);
    
    while (times[0] < now - 1)
      times.shift();
      
    var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
    if (mem > memPeak) memPeak = mem;
    
    if (visible)
    {
      #if TKE
        text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB" + "\nToolkit Version <1.8.1>" + "\nMade By: Shareef Raheem";
      #else
        text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB" + "\nEngine Version <0.0.1>" + "\nMade By: Shareef Raheem";
      #end
    }
  }
  
}