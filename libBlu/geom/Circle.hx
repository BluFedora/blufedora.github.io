package libBlu.geom;

import libBlu.collision.Coll2D;
import libBlu.collision.Data;
import libBlu.collision.Solid;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Circle extends Solid
{
    /** The radius of this circle. Set on construction */
    public var radius( get_radius, never ) : Float;
        /** The transformed radius of this circle, based on the scale/rotation */
    public var transformedRadius( get_transformedRadius, never ) : Float;
    
    var _radius:Float;
    
    public function new(x:Float, y:Float, radius:Float) {

        super( x, y );
        _radius = radius;
        name = 'circle ' + _radius;

    } //new
	
	override public function test(shape:Solid):Data
	{
		return shape.testCircle(this, true);
	}
	
	override public function testCircle(circle:Circle, flip:Bool = false):Data
	{
		var c1 = flip ? circle : this;
		var c2 = flip ? this : circle;
		return Coll2D.testCircles( c1, c2 );
	}
	
	override public function testPolygon(polygon:Polygon, flip:Bool = false):Data
	{
		return Coll2D.testCircleVsPolygon( this, polygon, flip );
	}
	
	override public function testRay(ray:Ray):RayData 
	{
		return Coll2D.rayCircle(ray, this);
	}

//Internal API

    function get_radius():Float {
        
        return _radius;

    } //get_radius
    
    function get_transformedRadius():Float {
        
        return _radius * scaleX;

    } //get_transformedRadius
	
}