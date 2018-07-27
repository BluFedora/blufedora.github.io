package libBlu.managers;

import libBlu.debug.Console;
import libBlu.engine.Base;
import libBlu.ui.Key;
import openfl.events.KeyboardEvent;
import openfl.Lib;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class KeyManager
{
  public static inline var SHIFT:Int = 0;
  public static inline var CTRL:Int  = 1;
  public static inline var ALT:Int   = 2;

  private var funcs:Array<KeyFunction> = []; 
  public var modifer:Array<Bool>       = [];
  public var key:Array<Bool>           = [];
  
  public function new() { unlockKeyboard(); }
  
  private function keysDown(e:KeyboardEvent):Void 
  {  
    #if mac if (e.commandKey) modifer[CTRL]  = true;
    #else   if (e.ctrlKey)    modifer[CTRL]  = true;
    #end
    
    if (e.shiftKey) modifer[SHIFT] = true;
    if (e.altKey)   modifer[ALT]   = true;
    
    if(!key[e.keyCode]) key[e.keyCode] = true;
    
    for (func in funcs)
    {
      if (key[func.key])
      {
        if (func.modifier == -1) func.func();
        else if(modifer[func.modifier]) func.func();
      }
    }
    
    if (e.keyCode == Key.TAB) Console.instance.toggle();
    if(Console.instance != null && Console.instance.visible)
      printToConsole(e.keyCode);
    
    #if (flash)
      if (!Console.instance.visible) Base.MAIN.stage.focus = Base.MAIN.stage;
    #end
  }
  
  private function keysUp(e:KeyboardEvent):Void 
  {  
    #if mac if (e.commandKey) modifer[CTRL]  = false;
    #else   if (e.ctrlKey)    modifer[CTRL]  = false;
    #end
    
    //if (e.shiftKey) modifer[SHIFT] = false;
    //if (e.altKey)   modifer[ALT]   = false;
    
    modifer[SHIFT] = false;
    modifer[ALT]   = false;
    
    key[e.keyCode] = false;
  }
  
  public function addKeyFunction(key:Int, func:Dynamic, ?modifier:Int = -1):Void
  {
    funcs.push( { modifier:modifier, key:key, func:func } );
  }
  
  public function removeKeyFunction(key:Int, func:Dynamic, ?modifier:Int = -1):Bool
  {
    return funcs.remove( { modifier:modifier, key:key, func:func } );
  }
  
  public function unlockKeyboard():Void
  {
    Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keysDown);
    Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP,   keysUp);
  }
  
  public function lockKeyboard():Void
  {
    Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keysDown);
    Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP,   keysUp);
  }
  
  private function printToConsole(kCode:Int):Void
  {
    #if (flash || neko)
      Base.MAIN.stage.focus = Console.instance.textField;
      if (kCode == Key.ENTER) Console.instance.runScript(Base.scriptEngine);
    #end
    
    if (kCode != Key.ENTER) Console.instance.onKey(kCode); 
  }
  
}

typedef KeyFunction = 
{
  var modifier:Int;
  var func:Dynamic;
  var key:Int;
}