package libBlu.collision;

import libBlu.collision.Coll2D;
import libBlu.collision.Data;
import libBlu.display.GameObject;
import libBlu.geom.Polygon;
import libBlu.geom.Ray;
import libBlu.geom.Vec;
import libBlu.math.Calc;

/**
 * Collision Detection Methods
 * @author Shareef Raheem (Blufedora)
 */
class Collision
{
	@:noCompletion public function new() 
		throw "Collision => Static Class Bro :)";
	
	public static inline function AABB(obj1:GameObject, obj2:GameObject):Bool
	{
		if (obj1.bottom < obj2.y || obj1.y > obj2.bottom || obj1.x > obj2.right || obj1.right < obj2.x) return false;
		return true;
	}
	
	public static inline function CircleCircle(obj1:GameObject, obj2:GameObject):Bool
	{
		var d = ((obj1.width + obj1.height) / 2) + ((obj2.width + obj2.height) / 2);
		return Calc.distSqrt(obj1.mid.x, obj1.mid.y, obj2.mid.x, obj2.mid.y) < d * d; //Optimized
		//return Calc.dist(obj1.mid.x, obj1.mid.y, obj2.mid.x, obj2.mid.y) < ((obj1.width + obj1.height) / 2) + ((obj2.width + obj2.height) / 2);
	}
	
	public static inline function CircleVec(c:GameObject, vec:Vec):Bool
	{
		var cX:Float = c.x + (c.width / 2);
		var cY:Float = c.y + (c.width / 2);
		
		return Calc.dist(vec.x, vec.y, cX, cY) < (c.width / 2) * (c.width / 2);
	}
	
	public static inline function LineSegment(a:Vec, b:Vec, c:Vec, d:Vec):Bool
	{
		// Point Vectors
		var ab:Vec = new Vec(b.x - a.x, b.y - a.y);
		var ad:Vec = new Vec(d.x - a.x, d.y - a.y);
		var ac:Vec = new Vec(c.x - a.x, c.y - a.y);
		
		if ((ab.x * ad.y - ab.y * ad.x) * (ab.x * ac.y - ab.y * ac.x) < 0) return true;
		return false;
	}
	
	public static inline function SegmentSegment(a:Vec, b:Vec, c:Vec, d:Vec):Bool
	{
		// Treats both segments as lines
		if (!LineSegment(a, b, c, d) || !LineSegment(c, d, a, b)) return false;
		return true;
	}
	
	public static inline function PointOfImpactSS(a:Vec, b:Vec, c:Vec, d:Vec):Vec
	{
		// Point Vectors
		var ab:Vec = new Vec(b.x - a.x, b.y - a.y);
		var ad:Vec = new Vec(d.x - c.x, d.y - c.y);
		var ac:Vec = new Vec(c.x - a.x, c.y - a.y);
		
		var t:Float = (ac.x * ad.y - ac.y * ad.x) / (ab.x * ad.y - ab.y * ad.x);
		
		return new Vec(a.x + ab.x * t, a.y + ab.y * t);
	}
	
	public static inline function vecInPolygon(pt:Vec, pos:Vec, verts:Array<Vec>):Bool 
	{
		var c:Bool = false;
		var nvert:Int = verts.length;
		var j:Int = nvert - 1;
		
		for (i in 0...nvert) 
		{            
			if ((( (verts[i].y + pos.y) > pt.y) != ((verts[j].y + pos.y) > pt.y)) &&
			   (pt.x < ( (verts[j].x + pos.x) - (verts[i].x + pos.x)) * (pt.y - (verts[i].y + pos.y)) / ( (verts[j].y + pos.y) - (verts[i].y + pos.y)) + (verts[i].x + pos.x)) ) 
			{
				c = !c;
			}
			
			j = i;
		}
		
		return c;
	}
	
	public static inline function hitTestVec(object:GameObject, vec:Vec):Bool
	{
		return (Calc.inRange(vec.x, object.x, object.right) && Calc.inRange(vec.y, object.y, object.bottom));
	}
	
	public static function test( shape1:Solid, shape2:Solid ):Data
	{
		return shape1.test(shape2);
    } //test
   
        /** Test a single shape against multiple other shapes. 
            Will never return null, always length 0 array. 
            Returns a list of `CollisionData` information for each collision found.
        */
    public static function testShapes( shape1:Solid, shapes:Array<Solid> ) : Array<Data> {
        
        var results : Array<Data> = [];

        for (other_shape in shapes)
		{
            var result = test(shape1, other_shape);
            if(result != null) results.push(result);
        } //for all shapes passed in

        return results;

    } //testShapes

	/** Test a line between two points against a list of shapes. 
		If a collision is found, returns true, otherwise false.
	*/
    public static function rayShape( ray:Ray, shape:Solid ) : RayData
	{
		return shape.testRay(ray);
    } //ray

	/** Test a line between two points against a list of shapes. 
		If a collision is found, returns true, otherwise false.
	*/
    public static function rayShapes( ray:Ray, shapes:Array<Solid> ) : Array<RayData>
	{
		var results = new Array<RayData>();
		
		//check against each shape
        for (shape in shapes)
		{
			var r = shape.testRay(ray);
			if (r != null) results.push(r);
		}
		
        return results;
    } //ray
	
	public static function rayRay( ray1:Ray, ray2:Ray ):RayIntersection
	{
		return Coll2D.rayRay(ray1, ray2);
	}
	
	public static function rayRays( ray:Ray, rays:Array<Ray> ):Array<RayIntersection>
	{
		var results = new Array<RayIntersection>();
		
		for (ray2 in rays)
		{
			var r = Coll2D.rayRay(ray, ray2);
			if (r != null) results.push(r);
		}
		
		return results;
	}

        /** Test if a given point lands inside the given polygon */
    public static function pointInPoly(point:Vec, poly:Polygon):Bool {

        var sides:Int = poly.transformedVertices.length; //amount of sides the polygon has
        var i:Int = 0;
        var j:Int = sides - 1;
            //how many sides have we passed through?
        var oddNodes:Bool = false;

        for(i in 0 ... sides) {

            if( (poly.transformedVertices[i].y < point.y && poly.transformedVertices[j].y >= point.y) || 
                (poly.transformedVertices[j].y < point.y && poly.transformedVertices[i].y >= point.y)) 
            {
                if( poly.transformedVertices[i].x + 
                    (point.y - poly.transformedVertices[i].y) / 
                    (poly.transformedVertices[j].y - poly.transformedVertices[i].y) * 
                    (poly.transformedVertices[j].x - poly.transformedVertices[i].x) < point.x) 
                {
                    oddNodes = !oddNodes;
                } //second if

            } //first if

            j = i;

        } //for each side

        return oddNodes; 

    } //pointInPoly     
	
}