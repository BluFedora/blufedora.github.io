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
	public var text:Element;
	public var next:Element;

	public function new() 
	{
		var doc = Browser.document;
		
		this.popUp 		= doc.getElementById("pop-up");
		this.bg 		= doc.getElementById("pop-up-bg");
		this.prev 		= doc.getElementById("pop-up-prev");
		this.content 	= doc.getElementById("pop-up-content");
		this.text 	    = doc.getElementById("pop-up-text");
		this.next 		= doc.getElementById("pop-up-next");
		
		this.prev.onclick = function()
		{
			LoadPortfolio.setImage(LoadPortfolio.s_CurrentIndex - 1);
		}
		
		this.next.onclick = function()
		{
			LoadPortfolio.setImage(LoadPortfolio.s_CurrentIndex + 1);
		}
		
		this.bg.onclick = function()
		{
			this.popUp.classList.add("hidden");
			Browser.document.body.classList.remove("modal-open");
		};
	}
	
	public function setText(title:String, txt:String)
	{
		if (this.text != null)
		{
			if (txt != null)
			{
				this.text.innerHTML = "<h4>" + title + "</h4><hr>\n" + txt;
				this.text.classList.remove("hidden");
			}
			else
			{
				this.text.innerHTML = "";
				this.text.classList.add("hidden");
			}
		}
	}
	
	public function show()
	{
		this.popUp.classList.remove("hidden");
		Browser.document.body.classList.add("modal-open");
	}
	
	static function get_popup():Popup 
	{
		if (popup == null) {
			popup = new Popup();
		}
		
		return popup;
	}
	
}