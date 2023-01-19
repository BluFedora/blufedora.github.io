/******************************************************************************/
/*!
 * @file   AnimationStep.hx
 * @author Shareef Abdoul-Raheem (http://blufedora.github.io/)
 * @brief
 *   Main entry point to the my website's interativity.
 *
 * @version 0.0.1
 * @date    2020-12-25
 *
 * @copyright Copyright (c) 2019-2020
 */
/******************************************************************************/
package com.blufedora.animation;

/**
 * A single frame of an an animation.
 * @author Shareef Abdoul-Raheem (BluFedora)
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
		this.easing 	  = easeFunc;
		this.time 		  = time;
		
		this._fields 	= Reflect.fields(this.properties);
	}
	
	public function init(target:IAnimObject):Void
	{
		for (field in this._fields) {
			Reflect.setField(this.startProps, field, Reflect.getProperty(target, field));
		}
	}
}