package libBlu.gl;

import libBlu.gl.GLTile;
import libBlu.math.Calc;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Batched_Quad extends GLTile
{
  public var width:Float;
  public var height:Float;
  
  public var x:Float;
  public var y:Float;
  public var z:Float;
  
  /**
  *  Draw Order: Forward Facing (CW)
  * ______________
  * |0,0 1,2-----1,
  * |    | \    |
  * |    |  /   |
  * |    |   \  |
  * |    0-----2,0
  */
  public function new(x:Float = 0, y:Float = 0, z:Float = 0, width:Float = 36, height:Float = 36, id:Int = 0) 
  {
    super();
    this.height = height;
    this.width = width;
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    
    var texW:Float = width / 36;
    var texH:Float = height / 36;
    
    texCoords = 
    [
      0,    texH, //Bottom Left
      0,    0,    //Top Left
      texW, texH, //Bottom Right
      texW, texH, //Bottom Right
      texW, 0,    //Top Right
      0,    0     //Top Left
    ];
    
    indices =
    [
      0, 1, 2,
      3, 1, 2
    ];
    
    var size = Calc.glSize(width, height, z);
    var pos  = Calc.glCoords(x, y, z);
    
    setVertexPos(4, size[0] + pos[0], 0        + pos[1], z);//0 //1
    setVertexPos(1, 0       + pos[0], 0        + pos[1], z);//1 //0
    setVertexPos(2, size[0] + pos[0], -size[1] + pos[1], z);//2 //3
    setVertexPos(0, 0       + pos[0], -size[1] + pos[1], z);//3 //2
    
    setVertexPos(3, size[0] + pos[0], -size[1] + pos[1], z);//3 //2
    setVertexPos(5, 0       + pos[0], 0        + pos[1], z);//3 //2
    
    setVertexColor(0, 0x01B4F8, 0.7);
    setVertexColor(1, 0x07F159, 1.0);
    setVertexColor(2, 0xF2F900, 0.3);
    setVertexColor(3, 0xF5035F, 1.0);
    
    setVertexColor(0, 0xE7E0FE, 1.0);
    setVertexColor(1, 0xE7E0FE, 1.0);
    setVertexColor(2, 0xE7E0FE, 1.0);
    setVertexColor(3, 0xE7E0FE, 1.0);
    
    addBuffers();
  }
  
}