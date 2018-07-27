package libBlu._assetIO;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
//class TileObject{}

typedef TileObject = 
{
  @:optional var entity:Bool;
  @:optional var type:TileType;
  
  var collision:EnumValue;
  var tileType:Int;
  var tileID:Int;
  var depthZ:Int;
  var posX:Float;
  var posY:Float;
}

enum TileType
{
  ANIMATED_TILE;
  STATIC_TILE;
  ENTITY;
  WARP;
}