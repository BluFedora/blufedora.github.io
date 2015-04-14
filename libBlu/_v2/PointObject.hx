package libBlu._v2;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
#if TKE
	import openfl.display.Shape;
	
	class PointObject extends Shape
	{
#else
	class PointObject
	{
		public var x:Float = 0;
		public var y:Float = 0;
#end
	public function new(y:Float = 0, x:Float = 0) 
	{
		super();
		#if TKE
			graphics.beginFill(0x00369B, 1);
			graphics.lineStyle(2, 0x5994FF, 1);
			graphics.drawCircle(x, y, 2);
			graphics.endFill();
		#end
		this.x = x;
		this.y = y;
	}
	
	public function updateLocation(inPoint:Dynamic):Void 
	{
		x = inPoint.x;
		y = inPoint.y;
	}
	
}