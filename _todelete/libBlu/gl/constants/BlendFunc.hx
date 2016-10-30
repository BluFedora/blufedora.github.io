package libBlu.gl.constants;

import openfl.gl.GL;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class BlendFunc
{
	public static inline var ALPHA_BLENDING:Int = GL.ONE_MINUS_SRC_COLOR;
	public static inline var COLOR_OVERLAY:Int  = GL.ONE_MINUS_DST_ALPHA;
	public static inline var NEGATIVE:Int       = GL.ONE_MINUS_DST_COLOR;
	public static inline var OVERLAY:Int        = GL.ONE_MINUS_CONSTANT_COLOR;
}