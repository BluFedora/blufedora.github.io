package libBlu;

import openfl.Assets;
import openfl.display.Shape;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * ...
 * @author Shareef Raheem
 */
class SoundObject extends Shape
{
	private var soundTransform:SoundTransform = new SoundTransform(0.1, .2);
	private var channel:SoundChannel;
	
	private var maskRect:Shape = new Shape();
	public var masking:Bool = false;
	
	private var distance:Float;
	private var volume:Float;
	private var sound:Sound;
	private var radius:Int;

	public function new(filePath:String, R:Int = 100, X:Float = 0, Y:Float = 0, M:Bool = false) 
	{
		sound = Assets.getSound(filePath);
		channel = sound.play();
		masking = M;
		radius = R;
		x = X;
		y = Y;
	}
	
	public function distanceFrom(refObject:Dynamic):Void
	{
		if (!masking)
		{
			distance = dist(refObject.x, refObject.y, x, y);
			volume = distance / radius;
			soundTransform.volume = volume;
			channel.soundTransform = soundTransform;
		}
		else if (masking && maskRect.hitTestObject(refObject))
		{
			distance = dist(refObject.x, refObject.y, x, y);
			volume = distance / radius;
			soundTransform.volume = volume;
			channel.soundTransform = soundTransform;
		}
		else
		{
			soundTransform.volume = 0;
			channel.soundTransform = soundTransform;
		}
	}
	
	public function addMask(XX:Float, YY:Float, WW:Float, HH:Float):Void
	{
		maskRect.graphics.beginFill(0xC8CD05, 1);
		maskRect.graphics.drawRect(XX - (WW / 2), YY - (HH / 2), WW, HH);
		maskRect.graphics.endFill();
	}
	
	private function dist(x1:Float, y1:Float, x2:Float, y2:Float):Int
	{
		return Math.round(Math.sqrt((abs(x1 - x2) * abs(x1 - x2)) + (abs(y1 - y2) * abs(y1 - y2))));
	}
	
	private function abs(value:Float):Float
	{
		return value < 0 ? -value : value;
	}
	
	public function stop():Void
	{
		channel.stop();
	}
	
}