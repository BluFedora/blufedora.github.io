package libBlu._v2.deprecated ;

import openfl.utils.ByteArray;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */

@:file("assets/platformer/mapData/Cave_Boss.vktk") class CaveMap extends ByteArray { }
@:file("assets/platformer/mapData/New.vktk") class TestMap extends ByteArray { }
 
class RMap
{
  public static var testMapVar:ByteArray = new TestMap();
  public static var CAVE_MAP:ByteArray = new CaveMap();
}