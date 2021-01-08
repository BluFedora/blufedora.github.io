package com.blufedora.animation;

/**
 * ...
 * @author Shareef Raheem
 */
class Animation
{
	public var target:IAnimObject;
	public var props:AnimationOptions;
	public var steps:Array<AnimationStep>;
	
	private var _index:Int;
	private var _deltaTime:Float;

	public function new(target:IAnimObject, options:AnimationOptions) 
	{
		this.target 	= target;
		this.props 		= options;
		this.steps 		= [];
		
		this._index 	  = 0;
		this._deltaTime = 0;
	}
	
	public function to(step:AnimationStep):Animation
	{
		step.init(this.target);
		this.steps.push(step);
		return this;
	}
	
	public function wait(ms:Float):Animation
	{
		return this.to(new AnimationStep({}, ms, Easing.easeLinear));
	}
	
	public function update(ms:Float):Void
	{
		this._deltaTime += ms;
		
		if (this.steps.length > 0 && this._index >= 0)
		{
			var step = this.steps[this._index];
			
			if (step != null)
			{
				if ((this._deltaTime / step.time) > 1.0)
				{
					if (this.incIndex()) 
					{
						step = this.steps[this._index];
					} 
					else 
					{
						step = null;
					}
				}
			}
			else
			{
				this.setIndex( -1);
			}
			
			if (step != null)
			{
				// var time 		= this._deltaTime;
				var timeTot 	= step.time;
				
				for (field in Reflect.fields(step.properties))
				{
					var startVal 	= Reflect.field(step.startProps, field);
					var finalVal 	= Reflect.field(step.properties, field);
					var deltaValue 	= finalVal - startVal;
					
					var value = step.easing(
						this._deltaTime, 
						startVal, 
						deltaValue,					
						timeTot
					);
					
					Reflect.setProperty(target, field, value);
				}
			}
		}
	}
	
	private function incIndex():Bool
	{
		return this.setIndex(this._index + 1);
	}
	
	private function setIndex(value:Int):Bool
	{
		this._index 	= value;
		this._deltaTime = 0.0;
		
		if (this._index >= this.steps.length)
		{
			var newIndex = (this.props.loop) ? 0 : -1;
			
			return this.setIndex(newIndex);
		}
		else if (this._index < 0)
		{
			Tweener.remove(this);
			return false;
		}
		
		this.steps[this._index].init(this.target);
		
		return true;
	}
}