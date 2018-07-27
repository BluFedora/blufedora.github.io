package libBlu._v2.engine ;

import libBlu._v2.GameObject;
import libBlu._v2.Physics;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.utils.ByteArray;

/**
 * ...
 * @author Blufedora
 */
class TopDown extends Platformer
{
  //* New Variables for TopDown View *//
  public var speedY:Float = .12;
  private var downDown:Bool;
  
  private var barrels:Array<GameObject> = [];
  var barrel:GameObject;

  public function new(playerX:Float, playerY:Float, MapFile:ByteArray=null, bgColor:UInt=0x000000) 
  {
    super(playerX, playerY, MapFile, bgColor);
    adventureLog.log("View Set To TopDown\n Gravity Disabled");
    gravityEnabled = false;
    maxSpeedX = 1.4;
    maxSpeedX = 1.4;
    
    for (i in 0...50)  //Barrels for Days
    {
      barrel = new GameObject(0, 36, Assets.getBitmapData("assets/deletableStuff/Barrel.png"));
      barrel.x = Math.random() * 900;
      barrel.y = Math.random() * 540;
      barrels.push(barrel);
      addChild(barrel);
    }
    adventureLog.log("Created: " + barrels.length  + " Barrels");
    
    addEventListener(MouseEvent.CLICK, addNewBarrel);
  }
  
  private function addNewBarrel(e:MouseEvent):Void 
  {
    for (i in 0 ... 5)
    {
      barrel = new GameObject(0, 36, Assets.getBitmapData("assets/deletableStuff/Barrel.png"));
      barrel.x = mouseX + Math.random() * 300;
      barrel.y = mouseY + Math.random() * 200;
      barrels.push(barrel);
      addChild(barrel);
    }
    
    adventureLog.log("There are " + barrels.length + " Barrels");
  }
  
  override function update(e:Event):Void 
  {
    if (!gravityEnabled)
    {
      move();
    }
    else
    {
      super.update(e);
    }
    
    for (i in 0 ... barrels.length)
    {
      moving(barrels[i], _Player);
      barrels[i].updateLoc();
      barrel = null;
    }
    
    
    //collisionDetection();
    //checkBumping();
    updatePoints(_Player, _Player.boundingBox);
    animation();
    
    _Player.velocityX = velocityX;
    _Player.velocityY = velocityY;
    
    //super.update(e);
  }
  
  private function moving(object:GameObject, pusher:Dynamic):Void
  {
    if (pusher.hitTestObject(object.leftMidPoint) || pusher.hitTestObject(object.topLeftPoint) || pusher.hitTestObject(object.topRightPoint) || pusher.hitTestObject(object.rightMidPoint))
    {
      object.velocityX = pusher.velocityX;
    }
    else
    {
      object.velocityX *= Physics.FRICTION * Math.random() * 2;
    }
    
    if (pusher.hitTestObject(object.bottomMidPoint) || pusher.hitTestObject(object.bottomRightPoint) || pusher.hitTestObject(object.bottomLeftPoint) || pusher.hitTestObject(object.topMidPoint) || pusher.hitTestObject(object.topLeftPoint) || pusher.hitTestObject(object.topRightPoint))
    {
      if (gravityEnabled)
      {
        object.velocityY = -pusher.velocityY;
      }
      else
      {
        object.velocityY = pusher.velocityY;
        object.clear();
      }
    }
    else
    {
      object.velocityY *= Physics.FRICTION * Math.random() * 2;
    }
  }
  
  private function move() 
  {
    if (movement.downDown)
    {
      velocityY += speedY;
    }
    else if (!movement.downDown && bottomBumping)
    {
      velocityY  = 0;
    }
    else
    {
      velocityY *= Physics.FRICTION;
    }
    
    if (movement.upDown)
    {
      velocityY -= speedY;
    }
    else
    {
      velocityY *= Physics.FRICTION;
    }
    
    if (movement.rightDown)
    {
      velocityX += speedX;
    }
    else if (!movement.rightDown && rightBumping)
    {
      velocityX  = 0;
    }
    else
    {
      velocityX *= Physics.FRICTION;
    }
    
    if (movement.leftDown)
    {
      velocityX -= speedX;
    }
    else if (!movement.leftDown && leftBumping)
    {
      velocityX  = 0;
    }
    else
    {
      velocityX *= Physics.FRICTION;
    }
    
    if (velocityX > maxSpeedX)
    {
      velocityX = maxSpeedX;
    }
    else if (velocityX < -maxSpeedX)
    {
      velocityX = -maxSpeedX;
    }
    
    if (velocityY > maxSpeedY)
    {
      velocityY = maxSpeedY;
    }
    else if (velocityY < -maxSpeedY)
    {
      velocityY = -maxSpeedY;
    }
    
    _Player.x += velocityX;
    _Player.y += velocityY;
  }
  
  override public function keysDown(evt:KeyboardEvent) 
  {  
    if (evt.shiftKey)
    {
      maxSpeedX = 2.4;
      maxSpeedY = 2.4;
    }
    else
    {
      maxSpeedX = 1.4;
      maxSpeedY = 1;
    }
    
    super.keysDown(evt);
  }
  
}