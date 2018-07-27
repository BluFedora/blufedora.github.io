package libBlu.geom;

import libBlu.math.Calc;
import libBlu.math.Matrix;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * 2D Vector Class and Base for Rendering System
 * @author Shareef Raheem (Blufedora)
 */
class Vec
{
  public var lengthsq(get, null):Float;
  public var length(get, set):Float;
  
  public var x:Float;
  public var y:Float;

  public function new(x:Float = 0, y:Float = 0) 
  {
    setLoc(x, y);
  }
  
  public function setLoc(x:Float, y:Float):Void 
  {
    this.x = x;
    this.y = y;
  }
  
  public function localToGlobal(vec:Vec, root:Sprite):Vec
  {
    var p:Point = root.localToGlobal(new Point(vec.x, vec.y));
    return new Vec(p.x, p.y);
  }
  
  public function normalize():Vec 
  {    
        if (length == 0)
    {
            x = 1;
            return this;
        }
    
        var oldLen:Float = length;
    x /= oldLen;
    y /= oldLen;
    
        return this;
    }
  
  public function truncate(max:Float):Vec 
  {    
        length = Math.min(max, length);
        return this;
    } 
  
  public function setEqual(vec:Vec):Void 
  {
    setLoc(vec.x, vec.y);
  }
  
  public function clone():Vec 
  {
    return new Vec(x, y);
  }
  
  public function distance(vec:Vec):Float
  {
    return Calc.dist(x, y, vec.x, vec.y);
  }
  
  public function transform(matrix:Matrix):Vec 
  {
        var vec:Vec = clone();
    vec.x = x * matrix.a + y * matrix.c + matrix.tx;
    vec.y = x * matrix.b + y * matrix.d + matrix.ty;
        return vec;
    }
  
  public inline function invert():Vec 
  {
    x = -x;
    y = -y;
    return this;
  }
  
  public inline function dot(v:Vec):Float 
  {
    return x * v.x + y * v.y;
  }

  public inline function cross(v:Vec):Float 
  {
    return x * v.y - y * v.x;
  }

  public inline function add(v:Vec):Vec 
  {
    return new Vec(x + v.x, y + v.y);
  }

  public inline function sub(v:Vec):Vec 
  {
    return new Vec(x - v.x, y - v.y);
  }

  public inline function mult(s:Float):Vec  
  {
    return new Vec(x * s, y * s);
  }
  
  public function toString():String {
        return "Vec x:" + x + ", y:" + y;
    }
  
  private function get_lengthsq():Float 
  {
    return x * x + y * y;
  }
  
  private function get_length():Float 
  {
    return Math.sqrt(lengthsq);
  }
  
  private function set_length(value:Float):Float 
  {
    var _angle:Float = Math.atan2(y, x);
        
    x = Math.cos(_angle) * value;
    y = Math.sin(_angle) * value;
        
        if(Math.abs(x) < 0.00000001) x = 0;
        if(Math.abs(y) < 0.00000001) y = 0;
    
    return value;
  }
  
}