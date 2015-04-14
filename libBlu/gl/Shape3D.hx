package libBlu.gl;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Shape3D
{
	public static var QUAD:Array<Float> = 
	[
	   -1.0,  1.0,  0.0, // Top    Left
	    1.0,  1.0,  0.0, // Top    Right
	   -1.0, -1.0,  0.0, // Bottom Left
		1.0, -1.0,  0.0  // Bottom Right
	];
	
	public static var TRIANGLE:Array<Float> = 
	[
	    0.0,  1.0,  0.0, // Top
	   -1.0, -1.0,  0.0, // Bottom Left
		1.0, -1.0,  0.0  // Bottom Right
	];
}