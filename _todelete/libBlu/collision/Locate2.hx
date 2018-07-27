package libBlu.collision;

import libBlu._enum.Location;
import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
 
class Locate2
{
  public static var LOC:Array<EnumValue> = 
  [
    Location.TOP_LEFT,    Location.TOP_MID,    Location.TOP_RIGHT, 
    Location.MID_LEFT,    Location.MID_RIGHT,  Location.CENTER, 
    Location.BOTTOM_LEFT, Location.BOTTOM_MID, Location.BOTTOM_RIGHT
  ];
  
  public static inline function pointLoc(object:Dynamic, location:EnumValue):Vec
  {  
    var returnValue:Vec = new Vec(0, 0);
    var hMaxY:Float = object.y + (object.height / 2);
    var hMaxX:Float = object.x + (object.width / 2);
    var maxY:Float = object.y + object.height;
    var maxX:Float = object.x + object.width;
    
    switch(location)
    {
      case TOP_LEFT:     returnValue.setLoc(object.x, object.y);
      case TOP_RIGHT:    returnValue.setLoc(maxX,     object.y);
      case TOP_MID:      returnValue.setLoc(hMaxX,    object.y);
      
      case BOTTOM_RIGHT: returnValue.setLoc(maxX,     maxY);
      case BOTTOM_LEFT:  returnValue.setLoc(object.x, maxY);
      case BOTTOM_MID:   returnValue.setLoc(hMaxX,    maxY);
      
      case MID_RIGHT: returnValue.setLoc(maxX,     hMaxY);
      case MID_LEFT:  returnValue.setLoc(object.x, hMaxY);
      case CENTER:    returnValue.setLoc(hMaxX,    hMaxY);
    }
    
    return returnValue;
  }
}