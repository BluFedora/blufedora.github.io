package libBlu;

import libBlu._assetIO.TileObject;
import libBlu.debug.Console;
import libBlu.debug.Debug;
import libBlu.debug.Logger;
import libBlu.display.GameEntity;
import libBlu.display.Tile;
import libBlu.gl.GLView;
import libBlu.managers.EntityManager;
import libBlu.managers.KeyManager;
import libBlu.managers.LayersManager;
import libBlu.managers.ObjectManager;
import libBlu.managers.TileManager;
import libBlu.render.TileRenderer;
import libBlu.scripting.HxsEngine;
//import lua.Lua;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class App extends Sprite
{
  private var glView:GLView;
  
  private var global:HxsEngine = new HxsEngine();
  private var logger:Logger = new Logger(170, 100);
  private var debug:Debug   = new Debug(10, 100);
  
  private var entityManager:EntityManager;
  private var objectManager:ObjectManager;
  private var layersManager:LayersManager;
  private var keysManager:KeyManager;      // Implemented ✔
  private var tileManager:TileManager;     // Implemented ✔
  
  var renderer:TileRenderer;
  
  var fArr:Array<TileObject> = [];

  public function new() 
  {
    super();
    //trace("ScriptEngine: [" + Lua.version + "] initialized");
    Console.init(this, 30);
    initManagers();
    addEventListener(Event.ENTER_FRAME, update);
  }
  
  private function initManagers():Void
  {  
    entityManager = new EntityManager();
    objectManager = new ObjectManager();
    layersManager = new LayersManager(this);
    keysManager = new KeyManager();
    tileManager = new TileManager();
  }
  
  private function addEntity(child:GameEntity):Void
  {
    entityManager.addEntity(child);
  }
  
  private function addTile(child:Tile):Void
  {
    tileManager.addTile(child);
  }
  
  private function keyDown(key:Int):Bool
  {  
    return keysManager.key[key];
    //return (keysManager.key[key])? true:false; //Ternary
  }
  
  private function reloadData():Void
  {  
    tileManager.tiles = [];
    
    var id = 0;
    
    for (i in 0...6)
    {
      for (tile in fArr)
      {
        if (tile.tileID != -1) if(tile.depthZ == i) addTile(new Tile(tile.posX, tile.posY, tile.tileType, renderer, id));
        id++;
      }
    }
    
    renderer.updateTiles(tileManager.tiles);
  }
  
  /**
   * Overrided By Child Classes
   */
  public function update(e:Event):Void
  {
    addChild(logger);
    addChild(debug);
  }
  
  public static inline function windowWidth():Int
  {
    return Lib.current.stage.stageWidth;
  }
  
  public static inline function windowHeight():Int
  {
    return Lib.current.stage.stageHeight;
  }
  
}