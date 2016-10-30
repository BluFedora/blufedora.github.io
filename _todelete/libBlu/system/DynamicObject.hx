package libBlu.system;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
abstract DynamicObject(Dynamic) from Dynamic
{
	public inline function new() 
	{
		this = {};
	}

	@:arrayAccess
	public inline function set(key:String, value:Dynamic):Void 
	{
		Reflect.setField(this, key, value);
	}

	@:arrayAccess
	public inline function get(key:String):Null<Dynamic> 
	{
		#if js
			return untyped this[key];
		#else
			return Reflect.field(this, key);
		#end
	}
	
	@:op(A + B)
	public inline function add(add:Dynamic):DynamicObject
	{
		var newFields:Array<String> = Reflect.fields(add);
		
		for (field in newFields)
		{
			Reflect.setField(this, field, Reflect.field(add, field));
		}
		
		return this;
	}

	public inline function exists(key:String):Bool 
	{
		return Reflect.hasField(this, key);
	}

	public inline function remove(key:String):Bool 
	{
		return Reflect.deleteField(this, key);
	}

	public inline function keys():Array<String> 
	{
		return Reflect.fields(this);
	}
}