package libBlu.scripting;

import hscript.Expr;
import hscript.Parser;
import libBlu._assetIO.Asset;
import libBlu.managers.EntityManager;
import libBlu.math.Calc;
import libBlu.scripting.Interp;
import libBlu.scripting.LuaEngine;
import libBlu.scripting.ScriptEngine.ScriptVar;
import libBlu.system.DynamicClass;
import libBlu.system.Error;
import libBlu.ui.Key;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;
import openfl.Lib;

/**
 * Gives Haxe Script Global Access To libBlu
 * @author Shareef Raheem (Blufedora)
 */

@:cppFileCode("#include <iostream>")
class HxsEngine
{
  public static var scriptMemory:Array<ScriptVar> = [];
  private var scriptInterp:Interp = new Interp();
  private var scriptParser:Parser = new Parser();

  public function new() 
  {
    setGlobalFunctions();
    setGlobalClasses();
    scriptParser.allowTypes = true;
    scriptParser.allowJSON = true;
  }
  
  public function runScript(script:String, traceScript:Bool = true):Dynamic
  {
    try {
      var expr:Expr = scriptParser.parseString(script);
      var returnVal = scriptInterp.execute(expr);
      
      if (returnVal != null) return returnVal;
      else return error("Script Failed to Return A Value");
    }
      catch (error:Dynamic)
    {
      trace(error);
    }
    
    if (traceScript) trace("ScriptLoaded: " + script);
    return error("Script Failed to Return A Value");
  }
  
  private function error(msg:String):Dynamic
  {
    return new Error(msg, ErrorType.HSX);
  }
  
  public function callFunction(script:String = ""):Void
  {
    try
    {
      scriptInterp.variables.get(script)();
    }catch (error:Error)
    {
      trace(error);
    }
  }
  
  public function callVariable(variable:String = ""):Dynamic
  {
    try
    {
      return scriptInterp.variables.get(variable);
    }catch (error:Error)
    {
      trace(error);
      return null;
    }
  }
  
  public function addVar(name:String, value:Dynamic):Dynamic
  {
    scriptMemory.push( { name:name, value:value } );
    return value;
  }
  
  public function getVar(varName:String):Dynamic
  {
    for (v in scriptMemory) 
      if (v.name == varName) 
        return v.value;
    
    return 0;//Arbitrary Number
  }
  
  public function setVar(varName:String, value:Dynamic):Void
  {
    for (v in scriptMemory)
    {
      if (v.name == varName)
      {
        v.value = value;
        return;
      }
    }
  }
  
  public function removeVar(varName:String, value:Int):Void
  {
    for (v in scriptMemory)
    {
      if (v.name == varName && v.value == value) 
      {
        scriptMemory.remove(v);
        return;
      }
    }
  }
  
  private function addListener(dispatcher:EventDispatcher, eventType:String, func:Dynamic):Void
  {
    dispatcher.addEventListener(eventType, func);
  }
  
  private function importClass(classPath:String, args:Array<Dynamic>):Void
  {
    //var parts = classPath.split(".");
    //scriptInterp.variables.set(parts[parts.length - 1], Type.createInstance(Type.resolveClass(classPath), args));
    trace(Type.createInstance(Type.resolveClass(classPath), args));
  }
  
  public function exposeMethod(names:Array<String>, method:Dynamic):Void
  {
    for (i in 0...names.length) scriptInterp.variables.set(names[i], method[i]);
  }
  
  private function setGlobalClasses():Void
  {
    //* Utils *//
    scriptInterp.variables.set("Asset", Asset);
    scriptInterp.variables.set("Calc", Calc); 
    scriptInterp.variables.set("Key", Key);
    scriptInterp.variables.set("Math", Math);
    scriptInterp.variables.set("Std", Std);
    
    scriptInterp.variables.set("BitmapData", BitmapData);
    scriptInterp.variables.set("Bitmap", Bitmap);
    scriptInterp.variables.set("Sprite", Sprite);
    scriptInterp.variables.set("Shape", Shape);
    
    //* Events *//
    scriptInterp.variables.set("MouseEvent", MouseEvent);
    scriptInterp.variables.set("Event", Event);
    
    //* Gameplay *//
    scriptInterp.variables.set("Entity",   EntityManager);
    scriptInterp.variables.set("LuaClass", DynamicClass);
    scriptInterp.variables.set("Lua",      LuaEngine);
  }
  
  private function setGlobalFunctions():Void
  {
    //* Utils *//
    scriptInterp.variables.set("log", Lib.trace);
    
    //* Scripts Run Scripts *// Democracy
    scriptInterp.variables.set("global",    addVar);
    scriptInterp.variables.set("getGlobal", getVar);
    scriptInterp.variables.set("setGlobal", setVar);
    scriptInterp.variables.set("removeGlobal", removeVar);
    scriptInterp.variables.set("runScript", runScript);
    
    scriptInterp.variables.set("addEvent", addListener);
  }
  
}