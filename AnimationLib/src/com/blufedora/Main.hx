package com.blufedora;

import com.blufedora.portfolio.LoadPortfolio;
import js.Browser;
import js.html.Element;
import js.html.HTMLCollection;

/**
 * ...
 * @author Shareef Raheem
 */
class Main {
	static function main() {
		// Reg EX: .replace(/([\d.]+)(px|pt|em|%)/,'$1');

		Browser.window.onload = function() {
			Tweener.init(Browser.window);

			var name_logo = Browser.document.getElementById("shareef");

			if (name_logo != null) {
				Tweener.add(name_logo, {loop: true})
					.to(new AnimationStep({y: 170}, 2300, Easing.easeInOutSine))
					.to(new AnimationStep({y: 200}, 2000, Easing.easeInOutSine));
			}

			var portfolio_element = Browser.document.getElementById("portfolio");

			if (portfolio_element != null) {
				LoadPortfolio.load("portfolio", portfolio_element);
			}
			
			var menu = Browser.document.getElementById("menu");
			var side_panel = Browser.document.getElementById("side_panel");
			var main_article = Browser.document.getElementById("main_article");

			if (menu != null && side_panel != null && main_article != null) {
				var callback = function(evt) {
					menu.classList.toggle("opened");
					side_panel.classList.toggle("opened");
					main_article.classList.toggle("opened");
				};

				menu.onclick = callback;
				
				for (e in Browser.document.getElementsByClassName("menu-item"))
				{
					e.onclick = callback;
				}
			}
		};

		Browser.window.onunload = function() {
			Tweener.destroy();
		};
	}

	private static function getFileName():String {
		// this gets the full url
		var url = Browser.document.location.href;
		// this removes the anchor at the end, if there is one
		url = url.substring(0, (url.indexOf("#") == -1) ? url.length : url.indexOf("#"));
		// this removes the query after the file name, if there is one
		url = url.substring(0, (url.indexOf("?") == -1) ? url.length : url.indexOf("?"));
		// this removes everything before the last slash in the path
		url = url.substring(url.lastIndexOf("/") + 1, url.length);
		// return
		return url;
	}
}
