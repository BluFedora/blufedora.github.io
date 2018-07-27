package libBlu.display;

import libBlu.render.TileRenderer;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */

@:allow(libBlu.render.TileRenderer)
class Tile extends GameObject
{
  private var _terrainLayer:TileRenderer;
  private var scale:Float = 2;
  private var index:Int;
  private var _type:Int;

  public function new(x:Float, y:Float, tileType:Int = 0, terrainLayer:TileRenderer, id:Int, name:String = "Tile") 
  {
    super(x, y, terrainLayer.tileWidth * scale, terrainLayer.tileHeight * scale);
    this._terrainLayer = terrainLayer;
    this.name = name + tileType;
    this._type = tileType;
    this.id = id;
    
    index = id * 6;
  }
  
  override public function update():Void 
  {
    super.update();
    
    updateFrame();
    TileRenderer.renderArray[index + 0] = x;     //X
    TileRenderer.renderArray[index + 1] = y;     //Y
    TileRenderer.renderArray[index + 3] = scale; //Scale
    TileRenderer.renderArray[index + 4] = 0;     //Rotation
    TileRenderer.renderArray[index + 5] = 1;     //Alpha
  }
  
  private function updateFrame():Void
  {
    TileRenderer.renderArray[index + 2] = _type; //Type
  }
}

typedef TileProps = 
{
  var alpha:Float;
  var scale:Int;
  var rot:Float;
  var type:Int;
  var x:Int;
  var y:Int;
}