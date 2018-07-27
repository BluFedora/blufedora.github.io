package libBlu.gl;

import libBlu.math.Calc;
import openfl.display.BitmapData;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLTexture;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;
import openfl.utils.UInt8Array;

#if js
  import js.html.Uint8Array;
#end

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class GLBody
{
  public var vertexPositionBuffer:GLBuffer;
  public var vertexTextureBuffer:GLBuffer;
  public var vertexIndiceBuffer:GLBuffer;
  public var vertexColorBuffer:GLBuffer;
  
  public var vertColor:Array<Float> = [];
  public var texCoords:Array<Float> = [];
  public var vertices:Array<Float>  = [];
  public var indices:Array<Int>     = [];
  
  public var numVertices:Int = 0;
  
  public var textures:Array<GLTexture> = [];
  public var texture:GLTexture;

  public function new() { }
  
  var index = 0;
  
  public function bindBuffers(vertexPosAttrib:Int, ?vertexColorAttrib:Int, ?vertexTextureAttrib:Int, ?samplerUniform:GLUniformLocation):Void
  {
    GL.bindBuffer(GL.ARRAY_BUFFER, vertexPositionBuffer);
    GL.vertexAttribPointer(vertexPosAttrib, 3, GL.FLOAT, false, 0, 0);
    
    if (vertexColorAttrib != null)
    {
      GL.bindBuffer(GL.ARRAY_BUFFER, vertexColorBuffer);
      GL.vertexAttribPointer(vertexColorAttrib, 4, GL.FLOAT, false, 0, 0);
    }
    
    if (vertexTextureAttrib != null && samplerUniform != null)
    {
      GL.bindBuffer(GL.ARRAY_BUFFER, vertexTextureBuffer);
      GL.vertexAttribPointer(vertexTextureAttrib, 2, GL.FLOAT, false, 0, 0);
      
      GL.activeTexture(GL.TEXTURE0);
      GL.bindTexture(GL.TEXTURE_2D, textures[index]);
      GL.uniform1i(samplerUniform, 0);
    }
    
    if (texIndex > 1)
    {
      if (index == texIndex - 1)
        index = 0;
      else if (index < texIndex && index <= texIndex)
        index++;
    }
    
    GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, vertexIndiceBuffer);
  }
  
  public function draw():Void
  {
    GL.drawElements(GL.TRIANGLES, 6, GL.UNSIGNED_SHORT, 0);
  }
  
  public function setVertexPos(index:Int, x:Float, y:Float, z:Float):Void
  {
    var p:Int = index * 3;
    
    vertices[p + 0] = x;
    vertices[p + 1] = y;
    vertices[p + 2] = z;
  }
  
  public function setVertexPos2(index:Int, x:Float, y:Float, z:Float):Void
  {
    var p:Int = index * 3;
    var size = Calc.glSize(x, y, z);
    
    for (i in 0...3) vertices[p + i] = size[i];
  }
  
  /**
  * vertColor[c + 0] = rgb[0];
  * vertColor[c + 1] = rgb[1];
  * vertColor[c + 2] = rgb[2];
  * vertColor[c + 3] = alpha;
  */
  public function setVertexColor(index:Int, color:Int, alpha:Float = 1.0):Void
  {
    var rgb = Calc.hexToRGB(color);
    var c = index * 4;
    
    for (i in 0...3) vertColor[c + i] = rgb[i];
    vertColor[c + 3] = alpha;
  }
  
  public function creatBuffers():Void
  {
    vertexPositionBuffer = GL.createBuffer();
    GL.bindBuffer(GL.ARRAY_BUFFER, vertexPositionBuffer);
    GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast vertices), GL.STATIC_DRAW);
    
    vertexColorBuffer = GL.createBuffer();
    GL.bindBuffer(GL.ARRAY_BUFFER, vertexColorBuffer);
    GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast vertColor), GL.STATIC_DRAW);
    
    vertexTextureBuffer = GL.createBuffer();
    GL.bindBuffer(GL.ARRAY_BUFFER, vertexTextureBuffer);
    GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast texCoords), GL.STATIC_DRAW);
    
    vertexIndiceBuffer = GL.createBuffer();
    GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, vertexIndiceBuffer);
    GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Int16Array(cast indices), GL.STATIC_DRAW);
  }
  
  var texIndex = 0;
  
  public function addTexture(bmd:BitmapData):Void
  {
    textures[texIndex] = GL.createTexture();
    GL.bindTexture(GL.TEXTURE_2D, textures[texIndex]);
    #if js
      var data:Uint8Array = new Uint8Array(cast bmd.getPixels(bmd.rect));
    #else
      var data:UInt8Array = new UInt8Array(bmd.getPixels(bmd.rect));
    #end
    GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, bmd.width, bmd.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
    GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
    GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
    GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
    GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
    GL.bindTexture(GL.TEXTURE_2D, null);
    texIndex++;
  }
  
  public function delete():Void
  {
    GL.deleteBuffer(vertexPositionBuffer);
    GL.deleteBuffer(vertexTextureBuffer);
    GL.deleteBuffer(vertexColorBuffer);
    GL.deleteTexture(texture);
    
    texCoords = null;
    vertColor = null;
    vertices = null;
  }
  
}