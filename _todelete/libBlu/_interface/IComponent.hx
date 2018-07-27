package libBlu._interface;

import libBlu.component.Component;

/**
 * @author Shareef Raheem (Blufedora)
 */

interface IComponent 
{
  private var props:ComponentProps;
  private var _instance:Component;
  
  public function init(comp:Component);
  public function run();
}

typedef ComponentProps = 
{
  var name:String;
  var physicsEnabled:Bool;
  var collidable:Bool;
  
  var renderable:Bool;
  var textured:Bool;
  var texturePath:String;
  var animated:Bool;
  
  var type:EnumValue;
  
  var behavior:String;
  var dialogue:String;
  
  var scaleX:Float;
  var scaleY:Float;
  var width:Float;
  var height:Float;
  var x:Float;
  var y:Float;
}