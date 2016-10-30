package libBlu._v2.effects;

import libBlu.math.Calc;
import openfl.geom.Point;

/**
 * ...
 * @author Shareef Raheem
 */
class Particle extends ParticleSystem
{
	public function new(_position:Point, _vector:Point, _gravity:Float, _friction:Float, size:Int = 2, colorArray:Array<UInt>, _fade:Int = 30) 
	{
		super(_position, _vector, _gravity, _friction, _fade);
		
		for (color in colorArray)
		{
			var randX = Calc.randomRange(-20, 20);
			var randY = Calc.randomRange( -3, 10);
			
			graphics.beginFill(color, Math.random());
			graphics.drawRect(randX, randY, size, size);
			graphics.drawCircle(randX - (size / 2), randY - (size / 2), size / 2);
		}
		
		graphics.endFill();
	}
	
}