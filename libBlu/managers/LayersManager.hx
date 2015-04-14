package libBlu.managers;

import libBlu._enum.Layer;
import libBlu.engine.Base;
import blufedora.editor.layering.CShape;
import openfl.display.Shape;
import openfl.display.Sprite;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class LayersManager
{
	public static var layerE:Shape = new Shape();
	public static var layerO:Shape = new Shape();
	public static var layerT:Shape = new Shape();
	
	//System Layers
	public var _layerUI:Sprite = new Sprite(); //UI Elements (w/ Mouse Interaction)
	private var _layerC:CShape = new CShape();  //Collision (Duh)
	private var _layerW:CShape = new CShape();  //WarpLayer
	
	//In Game Layers
	private var _layerE:Shape = new Shape(); //Entities (Collidable)
	private var _layer1:Shape = new Shape(); //Terrain (Collidable)
	public var _layer0:Sprite = new Sprite(); //Bottom (UnCollidable)

	public function new(main:Sprite) 
	{
		main.addChild(_layer0);
		main.addChild(_layerUI);
	}
	
	public function getLayer(index:Layer):Dynamic
	{
		switch(index)
		{
			case Layer.UI:        return _layerUI;
			case Layer.COLLISION: return _layerC;
			case Layer.ENTITY:    return _layerE;
			case Layer.WARP:      return _layerW;
			case Layer.ONE:       return _layer1;
			case Layer.ZERO:      return _layer0;
			default:              return _layer0;
		}
	}
	
	public function clear():Void
	{
		_layerC.graphics.clear();
		_layerE.graphics.clear();
		_layer1.graphics.clear();
		_layer0.graphics.clear();
	}
	
}