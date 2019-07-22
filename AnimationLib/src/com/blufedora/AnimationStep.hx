package com.blufedora;

/**
 * ...
 * @author Shareef Raheem
 */
class AnimationStep
{
	public var properties:Dynamic;
	public var startProps:Dynamic;
	public var easing:Dynamic;
	public var time:Float;

	private var _fields:Array<String>;
	
	public function new(properties:Dynamic, time:Float, easeFunc:Dynamic) 
	{
		this.properties = properties;
		this.startProps = {};
		this.easing 	= easeFunc;
		this.time 		= time;
		
		this._fields 	= Reflect.fields(this.properties);
	}
	
	public function init(target:IAnimObject):Void
	{
		for (field in this._fields) {
			Reflect.setField(this.startProps, field, Reflect.getProperty(target, field));
		}
	}
}