package libBlu.animation;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class AnimationStack
{
  public var animations:Array<Animation> = [];
  //public var fps:Float;

  public function new(name:String, frames:Array<Int>, speed:Float = 1) 
  {
    addAnimation(name, frames, speed);
    //fps = speed;
  }
  
  public function addAnimation(name:String, frames:Array<Int>, speed:Float = 1):Void
  {
    animations.push( { name:name, frames:frames, speed:speed } );
  }
  
  public function getAnimation(name:String):Animation
  {
    for (anim in animations) if (anim.name == name) return anim;
    return {name:"ERROR", frames:[0], speed:1 };
  }
  
}

typedef Animation =
{
  var name:String;
  var frames:Array<Int>;
  var speed:Float;
}