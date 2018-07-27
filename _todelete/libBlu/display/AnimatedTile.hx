package libBlu.display;

import libBlu.animation.AnimationStack;
import libBlu.render.TileRenderer;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class AnimatedTile extends Tile
{
  public var animationDone:Bool = false;
  
  private var _animations:AnimationStack;
  
  private var _currentAnim:Animation;
  //private var _currentFrame:Int = 0;
  private var _currentIndex:Int = 0;
  private var _timePassed:Float = 0;

  public function new(x:Float, y:Float, terrainLayer:TileRenderer, animation:AnimationStack, id:Int) 
  {
    super(x, y, 0, terrainLayer, id, "AnimatedTile" + id);
    _currentAnim = animation.animations[0];
    _animations = animation;
  }
  
  public function showAnim(name:String):Void
  {
    _currentAnim = _animations.getAnimation(name);
  }
  
  override public function update():Void 
  {
    super.update();
    //TileRenderer.renderArray[index + 2] = _currentFrame; //Type
    _timePassed++;
  }
  
  override private function updateFrame():Void 
  {
    if (_timePassed % (_currentAnim.speed * 60) == 0)
    {
      if (_currentAnim != null)
      {  
        if (_currentIndex + 1 < _currentAnim.frames.length)
          _currentIndex++;
        else
          _currentIndex = 0;
        
        //_currentFrame = _currentAnim.frames[_currentIndex];
        _type = _currentAnim.frames[_currentIndex]
        
        if(_type == _currentAnim.frames.length)
      }
      
      _timePassed = 0;
    }
  }
  
}