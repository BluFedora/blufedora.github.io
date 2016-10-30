package libBlu._v2 ;

import libBlu._v2.PointObject;
import libBlu.utils.Locate;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.Lib;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class EngineBase extends Sprite
{	
	//* Bounding Box Points *//
	private var bottomRightPoint:PointObject = new PointObject();
	private var bottomLeftPoint:PointObject = new PointObject();
	private var bottomMidPoint:PointObject = new PointObject();
	private var topRightPoint:PointObject = new PointObject();
	private var rightMidPoint:PointObject = new PointObject();
	private var leftMidPoint:PointObject = new PointObject();
	private var topLeftPoint:PointObject = new PointObject();
	private var topMidPoint:PointObject = new PointObject();
	
	//* Depth / Paralax Effect Layers *//
	private var layerH:Sprite = new Sprite();
	private var layer5:Sprite = new Sprite();
	private var layer4:Sprite = new Sprite();
	private var layer3:Sprite = new Sprite();
	private var layer2:Sprite = new Sprite();
	private var layer1:Sprite = new Sprite();
	private var layer0:Sprite = new Sprite();
	
	private var scaleFactor:Float = 1 / 36;
	private var ratio:Float = 36;

	public function new() 
	{
		super();
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function update(e:Event):Void 
	{
		#if !TKE
			scale(stage.stageHeight);
		#end
	}
	
	private function isTransparentPixel(bmd:BitmapData, xPos:Float, yPos:Float, xOffset:Float = 0, yOffset:Float = 0):Bool
	{
		return bmd.getPixel32(Std.int(xPos + xOffset), Std.int(yPos + yOffset)) == 0;
	}
	
	private function updatePoints(object:Dynamic, ?bBox:Dynamic = null):Void
	{
		#if cpp
			bottomRightPoint.updateLocation(Locate.pointLoc(object, Locate.BOTTOM_RIGHT, bBox));
			bottomLeftPoint.updateLocation( Locate.pointLoc(object, Locate.BOTTOM_LEFT,  bBox));
			bottomMidPoint.updateLocation(  Locate.pointLoc(object, Locate.BOTTOM_MID,   bBox));
			topRightPoint.updateLocation(   Locate.pointLoc(object, Locate.TOP_RIGHT,    bBox));
			rightMidPoint.updateLocation(   Locate.pointLoc(object, Locate.MID_RIGHT,    bBox));
			topLeftPoint.updateLocation(    Locate.pointLoc(object, Locate.TOP_LEFT,     bBox));
			leftMidPoint.updateLocation(    Locate.pointLoc(object, Locate.MID_LEFT,     bBox));
			topMidPoint.updateLocation(     Locate.pointLoc(object, Locate.TOP_MID,      bBox));
		#end
	}
	
	private function initPoints():Void
	{
		layerH.addChild(bottomRightPoint);
		layerH.addChild(bottomLeftPoint);
		layerH.addChild(bottomMidPoint);
		layerH.addChild(topRightPoint);
		layerH.addChild(rightMidPoint);
		layerH.addChild(leftMidPoint);
		layerH.addChild(topLeftPoint);
		layerH.addChild(topMidPoint);
	}
	
	private function initLayers():Void
	{
		addChild(layer0);
		addChild(layer1);
		addChild(layer2);
		addChild(layer3);
		addChild(layer4);
		addChild(layer5);
		addChild(layerH);
	}
	
	public function destroy():Void
	{	
		removeChild(layer0);
		removeChild(layer1);
		removeChild(layer2);
		removeChild(layer3);
		removeChild(layer4);
		removeChild(layer5);
		removeChild(layerH);
	}
	
	private function toggleFps():Void
	{
		if (Lib.current.stage.frameRate == 120)
			Lib.current.stage.frameRate = 60;
		else if (Lib.current.stage.frameRate == 60)
			Lib.current.stage.frameRate = 30;
		else if (Lib.current.stage.frameRate == 30)
			Lib.current.stage.frameRate = 15;
		else if (Lib.current.stage.frameRate == 15)
			Lib.current.stage.frameRate = 120;
		
		trace("Fps Is Set To: " + Lib.current.stage.frameRate);
	}
	
	private function rot(m:Sprite, rx:Float, ry:Float, P:Float):Void
	{	
		var toDeg:Float = 180 / Math.PI;
		
		var dx:Float = m.x-rx;
		var dy:Float = m.y-ry;
		var cos:Float = Math.cos(P);
		var sin:Float = Math.sin(P);
		
		m.rotation += P*toDeg;
		m.x = rx+dx*cos-dy*sin;
		m.y = ry+dy*cos+dx*sin;
	}
	
	private function scaleAround(offsetX:Float, offsetY:Float, absScaleX:Float, absScaleY:Float):Void
	{
		var relScaleX:Float = absScaleX / scaleX; 
		var relScaleY:Float = absScaleY / scaleY; 
		
		var AC:Point = new Point(offsetX, offsetY); 
		AC = localToGlobal( AC ); 
		AC = parent.globalToLocal(AC); 
		var AB:Point = new Point(x, y); 
		var CB:Point = AB.subtract( AC ); 
		CB.x *= relScaleX; 
		CB.y *= relScaleY;	
		AB = AC.add( CB ); 
		
		scaleX *= relScaleX; 
		scaleY *= relScaleY; 
		x = AB.x; 		
		y = AB.y;
		
		x = Math.round(x / 18) * 18;
	} 
	
	public function scale(h:Float):Void
	{	
		if (Math.round((h / ratio)) > 15)
		{
			scaleX += scaleFactor;
			scaleY += scaleFactor;
			ratio++;
		}
		else if ((Math.round(h / ratio)) < 15)
		{
			scaleX -= scaleFactor;
			scaleY -= scaleFactor;
			ratio--;
		}
		/*else if ((Math.round(stage.stageHeight / ratio)) == 15)
		{
			if (stage.stageWidth == 960 && stage.stageHeight == 540 || stage.stageWidth == 1920 && stage.stageHeight == 1080)
			{
				scaleX = Math.round(scaleX);
				scaleY = Math.round(scaleY);
			}
		}*/
	}
	
}