package libBlu.component;

import libBlu._interface.IComponent;
import libBlu.component.Renderable;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Component
{
  public var property:Dynamic = null;
  
  public var renderable:Bool = false;
  public var collidable:Bool = false;
  public var texturable:Bool = false;
  public var animated:Bool = false;
  public var physics:Bool = false;
  
  private var _comps:Array<IComponent> = [];
  private var numComps:Int = 0;
  
  public var id:Int = 0;

  public function new() 
  {
    
  }
  
  public function update():Void
  {
    for (comp in _comps) comp.run();
  }
  
  public function addComponent(comp:IComponent):Void
  {
    _comps.push(comp);
    reloadComps();
    numComps++;
  }
  
  private function reloadComps():Void
  {
    for (comp in _comps) 
    {
      if (Std.is(comp, Renderable) renderable = true;
      comp.init(this);
    }
  }
  
}