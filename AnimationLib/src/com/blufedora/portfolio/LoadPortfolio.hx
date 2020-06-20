package com.blufedora.portfolio;

import haxe.Json;
import js.Browser;
import js.html.DivElement;
import js.html.Element;
import js.html.MouseEvent;
import js.html.XMLHttpRequest;

/**
 * ...
 * @author BluFedora (Shareef Raheem)
 */
class LoadPortfolio
{
	
	/*
	    <div class="menu-item"><a href="$url"> $btn_txt </a></div>
	*/
	private static inline function makeLinkedBtn(url:String, btn_txt:String):Element
	{
		var ele = Browser.document.createElement("div");
		ele.classList.add("menu-item");
		var a = Browser.document.createElement("a");
		a.innerHTML = btn_txt;
		
		untyped a.href = url;
		untyped a.target = "_blank";
		
		ele.appendChild(a);
		
		return ele;
	}

	/*
	<div class="portfolio_cover">
		<div class="circle_hover">
			<div class="portfolio_look_icon"></div>
			<div class="portfolio_image" style="background-image:url(images/blufedora_icon.png);">
			</div>
			<div class="portfolio_text">Portfolio Piece!</div>
		</div>
	</div>
	*/
	public static inline function makeButton(element:Element, data:Dynamic):Void
	{
		var ele = Browser.document.createElement("a");
		ele.classList.add("portfolio_cover");
		var circle_hover = Browser.document.createElement("div");
		circle_hover.classList.add("circle_hover");
		var portfolio_look_icon = Browser.document.createElement("div");
		portfolio_look_icon.classList.add("portfolio_look_icon");
		var portfolio_image = Browser.document.createElement("div");
		portfolio_image.classList.add("portfolio_image");
		portfolio_image.style.backgroundImage = "url('" + data.thumbnail + "')";
		var portfolio_text = Browser.document.createElement("div");
		portfolio_text.classList.add("portfolio_text");
		portfolio_text.innerHTML = data.title;
		
		var fields = Reflect.fields(data);
		
		for (f in fields)
		{
			Reflect.setField(ele.dataset, f, Reflect.field(data, f));
		}
		
		untyped ele.href = data.url;
		untyped ele.target = "_blank";
		
		ele.appendChild(circle_hover);
		circle_hover.appendChild(portfolio_look_icon);
		circle_hover.appendChild(portfolio_image);
		circle_hover.appendChild(portfolio_text);
		
		element.appendChild(ele);
	}

	public static inline function load(path:String, element:Element):Void
	{
		var xobj = new XMLHttpRequest();
		xobj.overrideMimeType("application/json");
		xobj.open("GET", "data/" + path + ".json", true);
		xobj.onreadystatechange = function()
		{
			if (xobj.readyState == 4 && xobj.status == 200)
			{
				var data:Array<Dynamic> = Json.parse(xobj.responseText);
				
				for (i in 0...data.length)
				{
					makeButton(element, data[i]);
				}
			}
		};
		xobj.send(null);
	}
}