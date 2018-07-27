package libBlu.physics;

import libBlu._interface.IPhysics;
import libBlu.collision.CollidableTile;
import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class PhysicsObject extends CollidableTile implements IPhysics
{
  public var force(get, never):Float;
  
  public var restitution:Float;
  public var friction:Float;
  public var velocity:Vec;
  public var mass:Float;

  public function new(x:Float, y:Float, width:Float, height:Float) 
  {
    super(x, y, width, height);
  }
  
  override public function update():Void 
  {
    super.update();
    updatePhysics();
  }
  
  private function updatePhysics():Void
  {
    
  }
  
  //* Getters and Setters *//
  
  private function get_force():Float 
  {
    return mass * ((velocity.x + velocity.y) / 2);
  }
  
}