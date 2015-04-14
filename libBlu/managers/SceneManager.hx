package libBlu.managers;

#if cpp
	import cpp.vm.Gc;
#elseif neko
	import neko.vm.Gc;
#end

import newCore._interface.IScene;
import libBlu.App;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class SceneManager
{
	private static var _currentScene(default, null):IScene;
	private static var _screenContainer:App;

	public function new() 
	{
		
	}
	
	public function loadScene(newScene:IScene):Void
	{
		if (_screenContainer != null)
		{
			if (_currentScene != null)
			{
				_screenContainer.removeChild(cast _currentScene);
				_currentScene.clear();
				_currentScene = null;
			}
		}
		
		#if flash
			openfl.system.System.gc();
		#else
			Gc.run(true);	
		#end
		
		newScene.initialize();
		_currentScene = newScene;
		_screenContainer.addChild(cast _currentScene);
	}
	
}