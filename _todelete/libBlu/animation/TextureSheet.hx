package libBlu.animation;

import libBlu.geom.Vec;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class TextureSheet
{
  private var _texture:BitmapData;
  private var tileSize:Vec;
  private var _columns:Int;
  private var _rows:Int;

  public function new(bitmapdata:BitmapData, columns:Int = 0, rows:Int = 0, tileWidth:Float, tileHeight:Float) 
  {
    tileSize = new Vec(tileWidth, tileHeight);
    this._texture = bitmapdata;
    this._columns = columns;
    this._rows = rows;
  }
  
  public function getFrame(id:Int):BitmapData
  {
    var ret:BitmapData = new BitmapData(18, 18);
    var idWidth = (id % _columns) * tileSize.x * 2;
    var idHeight = Std.int(id / _columns) * tileSize.y * 2;
    
    ret.copyPixels(_texture, 
    new Rectangle(
      idWidth,
      idHeight,
      18, 
      18), 
    new Point(0, 0));
    
    return ret;
  }
  
}