package libBlu.display;

import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Camera extends Vec
{
  //* Zoom Vars *//
  public var scaleX:Float = 1;
  public var scaleY:Float = 1;

  public function new(x:Float=0, y:Float=0) 
  {
    super(x, y);
  }
  
  public function traslate():Void
  {
    
  }
  
}