package libBlu.render;

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
class GLTileBatcher
{
	public static var vertexPositionBuffer:GLBuffer;
	public static var vertexTextureBuffer:GLBuffer;
	public static var vertexIndiceBuffer:GLBuffer;
	public static var vertexColorBuffer:GLBuffer;
	
	public static var textures:Array<GLTexture> = [];
	
	public static var texCoords:Array<Float> = [];
	public static var vertices:Array<Float> = [];
	public static var colors:Array<Float> = [];
	public static var indices:Array<Int> = [];
	
	private static var texIndex:Int = 0;
	private static var times:Int = 0;
	
	public static inline function addVertices(verts:Array<Float>, id:Int = 0):Void
	{
		for (i in 0...verts.length) vertices.push(verts[i]);
	}
	
	public static inline function addTextureCoords(texCoord:Array<Float>):Void
	{
		texCoords = texCoords.concat(texCoord);
	}
	
	public static inline function addColor(colorArr:Array<Float>):Void
	{
		colors = colors.concat(colorArr);
	}
	
	public static inline function addIndices(indice:Array<Int>, id:Int = 0):Void
	{
		var index = id * 4;
		
		for (i in indice)
		{
			indices.push(index + i);
			times++;
		}
	}
	
	public static inline function addTexture(bmd:BitmapData):Void
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
	
	public static inline function createBuffers():Void
	{
		vertexPositionBuffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexPositionBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast vertices), GL.STATIC_DRAW);
		
		vertexColorBuffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexColorBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast colors), GL.STATIC_DRAW);
		
		vertexTextureBuffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexTextureBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast texCoords), GL.STATIC_DRAW);
		
		vertexIndiceBuffer = GL.createBuffer();
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, vertexIndiceBuffer);
		GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Int16Array(cast indices), GL.STATIC_DRAW);
	}
	
	public static inline function bindBuffers(vertexPosAttrib:Int, ?vertexColorAttrib:Int, ?vertexTextureAttrib:Int, ?samplerUniform:GLUniformLocation):Void
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
			GL.bindTexture(GL.TEXTURE_2D, textures[0]);
			GL.uniform1i(samplerUniform, 0);
		}
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, vertexIndiceBuffer);
	}
	
	public static inline function render():Void
	{
		//GL.frontFace(GL.CW);
		GL.drawArrays(GL.TRIANGLES, 0, vertices.length * 3);
		//GL.frontFace(GL.CCW);
		
		//Reested Drawing
		//GL.drawElements(GL.TRIANGLE_STRIP, indices.length, GL.UNSIGNED_SHORT, 0); 
	}
	
}