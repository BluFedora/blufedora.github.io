package libBlu.display;

import libBlu._interface.IHealth;
import libBlu._interface.IItemHolder;
import libBlu.display.Item;
import libBlu.physics.PhysicsObject;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class GameEntity extends PhysicsObject implements IHealth implements IItemHolder
{
	private var heldItems:Array<Item>;
	
	public var health:Float;
	public var damage:Float;

	public function new(entityName:String, x:Float, y:Float, width:Float, height:Float) 
	{
		super(x, y, width, height);
		name = entityName;
		heldItems = [];
	}
	
	public function giveHealth(life:Float):Void
	{
		health += life;
	}
	
	public function addItem(item:Item):Void
	{
		heldItems.push(item);
	}
	
	public function removeItem(item:Item):Item
	{
		if (hasItem(item)) heldItems.remove(item);
		return item;
	}
	
	public function hasItem(item:Item):Bool
	{
		return heldItems.copy().remove(item);
	}
	
	public function takeDamage(damage:Float):Void
	{
		health -= damage;
	}
	
}

/**
 * From slowest to fastest, the render methods for NME are generally:
 * copyPixels < display list [BITMAPS] <> drawRect <> drawTriangles < drawTiles
 */