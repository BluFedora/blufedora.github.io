package libBlu.gl;
import libBlu.App;
import openfl.geom.Matrix3D;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Projection
{
	public static function perspective(fovy:Float, aspect:Float, near:Float, far:Float):Matrix3D 
	{
		var top = near * Math.tan((fovy * .5) * Math.PI / 180);
		var bottom = -top;
		
		var right = App.windowWidth() * (top - bottom) / 2 * App.windowHeight();
		var rl = App.windowWidth() * (top - bottom) / App.windowHeight();
		//var right = top*aspect;
		var left = -right;
		
		//var rl = (right - left);
		var tb = (top - bottom);
		var fn = (far - near);
		
		return new Matrix3D(
			[ 
				(near*2)/rl,      0,                 0,                 0,
				0,                (near*2)/tb,       0,                 0,
				(right+left)/rl,  (top+bottom)/tb,  -(far+near)/fn,    -1,
				0,                0,                -(far*near*2)/fn,   0
			]
		);
	}
	
	public static function ORTHOGRAPHIC(far:Float, near:Float):Matrix3D
	{
		//var r  = App.windowWidth() * App.windowHeight();
		var r = 1;
		//var r  = (App.windowWidth() * 2) / (App.windowHeight() * 2);
		//var rl = App.windowWidth() / App.windowHeight();
		var rl = 2;
		var l = -r;
		
		return new Matrix3D(
			[
				2 / rl, 0,   0, -((r + l) / (r - l)),
				0,      1,   0,                    0,
				0,      0,  -2 / (far - near),     (near / (far - near)) * -1,
				0,      0,   0,                    1
			]
		);
	}
	
}