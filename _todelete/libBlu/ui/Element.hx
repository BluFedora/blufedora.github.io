package libBlu.ui;

import libBlu._enum.Location;
import libBlu.managers.LayersManager;
import openfl.display.Sprite;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Element extends Sprite
{
	private var snapToEdge:Bool = false;
	private var snappedEdge:Location = Location.LEFT;

	public function new(x:Float, y:Float) 
	{
		super();
		
		LayoutManager.addElement(this);
	}
	
	@:allow(LayersManager)
	private function onResize():Void
	{
		
	}
	
}