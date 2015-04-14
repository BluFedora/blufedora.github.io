package libBlu.geom;

import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Ray
{
	public var isInfinite:Bool;
	
	public var start:Vec;
	public var end:Vec;

	public function new(start:Vec, end:Vec, isInfinite:Bool = true) 
	{
		this.isInfinite = isInfinite;
		this.start = start;
		this.end = end;
	}
	
}