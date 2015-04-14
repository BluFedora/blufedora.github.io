package libBlu.geom;

import libBlu.collision.Coll2D;
import libBlu.collision.Data;
import libBlu.collision.Solid;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Polygon extends Solid
{

	/** The transformed (rotated/scale) vertices cache */
    public var transformedVertices ( get, never ) : Array<Vec>;
	/** The vertices of this shape */
    public var vertices ( get, never ) : Array<Vec>;

    var _transformedVertices : Array<Vec>;
    var _vertices : Array<Vec>;
	
	/** Create a new polygon with a given set of vertices at position x,y. */
    public function new( x:Float, y:Float, vertices:Array<Vec> ) {

        super( x,y );
        
        name = vertices.length + 'polygon';
		
        _transformedVertices = new Array<Vec>();
        _vertices = vertices;
    
    } //new
	
	override public function test(shape:Solid):Data 
	{
		return shape.testPolygon(this, true);
	}
	
	override public function testCircle(circle:Circle, flip:Bool = false):Data 
	{
		return Coll2D.testCircleVsPolygon( circle, this, flip );
	}
	
	override public function testPolygon(polygon:Polygon, flip:Bool = false):Data 
	{
		return Coll2D.testPolygons( this, polygon, flip );
	}
	
	override public function testRay(ray:Ray):RayData 
	{
		return Coll2D.rayPolygon(ray, this);
	}
        
        /** Destroy this polygon and clean up. */
    override public function destroy() : Void {

        var _count : Int = _vertices.length;
        for(i in 0 ... _count) {
            _vertices[i] = null;
        }
		
        _transformedVertices = null;
        _vertices = null;
        super.destroy();

    } //destroy    

//.transformedVertices

    function get_transformedVertices() : Array<Vec> {

        if(!_transformed) {
            _transformedVertices = new Array<Vec>();
            _transformed = true;

            var _count : Int = _vertices.length;

            for(i in 0..._count) {
                _transformedVertices.push( _vertices[i].clone().transform( _transformMatrix ) );
            }
        }

        return _transformedVertices;
    }

//.vertices 

    function get_vertices() : Array<Vec> {
        return _vertices;
    }	
}