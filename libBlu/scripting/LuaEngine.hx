package libBlu.scripting;

import libBlu._assetIO.Asset;
import libBlu.system.Error;
import lua.Lua_State;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 * LuaState Class for Managing Lua Environments
 * @author Shareef Raheem (Blufedora)
 */
class LuaEngine
{	
	public var lua_state:Lua_State;

	public function new() 
	{
		lua_state = new Lua_State();
		exposeClasses();
	}
	
	public function getGlobal(variable:String):Dynamic
	{
		return lua_state.execute("return " + variable);
	}
	
	public function setGlobal(variable:String, value:Dynamic):Void
	{
		lua_state.execute('$variable = $value');
	}
	
	public function runScript(script:String):Dynamic
	{
		return lua_state.execute(script);
	}
	
	public function callFunction(func:String = "", ?args:Array<Dynamic> = null):Dynamic
	{
		return lua_state.call(func, (args == null) ? [] : args);
	}
	
	public function exposeMethod(vars:Dynamic):Void
	{
		lua_state.setVars(vars);
	}
	
	public function runFile(path:String):Void
	{
		lua_state.executeFile(path);
	}
	
	public function addEvent(dispatcher:EventDispatcher, eventType:String, scriptFile:String):Void
	{
		dispatcher.addEventListener(eventType, eventHandler(scriptFile));
	}
	
	private var _context:Dynamic = null;
	
	public function setContext(c:Dynamic):Void
	{
		_context = c;
		
		exposeClasses();
	}
	
	private function eventHandler(script:String):Dynamic
	{	
		return function(e:Event):Void
		{
			runScript(Asset.getText(script));
		}
	}
	
	private function setVariable(context:Dynamic, field:String, value:Dynamic):Void
	{
		var currentIndex:Dynamic = context;
		
		if (field.indexOf('.') != -1)
		{
			var fields:Array<String> = field.split('.');
			var index:Int = fields.length - 1;
			for (i in 0...index) 
			{
				currentIndex = Reflect.getProperty(currentIndex, fields[i]);
			}
			
			Reflect.setProperty(currentIndex, fields[index], value);
			return;
		}
		
		Reflect.setProperty(context, field, value);
	}
	
	private function getVariable(context:Dynamic, field:String):Dynamic
	{
		var currentIndex:Dynamic = context;
		
		if (field.indexOf('.') != -1)
		{
			var fields:Array<String> = field.split('.');
			for (f in fields) currentIndex = Reflect.getProperty(currentIndex, f);
		}
		else currentIndex = Reflect.getProperty(context, field);
		
		return currentIndex;
	}
	
	private function callCppFunction(context:Dynamic, field:String, args:Array<Dynamic>):Void
	{
		var method = Reflect.callMethod(context, getVariable(context, field), (args == null) ? []:args);
		//(method == null) ? new Error("No Return", ErrorType.Lua, 0) : method;
	}
	
	private var instances:Array<{name:String, value:Dynamic}> = [];
	
	private function newVariable(name:String, className:String, args:Array<Dynamic>):Void
	{
		var instance:Dynamic = Type.createInstance(Type.resolveClass(className), (args == null) ? []:args);
		instances.push({name:name, value:instance});
	}
	
	private function getInstance(name:String):Dynamic
	{
		for (val in instances)
		{
			if (val.name != name) continue;
			
			if (val.name == name) {
				return val.value;
			}
		}
		
		return null;
	}
	
	private function editInstance(name:String, field:String, value:Dynamic):Void
	{
		setVariable(getInstance(name), field, value);
	}
	
	private function addChild(child:String):Void
	{
		var c = getInstance(child);
		_context.addChild(c);
	}
	
	private function relativePath(path:String):String
	{
		return Asset.relativePath(path, "Vk Toolkit.exe");
	}
	
	private function getPath(path:String):Array<String>
	{
		return Asset.getPath(path);
	}
	
	private function log(v:Dynamic) trace(v);
	
	private function exposeClasses():Void
	{
		lua_state.loadLibs(
		[
			"package", 
			"string",
			"debug", 
			"table",
			"base", 
			"math", 
			"io", 
			"os"
		]);
		
		lua_state.setVars(
		{
			print:log.bind(),
			file:
				{
					relativePath:relativePath.bind(),
					getDirectory:getPath.bind()
				},
			call:callCppFunction.bind(_context),
			get:getVariable.bind(_context),
			set:setVariable.bind(_context),
			create:newVariable.bind(),
			getIns:getInstance.bind(),
			edit:editInstance.bind(),
			add:addChild.bind()
		});
	}
	
}