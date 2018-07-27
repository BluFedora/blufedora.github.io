package libBlu.gl;

import openfl.utils.ByteArray;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */

@:file("assets/shaders/fragment/TextureColorOverlay.frag.glsl")
class ColorOverlay extends ByteArray { }

@:file("assets/shaders/fragment/Texture.frag.glsl")
class Texture extends ByteArray { }
 
class Shaders
{
  public static var TEXTURE_COLOR_FRAGMENT:String = new ColorOverlay().toString();
  public static var TEXTURE:String = new Texture().toString();

  public function new() 
  {
    
  }
  
}