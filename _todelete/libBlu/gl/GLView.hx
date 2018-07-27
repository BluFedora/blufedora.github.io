package libBlu.gl;

import libBlu.gl.constants.BlendFunc;
import libBlu.math.Calc;
import libBlu.render.GLTileBatcher;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.OpenGLView;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class GLView extends Sprite
{
  private var mvMatrixUniform:GLUniformLocation;
  private var pMatrixUniform:GLUniformLocation;
  private var samplerUniform:GLUniformLocation;
  private var vertexPositionAttribute:Int;
  private var vertexColorAttribute:Int;
  private var texCoordAttribute:Int;
  
  private var shader:GLProgram;
  public var view:OpenGLView;
  
  private var mvMatrixStack:Array<Matrix3D> = [];
  private var mvMatrix:Matrix3D = new Matrix3D();
  private var pMatrix:Matrix3D;
  
  public var house:Quad = new Quad(36, 36, 0, 36, 36);
  public var quad2:Quad;
  
  var id = 0;
  
  public function addQuad():Void
  {
    for (i in 0...500)
    {
      var batched:Batched_Quad = new Batched_Quad(mouseX, mouseY, 0, 36, 36, id);
      id++;
    }
    GLTileBatcher.createBuffers();
  }

  public function new() 
  {
    super();
    
    if (OpenGLView.isSupported)
    {
      view = new OpenGLView();
      
      var bmd:BitmapData = new BitmapData(18, 18);
      bmd.copyPixels(Assets.getBitmapData("assets/Tilesheet.png"), new Rectangle(18 * 10, 18, 18, 18), new Point(0, 0));
      
      quad2 = new Quad(100, 100, 0);
      quad2.addTexture(bmd);
      quad2.setVertexPos2(0, 200, 0, 0);
      quad2.setVertexColor(0, 0x400040, 1.0);
      quad2.setVertexColor(1, 0xAF9DF9, 1.0);
      quad2.setVertexColor(2, 0xFFFFFF, 1.0);
      quad2.setVertexColor(3, 0xFB4DEA, 1.0);
      quad2.creatBuffers();
      
      var bmd2:BitmapData = new BitmapData(144, 125);
      bmd2.copyPixels(Assets.getBitmapData("assets/Tilesheet.png"), new Rectangle(0, 0, 18, 18), new Point(0, 0));
      house.setVertexColor(0, 0xFFFFFF, 1.0);
      house.setVertexColor(1, 0x5200BF, 1.0);
      house.setVertexColor(2, 0xF4E89D, 1.0);
      house.setVertexColor(3, 0x0080C0, 1.0);
      house.addTexture(bmd2);
      house.creatBuffers();
      
      var bmd2:BitmapData = new BitmapData(18, 18);
      bmd2.copyPixels(Assets.getBitmapData("assets/Tilesheet.png"), new Rectangle(0, 0, 18, 18), new Point(0, 0));
      
      GLTileBatcher.addTexture(bmd2);
      
      var t:Int = 0;
      for (i in 0...100)
      {
        var batched:Batched_Quad = new Batched_Quad(Std.int(i % 20) * 36, Std.int(i / 20) * 36, -10, 36, 36, t);
        t++;
      }
      
      id = t + 1;
      
      GLTileBatcher.createBuffers();
      
      initShaders();
      
      setRender(update);
      addChild(view);
    }
  }
  
  public function translate(coords:Array<Float>):Void
  {
    mvMatrix.appendTranslation(coords[0], coords[1], coords[2]);
  }
  
  public function rotate(r:Int, x:Int = 0, y:Int = 0, z:Int = 0):Void
  {
    mvMatrix.appendRotation(r, new Vector3D(x, y, z));
  }
  
  var r = 0;
  public var MAX = 1;
  
  var all:Array<Float> = [];
  
  public function update():Void
  {  
    beginBoilerPlate();
    
    //r = 305;
    //r++;
    //GL.enable(GL.BLEND);
    //GL.blendFunc(GL.BLEND_SRC_RGB, GL.ONE_MINUS_DST_ALPHA);
    
    //GL.depthMask(true);
    
    resetModelViewMatrix();
    //translate(Calc.glCoords(150, 0, 0));
    rotate(r, 1, 0, 0);
    GLTileBatcher.bindBuffers(vertexPositionAttribute, vertexColorAttribute, texCoordAttribute, samplerUniform);
    setMatrixUniforms();
    GLTileBatcher.render();
    
    //GL.depthMask(false);
    
    resetModelViewMatrix();
    quad2.bindBuffers(vertexPositionAttribute, vertexColorAttribute, texCoordAttribute, samplerUniform);
    translate(Calc.glCoords(400, 100, 0));
    setMatrixUniforms();
    quad2.draw();
    
    endBoilerPlate();
  }
  
  private function initShaders():Void
  {
    var vertexShader = GL.createShader(GL.VERTEX_SHADER);
    GL.shaderSource(vertexShader, Assets.getText("assets/shaders/vertex/shader.vert"));
    GL.compileShader(vertexShader);
    
    if (GL.getShaderParameter(vertexShader, GL.COMPILE_STATUS) == 0) throw "Error compiling vertex shader";
    
    var fragmentShader = GL.createShader(GL.FRAGMENT_SHADER);
    GL.shaderSource(fragmentShader, Shaders.TEXTURE_COLOR_FRAGMENT);
    GL.compileShader(fragmentShader);
    
    if (GL.getShaderParameter(fragmentShader, GL.COMPILE_STATUS) == 0) throw "Error compiling fragment shader";
    
    shader = GL.createProgram();
    GL.attachShader(shader, vertexShader);
    GL.attachShader(shader, fragmentShader);
    GL.linkProgram(shader);
    
    if (GL.getProgramParameter(shader, GL.LINK_STATUS) == 0) throw "Unable to initialize the shader program.";
    
    vertexPositionAttribute = GL.getAttribLocation (shader, "aVertexPosition");
    vertexColorAttribute = GL.getAttribLocation (shader, "aVertexColor");
    texCoordAttribute = GL.getAttribLocation (shader, "aTextureCoord");
  }
  
  private function setMatrixUniforms():Void
  {
    GL.uniformMatrix4fv(pMatrixUniform, false, new Float32Array(pMatrix.rawData));
    GL.uniformMatrix4fv(mvMatrixUniform, false, new Float32Array(mvMatrix.rawData));
  }
  
  private function resetModelViewMatrix():Void
  {
    if (mvMatrixStack.length > 0) mvMatrix = mvMatrixStack.pop();
    mvMatrixStack.push(mvMatrix.clone());
  }
  
  public function setRender(func:Dynamic):Void
  {
    view.render = func;
  }
  
  private function beginBoilerPlate():Void
  {
    //GL.viewport(0, 0, App.windowWidth(), App.windowHeight());
    GL.enableVertexAttribArray(vertexPositionAttribute);
    GL.enableVertexAttribArray(vertexColorAttribute);
    GL.enableVertexAttribArray(texCoordAttribute);
    //GL.enable(GL.SCISSOR_TEST);
    GL.enable(GL.STENCIL_TEST);
    GL.enable(GL.TEXTURE_2D);
    GL.enable(GL.DEPTH_TEST);
    //GL.enable(GL.CULL_FACE);
    GL.useProgram(shader);
    
    pMatrixUniform  = GL.getUniformLocation(shader, "uPMatrix");
    mvMatrixUniform = GL.getUniformLocation(shader, "uMVMatrix");
    samplerUniform  = GL.getUniformLocation(shader, "uSampler");
    
    pMatrix = Projection.ORTHOGRAPHIC(20, 3);
    mvMatrix.identity();
    mvMatrix.appendTranslation( -1, 1, 0);
  }
  
  private function endBoilerPlate():Void
  {
    GL.disableVertexAttribArray(vertexPositionAttribute);
    GL.disableVertexAttribArray(vertexColorAttribute);
    GL.disableVertexAttribArray(texCoordAttribute);
    GL.bindBuffer(GL.ARRAY_BUFFER, null);
    GL.bindTexture(GL.TEXTURE_2D, null);
    GL.disable(GL.STENCIL_TEST);
    GL.disable(GL.TEXTURE_2D);
    GL.disable(GL.DEPTH_TEST);
    //GL.disable(GL.CULL_FACE);
    GL.useProgram (null);
  }
  
}