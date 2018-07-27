package libBlu.render;

import libBlu.geom.Polygon;
import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class ShapeGen
{ 
    public static function create(x:Float, y:Float, sides:Int, radius:Float = 100):Polygon 
  {
        if (sides < 3) throw 'Polygon - Needs at least 3 sides';
    
        var rotation:Float = (Math.PI * 2) / sides;
    var vertices:Array<Vec> = [];
        var angle:Float;
        var vector:Vec;
    
    var pi = Math.PI;
    var cos = Math.cos;
    var sin = Math.sin;
    
        for (i in 0...sides) 
    {
            angle = (i * rotation) + ((pi - rotation) * 0.5);
      vector = new Vec(
        cos(angle) * radius, 
        sin(angle) * radius
      );
            vertices.push(vector);
        }
        
        return new Polygon(x, y, vertices);
    }

    public static function rectangle(x:Float, y:Float, width:Float, height:Float, centered:Bool = true):Polygon 
  {
        var vertices:Array<Vec> = [];
    
        if (centered) 
    {
            vertices.push(new Vec( -width / 2, -height / 2));
            vertices.push(new Vec(  width / 2, -height / 2));
            vertices.push(new Vec(  width / 2,  height / 2));
            vertices.push(new Vec( -width / 2,  height / 2));
        } 
    else
    {
            vertices.push( new Vec( 0, 0 ) );
            vertices.push( new Vec( width, 0 ) );
            vertices.push( new Vec( width, height) );
            vertices.push( new Vec( 0, height) );
        }
    
        return new Polygon(x,y,vertices);
    }
    
    public static function square(x:Float, y:Float, width:Float, centered:Bool = true):Polygon 
  {
        return rectangle(x, y, width, width, centered);
    }

    public static function triangle(x:Float, y:Float, radius:Float):Polygon 
  {
        return create(x, y, 3, radius);
    }
  
}