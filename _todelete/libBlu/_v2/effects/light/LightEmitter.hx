package libBlu._v2.effects.light;

import libBlu.effects.light.Polygon;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class LightEmitter
{
	public static inline var DIRECTIONAL:String = "directional";
	public static inline var SPOT_LIGHT:String = "spot_light";
	public static inline var AMBIENT:String = "ambient";
	
	private var polygons:Array<Polygon>;
	private var vertices:Array<Float>;
	
	private var directedAngle:Float;
	private var viewAngle:Float;
	
	private var lightType:String;
	private var intensity:Float;
	private var radius:Float;
	private var color:UInt;

	public function new(type:String, range:Float, hue:UInt = 0xFFFFFF, brightness:Float, ?angle:Float) 
	{
		intensity = brightness;
		lightType = type;
		radius = range;
		vertices = [];
		color = hue;
		
		if (angle != null) 
		{
			switch(lightType)
			{
				case DIRECTIONAL:directedAngle = angle;
				case SPOT_LIGHT:     viewAngle = angle;
				case AMBIENT:        viewAngle =   360;
			}
		}
	}
	
	public function addShape():Void
	{
		
	}
	
	public function render():Void
	{
		
	}
	
}