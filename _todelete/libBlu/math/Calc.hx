package libBlu.math;

import libBlu.App;
import openfl.Lib;

/**
 * Class For Extended or Faster Math Operations
 * @author Shareef Raheem (Blufedora)
 */
class Calc
{	
	public static inline function abs(value:Float):Float
	{
		return value < 0 ? -value : value;
	}
	
	public static inline function absInt(value:Int):Int
	{
		return (value ^ (value >> 31)) - (value >> 31);
	}
	
	/*
	 * Returns the angle between two points in radians or degrees
	*/
	public static function angle(x1:Float, y1:Float, x2:Float, y2:Float, ?inDegrees:Bool):Float
	{
		switch(inDegrees)
		{
			case true: return toDegree(Math.atan2(y2 - y1, x2 - x1));
			default:   return Math.atan2(y2 - y1, x2 - x1);
		}
	}
	
	/**
	 * Returns the distance between two points
	 * [Pythagorean's Theorm]
	 */
	public static function distSqrt(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		return abs(x1 - x2) * abs(x1 - x2) + abs(y1 - y2) * abs(y1 - y2);
	}
	
	/**
	 * Returns the distance between two points
	 * [Pythagorean's Theorm]
	 */
	public static function dist(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		return Math.sqrt((abs(x1 - x2) * abs(x1 - x2)) + (abs(y1 - y2) * abs(y1 - y2)));
	}
	
	public static function mid(x1:Float, x2:Float):Float
	{
		return ((x1 + x2) / 2);
	}
	
	/**
	 * Converts Frames Per Second to MilliSeconds
	 */
	public static function fpsToMs(fps:Int):Float
	{
		return 1000 / fps;
	}
	
	/**
	 * Returns a Boolean of the value in inbetween min and max
	 */
	public static function inRange(value:Float, min:Float, max:Float):Bool
	{	
		return (min <= value && value <= max);
	}
	
	public static function randomRange(min:Float, max:Float):Float
	{
		return (min + Math.random() * (max - min));
	}
	
	public static function randomRangeInt(min:Float, max:Float):Int
	{
		return Std.int(Math.random() * (1 + max - min) + min);
	}
	
	/**
	 * Returns a random Boolean Value based on the value you put i
	 */
	public static function randomBoolean(chance:Float):Bool
	{
		return Math.random() > chance;
	}
	
	/**
	 * Returns the value times its self
	 */
	public static function sqr(value:Float):Float
	{
		return value * value;
	}
	
	/**
	 * Converts Degrees to Radians
	 */
	public static function toRadians(degree:Float):Float
	{
		return degree * 0.0174532925;
	}
	
	/**
	 * Converts Radians to Degrees
	 */
	public static function toDegree(radian:Float):Float
	{
		return radian * 57.2957795131;
	}
	
	public static function glSize(x:Float = 0, y:Float = 0, z:Float = 0):Array<Float>
	{
		#if mobile
			var nX = ((2 / 960)  * x);
			var nY = ((2 / 540) * y);
		#else
			var nX = ((2 / App.windowWidth())  * x);
			var nY = ((2 / App.windowHeight()) * y);
		#end
		
		return [nX, nY, z];
	}
	
	public static function glCoords(x:Float = 0, y:Float = 0, z:Float = 0):Array<Float>
	{
		var nX = ((2 / 960) * x);
		var nY = ((2 / 540) * y);
		
		return [nX, -nY, z];
	}
	
	public static function hexToRGB(color:Int = 0xFFFFFF):Array<Float>
	{
		var rgb:Array<Float> = [];
		rgb[0] = ((color >> 16) & 255) / 255;
		rgb[1] = ((color >> 8) & 255) / 255;
		rgb[2] = (color & 255) / 255;
		
		return rgb;
	}
	
	//TODO
	 /*public static function rgb2hex(r : uint, g : uint, b : uint, a : uint = 255) : uint
        {
            return (a << 24) | (r << 16) | (g << 8) | b;
        }*/
	
}