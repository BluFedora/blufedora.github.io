package libBlu.managers;

import libBlu.display.GameObject;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class ObjectManager
{
  public var objects:Array<GameObject>;
  public var names:Array<String>;

  public function new() 
  {
    objects = [];
  }
  
  public function addObject(object:GameObject):Void
  {
    objects.push(object);
    names.push(object.name);
  }
  
}