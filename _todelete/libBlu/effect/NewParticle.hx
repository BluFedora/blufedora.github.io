package libBlu.effect;

import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
@:allow(libBlu.effect.ParticleEngine)
class NewParticle
{
	private var isActive:Bool = false;
	private var _vector:Vec;
	private var _gravity:Vec;
	private var _position:Vec;
	private var _friction:Float;
	
	private var x:Float;
	private var y:Float;

	public function new(x:Float = 0, y:Float = 0, movementVector:Vec) 
	{
		this._vector = movementVector;
		
		this.x = x;
		this.y = y;
	}
	
	private function update():Void
	{
		if (isActive)
		{	
			_position.x += _vector.x;
			_position.y += _vector.y;
			
			_vector.y += _gravity.y;
			_vector.x += _gravity.x;
			_vector.x *= _friction;
			
			this.x = _position.x;
			this.y = _position.y;
		}
	}
	
	private function delete():Void
	{
		isActive = false;
	}
	
}