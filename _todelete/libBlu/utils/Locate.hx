package libBlu.utils ;

import libBlu._v2.deprecated.LPoint;
import openfl.display.Shape;
import openfl.display.Sprite;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Locate
{
	public static inline var BOTTOM_RIGHT:String = "bottom right";
	public static inline var BOTTOM_LEFT:String  = "bottom left";
	public static inline var BOTTOM_MID:String   = "bottom mid";
	
	public static inline var MID_RIGHT:String = "right mid";
	public static inline var MID_LEFT:String  = "left mid";
	public static inline var CENTER:String    = "center";
	
	public static inline var TOP_RIGHT:String = "top right";
	public static inline var TOP_LEFT:String  = "top left";
	public static inline var TOP_MID:String   = "top mid";
	
	#if neko
	public static inline function pointLoc(object:Sprite, location:String = TOP_LEFT, ?bBox:Shape):LPoint
	#elseif cpp
	public static inline function pointLoc(object:Dynamic, location:String = TOP_LEFT, ?bBox:Dynamic):LPoint
	#end
	{
		var returnValue:LPoint = new LPoint(0, 0);
		
		if (bBox == null)
		{
			switch(location)
			{
				case TOP_LEFT:
					returnValue.x = object.x;
					returnValue.y = object.y;
				case TOP_RIGHT:
					returnValue.x = object.x + object.width;
					returnValue.y = object.y;
				case BOTTOM_LEFT:
					returnValue.x = object.x;
					returnValue.y = object.y + object.height;
				case BOTTOM_RIGHT:
					returnValue.x = object.x + object.width;
					returnValue.y = object.y + object.height;
				case TOP_MID:
					returnValue.x = object.x + object.width / 2;
					returnValue.y = object.y;
				case BOTTOM_MID:
					returnValue.x = object.x + object.width / 2;
					returnValue.y = object.y + object.height;
				case MID_LEFT:
					returnValue.x = object.x;
					returnValue.y = object.y + object.height / 2;
				case MID_RIGHT:
					returnValue.x = object.x + object.width;
					returnValue.y = object.y + object.height / 2;
				case CENTER:
					returnValue.x = object.x + object.width / 2;
					returnValue.y = object.y + object.height / 2;
			}
		}
		else if (bBox != null)
		{
			if (location == TOP_LEFT)
			{
				returnValue.x = object.x + bBox.x;
				returnValue.y = object.y + bBox.y;
			}
			else if (location == TOP_RIGHT)
			{
				returnValue.x = object.x + bBox.width + bBox.x;
				returnValue.y = object.y + bBox.y;
			}
			else if (location == BOTTOM_LEFT)
			{
				returnValue.x = object.x + bBox.x;
				returnValue.y = object.y + bBox.height + bBox.y;
			}
			else if (location == BOTTOM_RIGHT)
			{
				returnValue.x = object.x + bBox.width + bBox.x;
				returnValue.y = object.y + bBox.height + bBox.y;
			}
			else if (location == TOP_MID)
			{
				returnValue.x = object.x + bBox.width / 2 + bBox.x;
				returnValue.y = object.y + bBox.y;
			}
			else if (location == BOTTOM_MID)
			{
				returnValue.x = object.x + bBox.width / 2 + bBox.x;
				returnValue.y = object.y + bBox.height + bBox.y;
			}
			else if (location == MID_LEFT)
			{
				returnValue.x = object.x + bBox.x;
				returnValue.y = object.y + bBox.height / 2 + bBox.y;
			}
			else if (location == MID_RIGHT)
			{
				returnValue.x = object.x + bBox.width + bBox.x;
				returnValue.y = object.y + bBox.height / 2 + bBox.y;
			}
			else if (location == CENTER)
			{
				returnValue.x = object.x + bBox.width / 2 + bBox.x;
				returnValue.y = object.y + bBox.height / 2 + bBox.y;
			}
		}
		
		return returnValue;
	}
}