package libBlu.collision;

import libBlu.geom.Ray;
import libBlu.geom.Vec;

/**
 * Data Handling for Collision Detection
 * @author Shareef Raheem (Blufedora)
 */
class Data
{
    public var overlap:Float = 0; 
    public var separation:Vec;
  public var unitVector:Vec; 
    public var solid1:Solid;
    public var solid2:Solid;

  @:noCompletion public function new() 
  {
    separation = new Vec(); 
        unitVector = new Vec();
  }
  
}

class RayData
{
  public var shape:Solid;
  public var ray:Ray;
  
  public var start:Float;
  public var end:Float;
  
  public function new(shape:Solid, ray:Ray, start:Float, end:Float) 
  {
    this.shape = shape;
    this.ray = ray;
    
    this.start = start;
    this.end = end;
  }
}

class RayIntersection
{
  public var ray1:Ray;
  public var ray2:Ray;
  public var u1:Float;
  public var u2:Float;
  
  public function new(ray1:Ray, u1:Float, ray2:Ray, u2:Float) 
  {
    this.ray1 = ray1;
    this.ray2 = ray2;
    
    this.u1 = u1;
    this.u2 = u2;
  }
  
}