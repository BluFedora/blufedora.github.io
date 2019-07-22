package com.blufedora.portfolio;
import js.Browser;
import js.html.DivElement;
import js.html.HtmlElement;
import js.html.ImageElement;
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
		setImage(images.indexOf(e.currentTarget));
	}
	
	public static function setImage(i)
	{
		if (i >= Photos.images.length) {
			i = 0;
		}
		
		if (i < 0) {
			i = Photos.images.length - 1;
		}
		
		Popup.popup.content.style.backgroundImage = "url(" + cast(images[i], DivElement).dataset.image + ")";
		Popup.popup.show();
		index = i;
	}
	
	/*
	<div class="portfolio_cover">
		<div class="circle_hover">
			<div class="portfolio_look_icon"></div>
			<div class="portfolio_image" style="background-image:url(images/blufedora_icon.png);">
			</div>
			<div class="portfolio_text">Protfolio Piece !</div>
		</div>
	</div>
	*/
	private static inline function makeButton(element, data:Dynamic):Void
	{
		var ele = Browser.document.createElement("div");
		ele.classList.add("portfolio_cover");
		var circle_hover = Browser.document.createElement("div");
		circle_hover.classList.add("circle_hover");
		var portfolio_look_icon = Browser.document.createElement("div");
		portfolio_look_icon.classList.add("portfolio_look_icon");
		var portfolio_image = Browser.document.createElement("div");
		portfolio_image.classList.add("portfolio_image");
		portfolio_image.style.backgroundImage = "url('" + data.image + "')";
		var portfolio_text = Browser.document.createElement("div");
		portfolio_text.classList.add("portfolio_text");
		portfolio_text.innerHTML = data.title;
		
		ele.dataset.image = data.image;
		
		ele.appendChild(circle_hover);
		circle_hover.appendChild(portfolio_look_icon);
		circle_hover.appendChild(portfolio_image);
		circle_hover.appendChild(portfolio_text);
		
		ele.addEventListener("click", Photos.onClick, false);
		
		element.appendChild(ele);
		images.push(ele);
	}
	
	public static function init(thing:String):Void
	{
		var element = Browser.document.getElementById("portfolio");
		
		if (element != null) {
			LoadPortfolio.load("data/portfolio_" + thing + ".json", element, Photos.makeButton);
		}
	}
}