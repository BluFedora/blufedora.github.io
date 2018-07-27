package libBlu._interface;

/**
 * @author Shareef Raheem (Blufedora)
 */

interface IObject 
{
  public var width:Float;
  public var height:Float;
  public var x:Float;
  public var y:Float;
  
  public function setLoc(x:Float, y:Float):Void;
  public function update():Void;
  public function destroy():Void;
}