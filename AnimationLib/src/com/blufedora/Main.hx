package com.blufedora;

import com.blufedora.portfolio.Links;
import com.blufedora.portfolio.Photos;
import js.Browser;
import js.html.Element;
import js.html.MouseScrollEvent;

/**
 * ...
 * @author Shareef Raheem
 */
class Main 
{
	static function main() 
	{	
		// Reg EX: .replace(/([\d.]+)(px|pt|em|%)/,'$1');
		
		// Browser.window.addEventListener("scroll", Main.onScroll, true);
		
		Browser.window.onload = function()
		{
			Tweener.init(Browser.window);
			
			var name_logo = Browser.document.getElementById("shareef");
			
			
			if (name_logo != null) {
			Tweener.add(name_logo, { loop:true })
			.to(new AnimationStep({ y: 170 		}, 2300, Easing.easeInOutSine))
			.to(new AnimationStep({ y: 200		}, 2000, Easing.easeInOutSine));
			}
			
			// if (Main.getFileName() == "index.html")
			{
				Links.init("game");
				Links.init("web");
				Photos.init("illustration");
				Photos.init("design");
				Photos.init("animation");
			}
			
			var menu = Browser.document.getElementById("menu");
			var side_panel = Browser.document.getElementById("side_panel");
			var main_article = Browser.document.getElementById("main_article");
			
			if (menu != null && side_panel != null && main_article != null)
			{
				var callback = function(evt)
				{
					cast(evt.currentTarget, Element).classList.toggle("opened");
					side_panel.classList.toggle("opened");
					main_article.classList.toggle("opened");
				};
				
				menu.onclick 	   = callback;
			}
		};
		
		Browser.window.onunload = function()
		{
			Tweener.destroy();
		};
	}
	
	private static function getFileName():String
	{
		//this gets the full url
		var url = Browser.document.location.href;
		//this removes the anchor at the end, if there is one
		url = url.substring(0, (url.indexOf("#") == -1) ? url.length : url.indexOf("#"));
		//this removes the query after the file name, if there is one
		url = url.substring(0, (url.indexOf("?") == -1) ? url.length : url.indexOf("?"));
		//this removes everything before the last slash in the path
		url = url.substring(url.lastIndexOf("/") + 1, url.length);
		//return
		return url;
	}
	
	private static function onScroll(evt:MouseScrollEvent)
	{
	}
}