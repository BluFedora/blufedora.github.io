package libBlu.gl;

import libBlu.math.Calc;
import libBlu.render.GLTileBatcher;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class GLTile
{
  public var vertColor:Array<Float> = [];
  public var texCoords:Array<Float> = [];
  public var vertices:Array<Float>  = [];
  public var indices:Array<Int>     = [];
  
  public var numVertices:Int = 0;
  public var id:Int = 0;

  public function new() { }
  
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
  
  public function setVertexColor(index:Int, color:Int, alpha:Float = 1.0):Void
  {
    var rgb = Calc.hexToRGB(color);
    var c = index * 4;
    
    for (i in 0...3) vertColor[c + i] = rgb[i];
    vertColor[c + 3] = alpha;
  }
  
  public function addBuffers():Void
  {
    this.numVertices = vertices.length;
    GLTileBatcher.addTextureCoords(texCoords);
    GLTileBatcher.addVertices(vertices, id);
    GLTileBatcher.addIndices(indices, id);
    GLTileBatcher.addColor(vertColor);
  }
  
}