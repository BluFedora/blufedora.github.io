package libBlu.engine;

import libBlu._assetIO.Asset;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class LevelView extends RenderView
{
  public function new() 
  {
    super();
  }
  
  private function setLevel():Void
  {
    
  }
  
  private function loadMap(path:String = ""):Array<Dynamic>
  {
    return Asset.loadMap(path);
  }
  
}