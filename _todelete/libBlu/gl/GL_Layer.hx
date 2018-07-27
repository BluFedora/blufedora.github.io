package libBlu.gl;

import libBlu.engine.Base;
import openfl.display.OpenGLView;
import openfl.geom.Matrix3D;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class GL_Layer
{
  public var glView:OpenGLView;
  
  private var mvMatrix:Matrix3D = new Matrix3D();

  public function new() 
  {
    if (OpenGLView.isSupported)
    {
      Base.MAIN.addChild(glView);
    }
  }
  
  public function translate(coords:Array<Float>):Void
  {
    mvMatrix.appendTranslation(coords[0], coords[1], coords[2]);
  }
  
}