package libBlu.managers;

import libBlu.display.GameEntity;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class EntityManager
{
  public var entities:Array<GameEntity>;
  public var names:Array<String>;

  public function new() 
  {
    entities = [];
    names    = [];
  }
  
  public function addEntity(entity:GameEntity):Void
  {
    entities.push(entity);
    names.push(entity.name);
  }
  
  public function getEntity(name:String, ?index:Int):GameEntity
  {
    if (index != null)
    {
      return entities[names.indexOf(name, index)];
    }
    else
    {
      return entities[names.indexOf(name)];
    }
  }
  
}