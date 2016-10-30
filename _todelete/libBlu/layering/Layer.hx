package libBlu.layering;

import libBlu.managers.LayersManager;
import openfl.display.Shape;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Layer
{
	public static var TILE(get, null):Shape = new Shape();
	
	private static inline function get_TILE():Shape 
	{
		return LayersManager.layerT;
	}
}