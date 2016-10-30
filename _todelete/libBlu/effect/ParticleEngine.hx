package libBlu.effect;

import libBlu.effect.NewParticle;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
@:allow(libBlu.effect.NewParticle)
class ParticleEngine
{
	private var particleEmitters:Array<NewParticle>;
	private var _gravity:Float;

	public function new(gravity:Float) 
	{
		particleEmitters = [];
		this._gravity = gravity;
	}
	
	public function addEmmiter(part:NewParticle):Int
	{
		return particleEmitters.push(part);
	}
	
	public function removeEmmiter(part:NewParticle):Bool
	{
		return particleEmitters.remove(part);
	}
	
	public function update():Void
	{
		for (particle in particleEmitters)
		{
			particle.update();
		}
	}
	
	public function purge():Void
	{
		for (particle in particleEmitters) particle.delete();
		particleEmitters = [];
	}
}