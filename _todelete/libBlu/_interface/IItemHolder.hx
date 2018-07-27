package libBlu._interface;

import libBlu.display.Item;

/**
 * @author Shareef Raheem (Blufedora)
 */

interface IItemHolder 
{
  private var heldItems:Array<Item>;
  
  public function addItem(item:Item):Void;
  public function removeItem(item:Item):Item;
  public function hasItem(item:Item):Bool;
}