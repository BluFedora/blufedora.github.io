package libBlu.render;

import libBlu.collision.Solid;
import libBlu.geom.Circle;
import libBlu.geom.Polygon;
import libBlu.geom.Vec;

class ShapeDrawer {

    public function new() { }
	
    public function drawLine( p0:Vec, p1:Vec, ?startPoint:Bool = true ) { }

    public function drawShape(shape:Solid) 
	{
        if (Std.is(shape, Polygon)) 
		{
            drawPolygon(cast(shape, Polygon));
            return;
        } 
		else 
		{ 
            drawCircle(cast(shape, Circle));
            return;
        }
    }
	
    public function drawPolygon( poly:Polygon ) 
	{
        var v:Array<Vec> = poly.transformedVertices.copy();    
        drawVertList(v);
    }
	
    public function drawVector( v:Vec, start:Vec, ?startPoint:Bool = true )
	{ 
        drawLine( start, v );
    } 

	//Based On : http://slabode.exofire.net/circle_draw.shtml (OpenGL Tutorial)
    public function drawCircle( circle:Circle ) 
	{
        var _smooth:Float = 10;
        var _steps:Int = Std.int(_smooth * Math.sqrt( circle.transformedRadius ));
		
		//Precompute the value based on segments
        var theta = 2 * 3.1415926 / _steps;
        var tangential_factor = Math.tan(theta);
        var radial_factor = Math.cos(theta);
        
        var x : Float = circle.transformedRadius; 
        var y : Float = 0; 
        
        var _verts:Array<Vec> = [];
		
        for (i in 0..._steps) 
		{	
            var __x = x + circle.x;
            var __y = y + circle.y;
			
            _verts.push(new Vec(__x,__y));
            
			var tx = -y; 
			var ty = x; 
			
			x += tx * tangential_factor; 
			y += ty * tangential_factor; 
			
			x *= radial_factor;
			y *= radial_factor;
        }
		
        drawVertList( _verts );
    } 


//Internal API

	private function drawVertList(_verts:Array<Vec>) 
	{
        var _count:Int = _verts.length;
		
        if (_count < 3) throw "cannot draw polygon with < 3 verts as this is a line or a point.";
		
        drawLine(_verts[0], _verts[1], true);
		
        for (i in 1..._count - 1) drawLine( _verts[i], _verts[i+1], false);
		
        drawLine( _verts[_count], _verts[0], false );
    } 
	
}
