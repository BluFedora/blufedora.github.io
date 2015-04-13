package blufedora.animation;

import blufedora.animation.Animation;
import blufedora.animation.AnimationOptions;
import blufedora.animation.JSAnimObject;
import js.Browser;
import js.html.Window;

/**
 * ...
 * @author Shareef Raheem
 */
class Tweener
{
	private static var anims:Array<Animation>;
	private static var toRemove:Array<Animation>;
	private static var start:Null<Float>;
	private static var handle:Int;
	
	public static function init(window:Window):Bool
	{
		Tweener.anims    = [];
		Tweener.toRemove = [];
		Tweener.start    = null;
		Tweener.handle   = 0;
		
		js.Syntax.code("
			(function() 
			{
        var vendors = ['ms', 'moz', 'webkit', 'o'];
				var lastTime = 0;
				
				for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) 
				{
					window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame'];
					window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] 
											   || window[vendors[x] + 'CancelRequestAnimationFrame'];
				}
				
				if (!window.requestAnimationFrame) 
				{
					window.requestAnimationFrame = function(callback, element) 
					{
						var currTime = new Date().getTime();
						var timeToCall = Math.max(0, 16 - (currTime - lastTime));
						
						var id = window.setTimeout(
							function() { 
								callback(currTime + timeToCall); 
							}, 
							timeToCall);
							
						lastTime = currTime + timeToCall;
						return id;
					};
				}
				
				if (!window.cancelAnimationFrame) 
				{
					window.cancelAnimationFrame = function(id) 
					{
						clearTimeout(id);
					};
				}
			}());
		");
		
		Tweener.updateTweens(0.0);
		
		return true;
	}
	
	public static function add(target:Dynamic, params:AnimationOptions):Animation
	{
		var anim = new Animation(new JSAnimObject(target), params);
		Tweener.anims.push(anim);
		return anim;
	}
	
	public static function remove(anim:Animation):Void
	{
		Tweener.toRemove.push(anim);
	}
	
	private static function updateTweens(timestamp:Float):Void
	{
		var progress:Float = (Tweener.start == null) ? 0.0 : timestamp - start; // In Milliseconds
		
		for (anim in Tweener.toRemove)
		{
			Tweener.anims.remove(anim);
		}
		
		Tweener.toRemove.splice(0, Tweener.toRemove.length);
		
		for (anim in Tweener.anims)
		{
			anim.update(progress);
		}
		
		Tweener.start = timestamp;
		
		Tweener.handle = Browser.window.requestAnimationFrame(Tweener.updateTweens);
	}
	
	public static function destroy():Void
	{
		Browser.window.cancelAnimationFrame(Tweener.handle);
	}
}