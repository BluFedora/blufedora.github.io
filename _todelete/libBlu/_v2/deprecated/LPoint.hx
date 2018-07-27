package libBlu._v2.deprecated;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class LPoint
{
  public var x:Float;
  public var y:Float;

  public function new(X:Float = 0, Y:Float = 0) 
  {
    x = X;
    y = Y;
  }
  
  public function updateLocation(inPoint:LPoint):Void 
  {
    x = inPoint.x;
    y = inPoint.y;
  }
  
}