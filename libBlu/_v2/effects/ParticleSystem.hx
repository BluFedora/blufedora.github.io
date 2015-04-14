package libBlu._v2.effects ;

import openfl.display.Shape;
import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.utils.Timer;

/**
 * ...
 * @author Shareef Raheem
 */
class ParticleSystem extends Shape
{
	@:protected var update_i:Timer;
	@:protected var position:Point;
	@:protected var vector:Point;
	
	private var friction:Float;
	private var gravity:Float;
	private var timing:Int;

	public function new(_position:Point, _vector:Point, _gravity:Float, _friction:Float, _fade:Int) 
	{
		super();
		
		position = _position;
		friction = _friction;
		gravity = _gravity;
		vector = _vector;
		x = position.x;
		y = position.y;
		timing = _fade;
		
		update_i = new Timer(16, _fade);//62.5fps
		update_i.addEventListener(TimerEvent.TIMER_COMPLETE, killParticle);
		update_i.addEventListener(TimerEvent.TIMER, update);
		update_i.start();
	}
	
	private function update(evt:TimerEvent):Void
	{
		position.x += vector.x;
		position.y += vector.y;
		
		vector.y += gravity;
		vector.x *= friction;
		
		x = position.x;
		y = position.y;
		
		alpha -= 1 / timing;
    }
	
	private function killParticle(e:TimerEvent):Void 
	{
		update_i.removeEventListener(TimerEvent.TIMER_COMPLETE, killParticle);
		update_i.removeEventListener(TimerEvent.TIMER, update);
		graphics.clear();
		parent.removeChild(this);
	}
	
}