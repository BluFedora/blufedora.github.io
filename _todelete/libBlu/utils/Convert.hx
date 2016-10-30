package libBlu.utils;

import libBlu.geom.Vec;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;


/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Convert
{
	public static inline function spriteToBitmap(sprite:Sprite, opaque:Bool = true, backgroundColor:UInt = 0x00000000, deleteSprite:Bool = true):Bitmap
	{
		var bmd:BitmapData = new BitmapData(Std.int(sprite.width), Std.int(sprite.height), opaque, backgroundColor);
		bmd.draw(sprite);
		
		if (deleteSprite)
		{
			sprite.removeChildren();
			sprite.parent.removeChild(sprite);
		}
		
		return new Bitmap(bmd);
	}
	
	public static inline function bitmapToSprite(bitmap:Bitmap):Sprite
	{
		var sprite:Sprite = new Sprite();
		sprite.graphics.beginBitmapFill(bitmap.bitmapData);
		sprite.graphics.drawRect(0, 0, bitmap.width, bitmap.height);
		sprite.graphics.endFill();
		
		return sprite;
	}
	
	public static inline function vecToPoint(vec:Vec):Point
	{
		return new Point(vec.x, vec.y);
	}
	
	public static inline function pointToVec(point:Point):Vec
	{
		return new Vec(point.x, point.y);
	}
	
}