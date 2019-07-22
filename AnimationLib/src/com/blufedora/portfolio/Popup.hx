package com.blufedora.portfolio;

import js.Browser;
import js.html.Element;

/**
 * ...
 * @author BluFedora (Shareef Raheem)
 */
class Popup 
{
	public static var popup(get, null):Popup;
	
	public var popUp:Element;
	public var bg:Element;
	public var prev:Element;
	public var content:Element;
	public var next:Element;

	public function new() 
	{
		this.popUp 		= Browser.document.getElementById("pop-up");
		this.bg 		= Browser.document.getElementById("pop-up-bg");
		this.prev 		= Browser.document.getElementById("pop-up-prev");
		this.content 	= Browser.document.getElementById("pop-up-content");
		this.next 		= Browser.document.getElementById("pop-up-next");
		
		this.prev.onclick = function()
		{
			Photos.setImage(Photos.index - 1);
		}
		
		this.next.onclick = function()
		{
			Photos.setImage(Photos.index + 1);
		}
		
		this.bg.onclick = function()
		{
			this.popUp.classList.add("hidden-2");
		};
	}
	
	public function show()
	{
		this.popUp.classList.remove("hidden-2");
	}
	
	static function get_popup():Popup 
	{
		if (popup == null) {
			popup = new Popup();
		}
		
		return popup;
	}
	
}