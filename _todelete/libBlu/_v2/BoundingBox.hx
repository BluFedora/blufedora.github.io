package libBlu._v2 ;

import openfl.display.Shape;
import openfl.display.Sprite;
import TestDummy;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class BoundingBox extends Sprite
{
  public var _Player:TestDummy = new TestDummy();
  public var boundingBox:Shape = new Shape();
  
  public var velocityX:Float = 0;
  public var velocityY:Float = 0;

  public function new() 
  {
    super();
    //* Bounding Box Fill *//
    boundingBox.graphics.beginFill(0xDABBFD, .4);
    
    boundingBox.graphics.moveTo(0, 0);
    boundingBox.graphics.lineTo(30, 0);
    boundingBox.graphics.lineTo(30, 16);
    boundingBox.graphics.lineTo(0, 16);
    
    boundingBox.graphics.endFill();
    
    boundingBox.x = 5;
    boundingBox.y = 18;
    
    addChild(boundingBox);
    _Player.scaleX *= 2;
    _Player.scaleY *= 2;
    addChild(_Player);
  }
  
}