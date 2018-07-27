package libBlu._interface;

import libBlu._interface.IPhysics;
import libBlu.geom.Vec;

/**
 * @author Shareef Raheem (Blufedora)
 */

interface IPhysics 
{
  public var force(get, null):Float;
  
  public var restitution:Float;
  public var friction:Float;
  public var velocity:Vec;
  public var mass:Float;
  
  private function updatePhysics():Void;
}