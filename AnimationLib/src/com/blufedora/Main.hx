package com.blufedora;

import com.blufedora.portfolio.Links;
import com.blufedora.portfolio.Photos;
import com.blufedora.portfolio.Popup;
import js.Browser;
import js.Lib;
import js.html.DeviceMotionEvent;
import js.html.Element;
import js.html.Event;
import js.html.MouseScrollEvent;
import js.html.Window;

/**
 * ...
 * @author Shareef Raheem
 */
class Main 
{
	static function main() 
	{
		Browser.window.addEventListener("devicemotion", function(evt:DeviceMotionEvent)
		{
			/*
			var z    = evt.rotationRate.alpha;
			var x    = evt.rotationRate.beta;
			var y    = evt.rotationRate.gamma;
			
			trace(evt);
			
			var article = Browser.document.getElementsByTagName("article").item(0);
			
			article.innerHTML += "<p>X = " + x + "</p>" +  evt.accelerationIncludingGravity.x;
			article.innerHTML += "<p>Y = " + y + "</p>" +  evt.accelerationIncludingGravity.y;
			article.innerHTML += "<p>Z = " + z + "</p>" +  evt.accelerationIncludingGravity.z;
			*/
		}, true);
		
		// Reg EX: .replace(/([\d.]+)(px|pt|em|%)/,'$1');
		
		// Browser.window.addEventListener("scroll", Main.onScroll, true);
		
		Browser.window.onload = function()
		{
			Tweener.init(Browser.window);
			
			//*
			Tweener.add(Browser.document.getElementById("shareef"), { loop:true })
			.to(new AnimationStep({ y: 100 		}, 2300, Easing.easeInOutSine))
			.to(new AnimationStep({ y: 170		}, 2000, Easing.easeInOutSine));
			//*/
			if (Main.getFileName() == /*"portfolio-viewer.html"*/"index.html")
			{
				var hash = Browser.window.location.hash;
				
				Photos.init("illustration");
				Photos.init("design");
				Photos.init("animation");
				Links.init("web");
				Links.init("game");
				
				if (hash == "#illustration" || hash == "#design" || hash == "#animation")
				{
					Photos.init(hash.substring(1, hash.length));
				}
				else if (hash == "#web" || hash == "#game")
				{
					Links.init(hash.substring(1, hash.length));
				}
			}
			else if (Main.getFileName() == "index.html" || Main.getFileName() == "")
			{
				/*
				Tweener.add(Browser.document.getElementById("p2"), { loop:true })
				.to(new AnimationStep({ y: -50 		}, 2500, Easing.easeInOutSine))
				.to(new AnimationStep({ y: 0		}, 2000, Easing.easeInOutSine));
				
				Tweener.add(Browser.document.getElementById("p3"), { loop:true })
				.to(new AnimationStep({ y: -50 		}, 4000, Easing.easeInOutSine))
				.to(new AnimationStep({ y: 0		}, 2500, Easing.easeInOutSine));
				
				Tweener.add(Browser.document.getElementById("p4"), { loop:true })
				.to(new AnimationStep({ y: -50 		}, 5000, Easing.easeInOutSine))
				.to(new AnimationStep({ y: 0		}, 3000, Easing.easeInOutSine));
				*/
			}
			
			
			// Hamburger Menu Setup
			
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