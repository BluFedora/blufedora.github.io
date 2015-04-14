package libBlu.debug ;

import haxe.Log;
import haxe.PosInfos;
import openfl.filters.DropShadowFilter;
import openfl.text.AntiAliasType;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;

@:font("assets/pf_ronda_seven.ttf") class RondaSevenFont extends Font { }

class Logger extends TextField
{

	public function new(inX:Float = 170.0, inY:Float = 10.0, inCol:Int = 0x000000, inSelectable:Bool = false) 
	{
		super();
		Font.registerFont(RondaSevenFont); //var font = new RondaSevenFont();
		
		defaultTextFormat = new TextFormat (new RondaSevenFont().fontName, 8, 0x1C2F28);
		filters = [new DropShadowFilter(4, 45, 0x2F4A49)];
		antiAliasType = AntiAliasType.ADVANCED;
		backgroundColor = 0x70A5A3;//0x72A471
		selectable = inSelectable;
		text = "LOGGER: ";
		background = true;
		sharpness = 400;
		wordWrap = true;
		Log.trace = log;
		height = 80;
		width = 300;
		alpha = .8;
		x = inX;
		y = inY;
	}
	
	public function log(v:Dynamic, ?inf:haxe.PosInfos):Void
	{
		appendText("\n" + "Line " + inf.lineNumber + ": " + Std.string(v));
		scrollV = maxScrollV;
	}
	
	public function clear():Void
	{
		text = "LOGGER: ";
		scrollV = maxScrollV;
	}
	
	public function scrollToTop():Void
	{
		scrollV = -maxScrollV;
	}
	
	public function scrollToBottom():Void
	{
		scrollV = maxScrollV;
	}
	
	public function scrollUp():Void
	{
		scrollV--;
	}
	
	public function scrollDown():Void
	{
		scrollV++;
	}
	
}