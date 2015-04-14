package libBlu.transform;

import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Point;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Transform
{

	public static inline function rotateAroundCenter(m:DisplayObject, rx:Float, ry:Float, P:Float):Void
	{	
		var toDeg:Float = 180 / Math.PI;
		
		var cos:Float = Math.cos(P);
		var sin:Float = Math.sin(P);
		var dx:Float = m.x-rx;
		var dy:Float = m.y-ry;
		
		m.rotation += P*toDeg;
		m.x = rx+dx*cos-dy*sin;
		m.y = ry+dy*cos+dx*sin;
	}
	
	public static inline function scaleAroundPoint(object:DisplayObject, offsetX:Float, offsetY:Float, absScaleX:Float, absScaleY:Float):Void
	{
		var relScaleX:Float = absScaleX / object.scaleX; 
		var relScaleY:Float = absScaleY / object.scaleY; 
		
		var AC:Point = new Point(offsetX, offsetY); 
		AC = object.localToGlobal( AC ); 
		AC = object.parent.globalToLocal(AC); 
		var AB:Point = new Point(object.x, object.y); 
		var CB:Point = AB.subtract( AC ); 
		CB.x *= relScaleX; 
		CB.y *= relScaleY;	
		AB = AC.add( CB ); 
		
		object.scaleX *= relScaleX; 
		object.scaleY *= relScaleY; 
		object.x = AB.x; 		
		object.y = AB.y; 
	}
	
	public static inline function scaleAroundCenter(object:DisplayObject, sX:Float, sY:Float):Void
	{
		var prevW:Float = object.width;
		var prevH:Float = object.height;
		object.scaleX = sX;
		object.scaleY = sY;
		object.x += (prevW - object.width) / 2;
		object.y += (prevH - object.height) / 2;
	}
	
	public static inline function flipBitmapData(original:BitmapData, axis:String = "x"):BitmapData
	{
		var flipped:BitmapData = new BitmapData(original.width, original.height, true, 0);
		var matrix:Matrix;
		
		switch(axis)
		{
			case "x": 
				matrix = new Matrix( -1, 0, 0, 1, original.width, 0);
				flipped.draw(original, matrix);
			case "y": 
				matrix = new Matrix( 1, 0, 0, -1, 0, original.height);
				flipped.draw(original, matrix);
		}
		
		return flipped;
	}
	
}