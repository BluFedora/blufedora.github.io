package com.blufedora.portfolio;

import js.html.DivElement;
import js.html.MouseEvent;

/**
 * ...
 * @author BluFedora (Shareef Raheem)
 */
class Photos 
{
	private static var images = [];
	public static var index = 0;
	
	private static inline function onClick(e:MouseEvent):Void
	{
		Photos.setImage(images.indexOf(e.currentTarget));
	}
	
	public static function setImage(i:Int)
	{
		if 
		
		var idx = cast(Math.max(0.0, Math.max(i, Photos.images.length - 1), Int);
		
		var data = cast(images[idx], DivElement).dataset;
		
		Popup.popup.content.style.backgroundImage = "url(" + data.image + ")";
		Popup.popup.setText(data.title, data.comments);
		Popup.popup.show();
		index = idx;
	}
}