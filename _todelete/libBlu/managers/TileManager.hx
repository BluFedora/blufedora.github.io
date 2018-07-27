package libBlu.managers;

import libBlu._assetIO.TileObject;
import libBlu.display.Tile;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class TileManager
{
  public var tiles:Array<Tile>;
  public var names:Array<String>;

  public function new() 
  {
    tiles = [];
    names = [];
  }
  
  public function receiveTiles():Array<Tile>
  {
    return tiles;
    clear();
  }
  
  public function addTile(tile:Tile):Void
  {
    tiles.push(tile);
    names.push(tile.name);
  }
  
  public function clear():Void
  {
    tiles = [];
    names = [];
  }
  
}