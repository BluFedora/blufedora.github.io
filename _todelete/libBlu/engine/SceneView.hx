package libBlu.engine;

import libBlu._interface.IScene;

#if flash
  import openfl.system.System;
#elseif cpp
  import cpp.vm.Gc;
#end

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class SceneView extends Base
{
  private var _currentScene(default, null):IScene;

  public function new() 
  {
    super();
    
  }
  
  override public function initScript():Void 
  {
    super.initScript();
    
    Base.scriptEngine.exposeMethod(
      ["loadScene", "scene"], 
      [loadScene, _currentScene]
    );
  }
  
  public function loadScene(newScene:IScene):Void
  {
    if (_currentScene != null)
    {
      removeChild(cast _currentScene);
      _currentScene.clear();
      _currentScene = null;
    }
    
    #if flash
      openfl.system.System.gc();
    #elseif cpp
      Gc.run(true);  
    #end
    
    newScene.initialize();
    _currentScene = newScene;
    addChild(cast _currentScene);
  }
  
}