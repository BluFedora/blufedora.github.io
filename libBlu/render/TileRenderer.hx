package libBlu.render;

import libBlu._interface.IRenderer;
import libBlu.animation.TextureSheet;
import libBlu.display.Tile;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */

@:allow(libBlu.display.Tile)
class TileRenderer implements IRenderer
{
	private static var renderArray:Array<Float> = [];  //* Accesesd by Tile Class *//
	public var tileArray:Array<Tile>            = []; //*     Internal Use      *//
	
	private var _tilesheet:Tilesheet;
	
	#if (flash || neko || html5)
		private var _target:Sprite;
		private var flashSheet:TextureSheet;
	#else
		private var _target:Dynamic;
	#end
	
	public var tileWidth:Float;
	public var tileHeight:Float;
	
	private var _numTiles:Int;
	private var _numCols:Int;
	private var _numRows:Int;

	public function new(bitmapData:BitmapData, columns:Int, rows:Int, tileWidth:Float, tileHeight:Float) 
	{
		this.tileHeight = tileHeight;
		this.tileWidth = tileWidth;
		swapTexture(bitmapData);
		_numCols = columns;
		_numRows = rows;
		addRects();
		
		#if flash
			flashSheet = new TextureSheet(bitmapData, columns, rows, tileWidth / 2, tileHeight / 2);
		#end
	}
	
	public function swapTexture(bitmapData:BitmapData):Void 
		_tilesheet = new Tilesheet(bitmapData);
	
	public function setTarget(value:Dynamic):Void 
		_target = value;
	
	public function updateTiles(tileArr:Array<Tile>):Void
	{
		clear();
		tileArray = tileArr;
		if (_target != null) render(_target);
	}
	
	public function render(target:Dynamic, ?blendMode:Int = Tilesheet.TILE_BLEND_NORMAL):Void
	{
		setTarget(target);
		
		if (_target != null)
		{
			_target.graphics.clear();
			
			for (tile in tileArray)
			{
				if (tile.active)
				{
					#if flash
					var mat:Matrix = new Matrix();
					mat.scale(2, 2);
					_target.graphics.beginBitmapFill(flashSheet.getFrame(tile._type), mat);
					_target.graphics.drawRect(tile.x, tile.y, 36, 36);
					_target.graphics.endFill();
				}
			}
					#else
						tile.update();
				}
			}
			
			_tilesheet.drawTiles(_target.graphics, renderArray, false, Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.TILE_ALPHA | blendMode);
			#end
		}
	}
	
	private function addRects():Void
	{
		_numTiles = _numCols * _numRows;
		
		for (i in 0..._numTiles) //  \/--------->
		{
			_tilesheet.addTileRect(new Rectangle
			(
				tileWidth * (i % _numCols),
				tileHeight * Std.int(i / _numCols),
				tileWidth, 
				tileHeight
			));
		}
	}
	
	public function clear():Void 
	{
		renderArray = [];
		tileArray   = [];
	}
	
}