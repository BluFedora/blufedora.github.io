package libBlu.scripting;
#if !flash
import libBlu.scripting.HxsEngine;
import libBlu.scripting.LuaEngine;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class ScriptEngine
{
  public var LUA_STATE:LuaEngine = new LuaEngine();
  public var HX_SCRIPT:HxsEngine = new HxsEngine();

  public function new() 
  {
    
  }
  
  public function runScript(script:String, type:SCRIPT):Void
  {
    switch(type)
    {
      case SCRIPT.HXS: HX_SCRIPT.runScript(script, false);
      case SCRIPT.LUA: LUA_STATE.runScript(script);
    }
  }
  
  public function callFunction(script:String = "", type:SCRIPT, ?args:Dynamic):Void
  {
    switch(type)
    {
      case SCRIPT.HXS: HX_SCRIPT.callFunction(script);
      case SCRIPT.LUA: LUA_STATE.callFunction(script, args);
    }
  }
  
  public function exposeMethod(names:Dynamic, type:SCRIPT, ?values:Dynamic):Void
  {
    switch(type)
    {
      case SCRIPT.HXS: HX_SCRIPT.exposeMethod(names, values);
      case SCRIPT.LUA: LUA_STATE.exposeMethod(names);
    }
  }
  
}

#end

typedef ScriptVar = 
{
  name:String,
  value:Dynamic
}

enum SCRIPT
{
  LUA;
  HXS;
}