package libBlu.system;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Error
{
	var errorMessage:String = "No Error Here";
	var errorType:ErrorType = ErrorType.CPP;

	public function new(msg:String, type:ErrorType = null, id:Int = 0)
	{
		errorMessage = msg;
		errorType   = type;
		switch(type)
		{
			case ErrorType.CPP: trace('Src Error: $msg ErrorCode[$id]');
			case ErrorType.HSX: trace('Hsx Error: $msg ErrorCode[$id]');
			case ErrorType.XML: trace('Xml Error: $msg ErrorCode[$id]');
			case ErrorType.Lua: trace('Lua Error: $msg ErrorCode[$id]');
			default: trace('Error: $msg ErrorCode[$id]');
		}
	}
	
	private function toString():String
	{
		return "Error: " + errorMessage;
	}
	
	public static inline function deepTrace(obj:DisplayObject, ?fields:Array<String>, level:Int = 0 ):Void
	{
		var tabs:String = "";
		var i:Int = 0;
		var l:Int = level;
		for ( i in 0...l){
			tabs += "\t";
		}
		
		var printData = function(newField, fieldString)
		{
			return fieldString + (fieldString != "" ? "; " : "") +newField+ " : " +Reflect.field(obj, newField);
		}
		
		if(fields != null && fields.length > 0){
			try{
				trace(tabs + obj + " -> ( " + Lambda.fold(fields, printData, "") + " )");
			}catch(e:Error){
				trace(tabs + obj + " -> ( has no fields ["+fields+"] )");
			}
		}
		
		if (Std.is(obj, DisplayObjectContainer))
		{
			for (i in 0...Reflect.field(obj, "numChildren"))
			{
				deepTrace( Reflect.field(obj, "getChildAt")(i), fields, level + 1 );
			}
		}
	}
	
}

enum ErrorType {
	HSX;
	XML;
	CPP;
	Lua;
}