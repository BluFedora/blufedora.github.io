package libBlu.collision;

import libBlu.collision.Data;
import libBlu.geom.Circle;
import libBlu.geom.Polygon;
import libBlu.geom.Ray;
import libBlu.geom.Vec;
import libBlu.math.Matrix;
/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Solid
{
  public var active:Bool = true;
    public var name:String = 'shape';
  
    public var tags:Map<String, String>;
  public var data:Dynamic;
  
  public var rotation(get, set):Float;
    public var position(get, set):Vec;
  
  public var scaleX(get, set):Float;
    public var scaleY(get, set):Float;
  
    public var x(get, set):Float;
    public var y(get, set):Float;
  
  private var _position:Vec;
  private var _rotation:Float = 0;
  private var _rotation_radians:Float = 0;
  private var _scale:Vec;

  private var _scaleX:Float = 1;
  private var _scaleY:Float = 1;

  private var _transformed:Bool = false;
  private var _transformMatrix:Matrix;

  public function new( _x:Float, _y:Float )
  {
        tags = new Map();

        _position = new Vec(_x,_y);
        _scale = new Vec(1,1);
        _rotation = 0;

        _scaleX = 1;
        _scaleY = 1;

        _transformMatrix = new Matrix();
        _transformMatrix.makeTranslation( _position.x, _position.y );
    } //new

  public function test(shape:Solid):Data
  {
    return null;
  }

  public function testCircle( circle:Circle, flip:Bool = false ):Data
  {
    return null;
  }

  public function testPolygon( polygon:Polygon, flip:Bool = false ):Data
  {
    return null;
  }

  public function testRay( ray:Ray ):RayData
  {
    return null;
  }

  /** clean up and destroy this shape */
  public function destroy():Void {
        _position = null;
        _scale = null;
        _transformMatrix = null;
    } //destroy

//Getters/Setters

    function refresh_transform() {

        _transformMatrix.compose( _position, _rotation_radians, _scale );
        _transformed = false;

    }

//.position

    function get_position() : Vec {
        return _position;
    }

    function set_position( v : Vec ) : Vec {
        _position = v;
        refresh_transform();
        return _position;
    }

//.x

    function get_x() : Float {
        return _position.x;
    }

    function set_x(x : Float) : Float {
        _position.x = x;
        refresh_transform();
        return _position.x;
    }

//.y

    function get_y() : Float {
        return _position.y;
    }

    function set_y(y : Float) : Float {
        _position.y = y;
        refresh_transform();
        return _position.y;
    }

//.rotation

    function get_rotation() : Float {
        return _rotation;
    }

    function set_rotation( v : Float ) : Float {

        _rotation_radians = v * (Math.PI / 180);

        refresh_transform();

        return _rotation = v;

    } //set_rotation

//.scaleX

    function get_scaleX():Float {
        return _scaleX;
    }

    function set_scaleX( scale : Float ) : Float {
        _scaleX = scale;
        _scale.x = _scaleX;
        refresh_transform();
        return _scaleX;
    }

//.scaleY

    function get_scaleY():Float {
        return _scaleY;
    }

    function set_scaleY(scale:Float) : Float {
        _scaleY = scale;
        _scale.y = _scaleY;
        refresh_transform();
        return _scaleY;
    }
  
}