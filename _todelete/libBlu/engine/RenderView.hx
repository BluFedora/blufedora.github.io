package libBlu.engine;

import libBlu.display.Camera;
import libBlu.display.GameEntity;
import libBlu.display.GameObject;
import libBlu.display.Tile;
import libBlu.managers.EntityManager;
import libBlu.managers.LayersManager;
import libBlu.managers.ObjectManager;
import libBlu.managers.TileManager;
import libBlu.render.TileRenderer;
import libBlu.ui.Key;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class RenderView extends SceneView
{
	private var camera:Camera = new Camera(0, 0);
	
	private static var tileID:Int = 0;
	
	private var entityManager:EntityManager;
	private var objectManager:ObjectManager;
	private var layersManager:LayersManager;
	private var tileManager:TileManager;
	
	private var tileRenderer:TileRenderer;

	public function new() 
	{
		super();
		entityManager = new EntityManager();
		objectManager = new ObjectManager();
		layersManager = new LayersManager(this);
		tileManager = new TileManager();
		
		RenderView.initLayers();
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	public static inline function initLayers():Void
	{
		Base.MAIN.addChild(LayersManager.layerT);
	}
	
	public function addEntity(entity:GameEntity):Void
	{
		entityManager.addEntity(entity);
	}
	
	public function addObject(object:GameObject):Void
	{
		objectManager.addObject(object);
	}
	
	private function addTile(tile:Tile):Void
	{
		tileManager.addTile(tile);
		tileID++;
	}
	
	private function add(object:Dynamic):Void
	{
		switch(Type.getClass(object))
		{
			case GameObject: objectManager.addObject(object);
			case GameEntity: entityManager.addEntity(object);
			case Tile:       tileManager.addTile(object);
		}
	}
	
	override public function initScript():Void 
	{
		super.initScript();
		
		Base.scriptEngine.exposeMethod(
			["addEntity", "addTile", "addObject"], 
			[addEntity, addTile, addObject]
		);
	}
	
	private var lastTime:Float = 0;
	
	public function update(e:Event):Void
	{
		var delta = Lib.getTimer() - lastTime;
		
		//_currentScene.update();
		updateScripts();
		update2D(delta); //Movement += (frameRate * delta / 1000) * pixels;
		update3D(delta);
		updateCameras();
		
		scale();
		
		lastTime = Lib.getTimer();
	}
	
	public function updateCameras() 
	{
		this.scaleX = camera.scaleX;
		this.scaleY = camera.scaleY;
		this.x = -camera.x;
		this.y = -camera.y;
	}
	
	public function scale():Void
	{
		//camera.scaleX += .001;
		//camera.x++;
	}
	
	public function updateScripts():Void
	{
		Base.scriptEngine.exposeMethod([for (i in 0...Key.ALPHABET.length) Key.ALPHABET[i] + "Down"], [for (i in Key.KEYSLIST) keyDown(i)]);
		
		for (entity in entityManager.entities)
		{
			if (entity.hasScript)
			{
				Base.scriptEngine.exposeMethod(["object"], [entity]);
				for (s in entity.bindedScript) Base.scriptEngine.runScript(s);
				entity.update();
			}
		}
		
		for (object in objectManager.objects)
		{
			if (object.hasScript)
			{
				Base.scriptEngine.exposeMethod(["object"], [object]);
				for (s in object.bindedScript) Base.scriptEngine.runScript(s);
				object.update();
			}
		}
		
		for (tile in tileManager.tiles)
		{
			if (tile.hasScript)
			{
				Base.scriptEngine.exposeMethod(["object"], [tile]);
				for (s in tile.bindedScript) Base.scriptEngine.runScript(s);
				tile.update();
			}
		}
		
		//Base.scriptEngine.callFunction("onUpdate");
	}
	
	public function update2D(delta:Float):Void
	{
		
	}
	
	public function update3D(delta:Float):Void
	{
		
	}
	
}