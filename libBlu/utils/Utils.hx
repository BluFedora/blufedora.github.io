package libBlu.utils;

import libBlu._enum.Target;
import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Utils
{
    public static function findNormalAxis(vertices:Array<Vec>, index:Int):Vec
	{
        var vector1:Vec = vertices[index];
        var vector2:Vec = (index >= vertices.length - 1) ? vertices[0] : vertices[index + 1]; //make sure you get a real vertex, not one that is outside the length of the vector.
        var normalAxis:Vec = new Vec(-(vector2.y - vector1.y), vector2.x - vector1.x);        //take the two vertices, make a line out of them, and find the normal of the line
		normalAxis.normalize();                                                               //normalize the line(set its length to 1)
		
		return normalAxis;
    }
	
	public static function getTarget():Target
    {
        #if flash
            return FLASH;
        #elseif flash8
           return FLASH8;
        #elseif cpp
            return CPP;
        #elseif php
            return PHP;
        #elseif neko
            return NEKO;
        #elseif js
            return JS;
        #elseif java
            return JAVA;
        #elseif cs
            return CS;
        #end
    }
	
	//0 - 530 means that the width of the progressBar will change from 0 to 530 when the percent will take values from 0 to 100.
	//progressBar.width = lineEquation (0, 530, percent, 0, 100);
	
	
		// Initial function modified by the suggestions of Franco Ponticelli
	public static inline function lineEquation(x1 : Float, x2 : Float, y0 : Float, y1 : Float, y2 : Float) {
			return (x2 - x1) * (y0 - y1) / (y2 - y1) + x1;
	}
	public static inline function lineEquationInt(x1 : Float, x2 : Float, y0 : Float, y1 : Float, y2 : Float) {
			return Math.round(lineEquation(x1, x2, y0, y1, y2));
	}
	
	public static function sortArray(arr:Array<Dynamic>)
	{
		var len = arr.length;
		
		for (index in 0...len)
		{
			var minIndex = index;
			
			for (remainingIndex in (index + 1)...len)
			{
				if (arr[minIndex] > arr[remainingIndex])
				{
					minIndex = remainingIndex;
				}
				
				if (index != minIndex)
				{
					var temp = arr[index];
					arr[index] = arr[minIndex];
					arr[minIndex] = temp;
				}
			}
		}
	}
	
	public static function deepCopy<T>( v:T ) : T  
	{ 
		if (!Reflect.isObject(v)) { // simple type 
			return v; 
		}
		else if (Std.is(v, String)) { // string
			return v;
		}
		else if(Std.is( v, Array )) { // array 
			var result = Type.createInstance(Type.getClass(v), []); 
			untyped { 
				for( ii in 0...v.length ) {
					result.push(deepCopy(v[ii]));
				}
			} 
			return result;
		}
		else if(Std.is( v, List )) { // list
			//List would be copied just fine without this special case, but I want to avoid going recursive
			var result = Type.createInstance(Type.getClass(v), []);
			untyped {
				var iter : Iterator<Dynamic> = v.iterator();
				for( ii in iter ) {
					result.add(ii);
				}
			} 
			return result; 
		}
		else if(Type.getClass(v) == null) { // anonymous object 
			var obj : Dynamic = {}; 
			for( ff in Reflect.fields(v) ) { 
				Reflect.setField(obj, ff, deepCopy(Reflect.field(v, ff))); 
			}
			return obj; 
		} 
		else { // class 
			var obj = Type.createEmptyInstance(Type.getClass(v)); 
			for(ff in Reflect.fields(v)) {
				Reflect.setField(obj, ff, deepCopy(Reflect.field(v, ff))); 
			}
			return obj; 
		} 
		return null; 
	}
}