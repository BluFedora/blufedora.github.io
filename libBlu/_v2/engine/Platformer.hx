package libBlu._v2.engine ;

import assetIO.VkTkMap;
import libBlu._v2.deprecated.Controls;
import libBlu._v2.effects.Particle;
import libBlu._v2.EngineBase;
import libBlu._v2.BoundingBox;
import libBlu._v2.Physics;
import libBlu.debug.Debug;
import libBlu.debug.Logger;
import libBlu.ui.Key;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.utils.ByteArray;
import RMap;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Platformer extends EngineBase
{
	//* Game Objects *//
	private var bevel:Bitmap = new Bitmap(Assets.getBitmapData("assets/textures/Bevel.png"));
	private var _Player:BoundingBox = new BoundingBox();
	
	#if !TKE
		private var debug:Debug = new Debug(10, 10, 0x2E5A3C);
		public var adventureLog:Logger = new Logger();
	#end
	private var movement:Controls = new Controls();
	private var particles:Particle;
	private var _Map:Bitmap;
	
	//* Background Render Rectangles *//
	private var scrollRectangle0:Rectangle = new Rectangle(0, 0, 960, 540);
	private var scrollRectangle1:Rectangle = new Rectangle(0, 0, 960, 540);
	private var scrollRectangle2:Rectangle = new Rectangle(0, 0, 960, 540);
	private var scrollRectangle3:Rectangle = new Rectangle(0, 0, 960, 540);
	private var scrollRectangle4:Rectangle = new Rectangle(0, 0, 960, 540);
	
	//* Booleans for Stuff *//
	private var particlesEnabled:Bool = true;
	public var bottomBumping:Bool     = false;
	public var rightBumping:Bool      = false;
	public var leftBumping:Bool       = false;
	private var facingRight:Bool      = true;
	public var topBumping:Bool        = false;
	public var jumping:Bool           = false;
	public var gravityEnabled:Bool    = true;
	private var ctrl:Bool             = false;
	
	//* Floats and Stuff for GamePlay *//
	public var resetPlayerX:Float = 0;
	public var resetPlayerY:Float = 0;
	
	public var maxSpeedX:Float = Physics.VX();
	public var maxSpeedY:Float = Physics.VY();
	
	public var velocityX:Float = 0;
	public var velocityY:Float = 0;
	public var jumpSpeed:Float = 0;
	public var speedX:Float    = .2;
	
	//* Non Gameplay Floats *//
	private var _mapFile:ByteArray;
	
	private var offSetY:Float = 0;
	
	public function new(playerX:Float, playerY:Float, MapFile:ByteArray = null, bgColor:UInt = 0x000000) 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, _addedToStage);
		
		#if !TKE
			Lib.current.stage.color = bgColor;
			layerH.addChild(adventureLog);
			layerH.addChild(debug);
			offSetY = 36;
		#end
		
		layer5.addChild(bevel).alpha = .2;
		layerH.addChild(_Player);
		_Player.x = playerX;
		_Player.y = playerY;
		_mapFile = MapFile;
		initialize();
	}
	
	private function _addedToStage(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, _addedToStage);
		
		if (_mapFile != null)
		{
			_Map = VkTkMap.loadMap(_mapFile);
			layer5.addChild(_Map);
			_Map.x -= 72;
			_Map.y -= 36;
			
			initEventListeners();
		}
		else 
		{
			addMapToStage();
		}
	}
	
	override public function update(e:Event):Void 
	{	
		Physics.updateVars();
		maxSpeedX = Physics.VX();
		maxSpeedY = Physics.VY();
		
		if (!ctrl)
		{
			if (gravityEnabled)
			{
				if (jumping)
				{
					velocityY += jumpSpeed;
				}
				
				if (topBumping)
				{
					_Player.y += 2;
				}
				
				if (movement.key[Key.D] && !rightBumping)
				{
					velocityX += speedX;
					facingRight = true;
				}
				else if (!movement.key[Key.D] && rightBumping)
				{
					velocityX  = 0;
				}
				else
				{
					velocityX *= Physics.F();
				}
				
				if (movement.key[Key.A] && !leftBumping)
				{
					velocityX -= speedX;
					facingRight = false;
				}
				else if (!movement.key[Key.A] && leftBumping)
				{
					velocityX  = 0;
				}
				else
				{
					velocityX *= Physics.F();
				}
			}
			
			//* Handle Collision *//
			collisionDetection();
			checkBumping();
			
			if (gravityEnabled)
			{
				if (bottomBumping)
				{
					if (!jumping)
					{
						velocityY += .03;
						velocityY *= .01;
					}
					else
					{
						jumping = false;
					}
				}
				else if (!bottomBumping)
				{
					velocityY -= Physics.G();
				}
				
				_Player.y -= velocityY / 3;
			}
			
			//* Handle Collision Again *//
			collisionDetection();
			checkBumping();
			
			if (velocityX > maxSpeedX)
			{
				velocityX = maxSpeedX;
			}
			else if (velocityX < -maxSpeedX)
			{
				velocityX = -maxSpeedX;
			}
			
			if (_Player.x >= 100 && movement.key[Key.A] || _Player.x <= 960 - 100 && movement.key[Key.D])
			{
				_Player.x += velocityX;
			}
			else
			{	
				scrollRectangle0.x += velocityX * (.025 / 5);
				scrollRectangle1.x += velocityX * (.03125 / 5);
				scrollRectangle2.x += velocityX * (.0416 / 5);
				scrollRectangle3.x += velocityX * (.0625 / 5);
				scrollRectangle4.x += velocityX * (.125 / 5);
				
				if (scrollRectangle0.x >= 0)
				{
					layer0.scrollRect = scrollRectangle0;
					layer1.scrollRect = scrollRectangle1;
					layer2.scrollRect = scrollRectangle2;
					layer3.scrollRect = scrollRectangle3;
					layer4.scrollRect = scrollRectangle4;
				}
				
				_Map.x -= velocityX;
			}
			
			_Player.velocityX = velocityX;
			_Player.velocityY = velocityY;
			
			//* Draw Functions Last *//
			updatePoints(_Player, _Player.boundingBox);
			particleEffects();
			animation();
			
			if (_Player.y > 560) reset();
			
			super.update(e);
		}
	}
	
	private function particleEffects() 
	{
		if (particlesEnabled)
		{
			if (_Map.x + 500 > 0)
			{
				particles = new Particle(new Point(_Map.x + 500, 360), new Point(Math.random() - Math.random() * 5, -Math.random() * 5), 0, Physics.F(), 3, [0xFD8E9F, 0xFA054F, 0xFD8602, 0xEB4A14], 20);
				addChild(particles);
				particles = new Particle(new Point(_Map.x + 550, 355), new Point(Math.random() - Math.random() * 15, -Math.random() * 10), -.6, Physics.F(), 6, [0xB38EFD, 0x0473FB, 0x8083F7, 0x875BE1], 40);
				addChild(particles);
			}
			
			if (bottomBumping || jumping)
			{
				if (movement.key[Key.D] || movement.key[Key.A])
				{
					particles = new Particle(new Point(_Player.x + _Player.width / 2, _Player.y + _Player.height), new Point(Math.random() - Math.random() * 5, -Math.random() * 5), Physics.G(), Physics.F(), 3, [0xFFFFFF, 0x000000, 0x00FFFF, 0xFF0080], 100);
					addChild(particles);
				}
				else if (jumping)
				{
					for (i in 0...20)
					{
						particles = new Particle(new Point(_Player.x + _Player.width / 2, _Player.y + _Player.height), new Point(Math.random() - Math.random() * 5, -Math.random() * 5), Physics.G(), Physics.F(), 3, [0xFFFFFF, 0x000000, 0x00FFFF, 0xFF0080], 30);
						addChild(particles);
					}
				}
			}
		}
	}
	
	private function animation():Void
	{	
		if (movement.key[Key.A])
		{
			facingRight = false;
			_Player._Player.queueBehavior("WalkingTwo");
		}
		else if (movement.key[Key.D])
		{
			facingRight = true;
			_Player._Player.queueBehavior("Walking");
		}
		
		if (!movement.key[Key.D] && !movement.key[Key.A] && movement.eDown)
		{
			if (facingRight)
			{
				_Player._Player.queueBehavior("Attack");
			}
			else
			{
				_Player._Player.queueBehavior("AttackTwo");
			}
		}
		else if (movement.downDown && !movement.eDown && !movement.key[Key.D] && !movement.key[Key.A])
		{
			if (facingRight)
			{
				_Player._Player.queueBehavior("Ducking");
			}
			else
			{
				_Player._Player.queueBehavior("DuckingTwo");
			}
		}
		else if (!movement.key[Key.D] && !movement.key[Key.A] && !movement.eDown && !movement.downDown)
		{
			if (facingRight)
			{
				_Player._Player.showBehavior("Standing");
			}
			else if (!facingRight)
			{
				_Player._Player.showBehavior("StandingTwo");
			}
		}
	}
	
	public function checkBumping():Void
	{
		if (leftBumping && movement.key[Key.A] || rightBumping && movement.key[Key.D])
		{
			velocityX = 0;
		}
		else if (movement.key[Key.A] && movement.key[Key.D])
		{
			velocityX *= Physics.FRICTION;
		}
	}
	
	public function collisionDetection() 
	{
		//* Ground Testing *//
		if (
			!isTransparentPixel(_Map.bitmapData, bottomLeftPoint.x, bottomLeftPoint.y, -_Map.x + 4, offSetY) ||
			!isTransparentPixel(_Map.bitmapData, bottomMidPoint.x, bottomMidPoint.y, -_Map.x, offSetY) ||
			!isTransparentPixel(_Map.bitmapData, bottomRightPoint.x, bottomRightPoint.y, -_Map.x - 4, offSetY)
			)
		{	
			if (!jumping)
			{
				if (
					isTransparentPixel(_Map.bitmapData, bottomMidPoint.x, bottomMidPoint.y, -_Map.x, offSetY) && rightBumping || 
					isTransparentPixel(_Map.bitmapData, bottomMidPoint.x, bottomMidPoint.y, -_Map.x, offSetY) && leftBumping)
				{
					bottomBumping = false;
					_Player.y += Physics.GRAVITY;
				}
				else
				{
					bottomBumping = true;
				}
			}
			
			bottomBumping = true;
		}
		else
		{
			bottomBumping = false;
		}
		
		if (gravityEnabled)
		{
			if 
			(
				_Map.bitmapData.getPixel32(Std.int(bottomLeftPoint.x + -_Map.x + 3), Std.int(bottomLeftPoint.y - 3 + offSetY)) != 0 ||
				_Map.bitmapData.getPixel32(Std.int(bottomMidPoint.x + -_Map.x), Std.int(bottomMidPoint.y - 3 + offSetY)) != 0 ||
				_Map.bitmapData.getPixel32(Std.int(bottomRightPoint.x + -_Map.x - 3), Std.int(bottomRightPoint.y - 3 + offSetY)) != 0)
			{
				_Player.y -= .1;
			}
		}
		
		//* Right Testing *//
		if (
			_Map.bitmapData.getPixel32(Std.int(topRightPoint.x + -_Map.x), Std.int(topRightPoint.y + offSetY)) != 0 ||
			_Map.bitmapData.getPixel32(Std.int(rightMidPoint.x + -_Map.x), Std.int(rightMidPoint.y + offSetY)) != 0 ||
			_Map.bitmapData.getPixel32(Std.int(bottomRightPoint.x + -_Map.x), Std.int(bottomRightPoint.y - 10 - offSetY)) != 0
		)
		{
			rightBumping = true;
			_Player.x -= .05;
		}
		else
		{
			rightBumping = false;
		}
		
		//* Left Testing *//
		if (
			_Map.bitmapData.getPixel32(Std.int(topLeftPoint.x + -_Map.x), Std.int(topLeftPoint.y + offSetY)) != 0 ||
			_Map.bitmapData.getPixel32(Std.int(leftMidPoint.x + -_Map.x), Std.int(leftMidPoint.y + offSetY)) != 0 ||
			_Map.bitmapData.getPixel32(Std.int(bottomLeftPoint.x + -_Map.x), Std.int(bottomLeftPoint.y - 10 + offSetY)) != 0
		)
		{
			leftBumping = true;
			_Player.x += .05;
		}
		else
		{
			leftBumping = false;
		}
		
		//* Top Testing *//
		if ( //isTransparentPixel(_Map.bitmapData, topLeftPoint.x, 
			_Map.bitmapData.getPixel32(Std.int(topLeftPoint.x + -_Map.x + 4), Std.int(topLeftPoint.y + offSetY)) != 0 ||
			_Map.bitmapData.getPixel32(Std.int(topMidPoint.x + -_Map.x), Std.int(topMidPoint.y + offSetY)) != 0 ||
			_Map.bitmapData.getPixel32(Std.int(topRightPoint.x + -_Map.x - 4), Std.int(topRightPoint.y + offSetY)) != 0)
		{	
			topBumping = true;
		}
		else
		{
			topBumping = false;
		}
	}
	
	public function initEventListeners() 
	{
		if (_Map != null)
		{
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keysDown);
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keysUp);
			//var timer:Timer = new Timer(12); timer.start();
			//timer.addEventListener(TimerEvent.TIMER, update);
		}
	}
	
	private function keysUp(e:KeyboardEvent):Void 
	{
		if (e.ctrlKey)
		{
			ctrl = false;
		}
	}
	
	public function keysDown(evt:KeyboardEvent) 
	{	
		if (evt.keyCode == Key.SPACEBAR)
		{
			jump();
		}
		
		if (evt.keyCode == Key.B)
		{
			_Player.scaleY -= 1 / 18;
		}
		
		if (evt.keyCode == Key.V)
		{
			_Player.scaleY += 1 / 18;
		}
		
		if (evt.ctrlKey)
		{
			ctrl = true;
			
			if (evt.keyCode == Key.PLUS_EQUALS)
			{
				if (scaleX > .1)
				{
					scaleAround(480, 270, scaleX + .1, scaleY + .1);
				}
			}
			
			if (evt.keyCode == Key.MINUS_UNDERSCORE)
			{	
				if (scaleX > .2)
				{
					scaleAround(480, 270, scaleX - .1, scaleY - .1);
				}
			}
			
			if (evt.keyCode == Key.UP_ARROW)
			{
				y += 18;
			}
			
			if (evt.keyCode == Key.DOWN_ARROW)
			{
				y -= 18;
			}
			
			if (evt.keyCode == Key.LEFT_ARROW)
			{
				x += 18;
			}
			
			if (evt.keyCode == Key.RIGHT_ARROW)
			{
				x -= 18;
			}
			
			if (evt.keyCode == Key.Q)
			{
				setFps();
			}
			
			if (evt.keyCode == Key.R)
			{
				rot(this, 480, 270, -.196349541);// 45 / 4 = 11.25 to radians
			}
			
			if (evt.keyCode == Key.T)
			{
				rot(this, 480, 270, .196349541);
			}
			
			if (evt.keyCode == Key.P)
			{
				particlesEnabled = !particlesEnabled;
			}
			
			if (evt.keyCode == Key.G)
			{
				gravityEnabled = !gravityEnabled;
			}
			
			#if !TKE
				if (evt.keyCode == Key.NUMBER_1)
				{
					adventureLog.scrollUp();
				}
				
				if (evt.keyCode == Key.NUMBER_2)
				{
					adventureLog.scrollDown();
				}
				
				if (evt.keyCode == Key.NUMBER_3)
				{
					adventureLog.scrollToBottom();
				}
				
				if (evt.keyCode == Key.NUMBER_4)
				{
					adventureLog.scrollToTop();
				}
			#end
		}
	}
	
	public function jump():Void
	{
		if (!jumping)
		{
			if (bottomBumping)
			{
				jumpSpeed = Physics.J();
				rightBumping = false;
				leftBumping = false;
				jumping = true;
			}
		}
	}
	
	private function initialize():Void
	{
		initLayers();
		initPoints();
	}
	
	public function reset():Void
	{
		_Player.x = resetPlayerX;
		_Player.y = resetPlayerY;
		scrollRectangle0.x = 0;
		scrollRectangle1.x = 0;
		scrollRectangle2.x = 0;
		scrollRectangle3.x = 0;
		scrollRectangle4.x = 0;
		_Map.x = 0;
	}
	
	private function addMapToStage():Void
	{
		trace('Platformer.hx:135 "Debug Map Loaded"');
		_Map = VkTkMap.loadMap(RMap.testMapVar);
		layer5.addChild(_Map);
		initEventListeners();
	}
	
}