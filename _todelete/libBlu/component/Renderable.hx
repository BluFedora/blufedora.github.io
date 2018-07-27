package libBlu.component;

import libBlu._interface.IComponent;
import libBlu.component.Component;
import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Renderable implements IComponent
{
  /* INTERFACE libBlu._interface.IComponent */
  private var props:ComponentProps;
  private var _instance:Component;
  
  private var rotation:Float;
  private var alpha:Float;
  private var scale:Vec;
  private var size:Vec;
  
  public var x:Float = 0;
  public var y:Float = 0;

  public function new(width:Int, height:Int, alpha:Float = 1, rotation:Float = 0) 
  {
    this.size = new Vec(width, height);
    this.rotation = rotation;
    this.alpha = alpha;
  }
  
  /* INTERFACE libBlu._interface.IComponent */
  
  public function init(comp:Component) 
  {
    _instance = comp;
    _instance.property.rotation = rotation;
    _instance.property.alpha = alpha;
    _instance.property.scaleX = scale.x;
    _instance.property.scaleY = scale.y;
    _instance.property.width = size.x;
    _instance.property.height = size.y;
    _instance.property.x = x;
    _instance.property.y = y;
  }
  
  public function run() 
  {
    
  }
  
}