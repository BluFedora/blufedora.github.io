package libBlu._assetIO.file;

import blufedora.editor.tiles.ComponentObject.ComponentProps;
import libBlu._assetIO.TileObject;

/**
 * @author Shareef Raheem (Blufedora)
 */
typedef Level =
{
  var name:String;
  var path:String;
  
  var comps:Array<ComponentProps>;
  var tiles:Array<TileObject>;
  
  var history:Array<Array<TileObject>>;
}