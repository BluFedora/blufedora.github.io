package libBlu.gl;

import libBlu.gl.GLBody;
import libBlu.math.Calc;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class Quad extends GLBody
{
	public var width:Float;
	public var height:Float;
	
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	/**
	*  Draw Order: Forward Facing
	* ______________
	* |0,0	1-----0
	* |		| \   |
	* |		|  /  |
	* |		|   \ |
	* |		3-----2
	*/
	public function new(w:Float, h:Float, z:Float = 0, x:Float = 0, y:Float = 0) 
	{
		super();
		
		this.width = w;
		this.height = h;
		
		this.x = x;
		this.y = y;
		this.z = z;
		
		var texW:Float = w / 36;
		var texH:Float = h / 36;
		
		texCoords = 
		[
			texW, 0,    //Top Right
			0,    0,    //Top Left
			texW, texH, //Bottom Right
			0,    texH  //Bottom Left
		];
		
		indices =
		[
			0, 1, 2,
			2, 1, 3
		];
		
		var size = Calc.glSize(w, h, z);
		var pos = Calc.glCoords(x, y, z);
		
		setVertexPos(0, size[0] + pos[0], 0 + pos[1],        z);//0 //1
		setVertexPos(1, 0 + pos[0],       0 + pos[1],        z);//1 //0
		setVertexPos(2, size[0] + pos[0], -size[1] + pos[1], z);//2 //3
		setVertexPos(3, 0  + pos[0],      -size[1] + pos[1], z);//3 //2
		
		setVertexColor(0, 0x01B4F8, 0.7);
		setVertexColor(1, 0x07F159, 1.0);
		setVertexColor(2, 0xF2F900, 0.3);
		setVertexColor(3, 0xF5035F, 1.0);
		
		numVertices = 4;
		creatBuffers();
	}
	
}