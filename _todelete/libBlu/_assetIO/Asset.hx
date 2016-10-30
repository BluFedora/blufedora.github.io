package libBlu._assetIO;

import libBlu._assetIO.TileObject;
import haxe.Unserializer;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.media.Sound;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

#if (cpp || neko)
	import sys.FileSystem;
	import sys.io.File;
#end

/**
 * Handles Cross-Platform Asset Loading and Saving
 * @author Shareef Raheem (Blufedora)
 */
class Asset
{
	public static inline function fileBitmapdata(path:String):BitmapData
	{
		#if (cpp || neko) if (!FileSystem.exists(path)) return null; #end
		
		var loader:Loader = new Loader();
		loader.load(new URLRequest(path));
		return cast(loader.content, Bitmap).bitmapData;
	}
	
	public static function loadMap(path:String = ""):Array<Dynamic>
	{  
		#if (cpp || neko) if (!FileSystem.exists(path)) return [[""], [""], [null], [null]]; #end
		
		var names:Array<String>;
		names = path.split("\\");
		
		var allArray:Array<Dynamic> = [];
		var textLoader:URLLoader = new URLLoader();
		textLoader.load(new URLRequest(path));
		
		var unserializer = new Unserializer(textLoader.data);
		allArray.push(names[names.length - 1]);
		allArray.push(path);
		allArray.push(unserializer.unserialize());
		allArray.push(unserializer.unserialize());
		
		return allArray;
	}
	
	public static function loadText(path:String = ""):String
	{  
		#if (cpp || neko) if (!FileSystem.exists(path)) return ""; #end
		var textLoader:URLLoader = new URLLoader();
		textLoader.load(new URLRequest(path));
		return textLoader.data;
	}
	
	public static inline function getBitmapData(path:String):BitmapData
	{
		return Assets.getBitmapData(path);
	}
	
	public static inline function getText(path:String):String
	{
		return Assets.getText(path);
	}
	
	public static inline function getSound(path:String):Sound
	{
		return Assets.getSound(path);
	}
	
	public static function parseText(pathOrText:String, isPath:Bool):Array<String>
	{
		var text:String = pathOrText;
		if (isPath) text = getText(pathOrText);
		
		var lines:Array<String> = text.split("\n");
		var strings:Array<String> = [];
		var line:String;
		
		while (lines.length > 0) 
		{	
			line = StringTools.replace(lines.shift(), "\r", "");
			
			if (line.length != 0 && line != "")
			{
				//you can create a switch if you are not just adding dialogues just add:
				// if(line.indexOf("Dialogue") != -1)
				strings.push(line);
			}
		}
		
		return strings;
	}
	
	#if (cpp || neko)
		public static inline function relativePath(path:String, exeName:String):String
		{
			return StringTools.replace(Sys.executablePath() + path, exeName, "");
		}
		
		public static inline function getPath(path:String):Array<String>
		{
			return FileSystem.readDirectory(path);
		}
	#end
	
	public static inline function openDialog():Void
	{
		
	}
}