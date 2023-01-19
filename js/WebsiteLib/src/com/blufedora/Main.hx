/******************************************************************************/
/*!
 * @file   Main.hx
 * @author Shareef Abdoul-Raheem (http://blufedora.github.io/)
 * @brief
 *   Main entry point to the my website's interativity.
 *
 * @version 0.0.1
 * @date    2020-12-25
 *
 * @copyright Copyright (c) 2019-2020
 */
/******************************************************************************/
package com.blufedora;

import com.blufedora.io.File;
import js.Browser;
import js.html.Event;

/**
 * Main class that kicks off the rest of what this website does.
 * @author Shareef Raheem
 */
class Main
{
  public static function main()
  {
    var window = Browser.window;

    window.addEventListener("load", onLoad);
    window.addEventListener("unload", onUnLoad);
  }

  private static function onLoad()
  {
    var doc = Browser.document;
    
    // Load Up Portfolio Content
    var portfolio_container = doc.getElementById("portfolio-container");

    if (portfolio_container != null)
    {
      File.loadJson(
        "portfolio/portfolio.json",
        function(json_text)
        {
          var items:Array<Dynamic> = haxe.Json.parse(json_text);
          
          for (item in items)
          {
            var folder:String     = item.folder;
            var size:Int          = item.size;
            var brief_text:String = item.brief;
            var element           = doc.createElement("div");
            var brief_block       = doc.createElement("div");
            var brief_text_div    = doc.createElement("div");
            
            element.classList.add("portfolio-block" + size);
            element.style.backgroundImage = "url(/portfolio/" + folder + "/thumbnail.png)";
            element.addEventListener("click", onPortfolioItemClicked);
            
            brief_text_div.innerText = brief_text;
            brief_text_div.classList.add("portfolio-brief-text");
            brief_block.appendChild(brief_text_div);
            
            brief_block.classList.add("portfolio-brief");
            element.appendChild(brief_block);
            
            brief_block.classList.add("no-select");
            
            if (item.url != null || item.post != null)
            {              
              var learn_more       = doc.createElement("a");
              
              
              if (item.post != null)
              {
                learn_more.setAttribute("href", "blog-post.html?post=" + item.post);
                learn_more.innerText = "Read Blog Post";
              }
              else
              {
                learn_more.setAttribute("href", item.url);
                learn_more.innerText = "Visit Page";
              }
              
              learn_more.classList.add("learn-more");
              brief_block.appendChild(learn_more);
            }
            
            portfolio_container.appendChild(element);
          }
          
        }
      );
    }

    /*
    var name_logo = Browser.document.getElementById("shareef");

    if (name_logo != null)
    {
      var floating_bounce_keyframes:Array<Dynamic> = 
      [
        { marginTop: "10px" },
        { marginTop: "-5px" },
      ];
      
      var animation_options:KeyframeAnimationOptions = 
      {
        iterations:     Math.POSITIVE_INFINITY,
        iterationStart: 0,
        delay:          0,
        endDelay:       0,
        direction:      PlaybackDirection.ALTERNATE,
        duration:       1000,
        fill:           js.html.FillMode.BOTH,
        easing:         'ease-in-out',
      };
      
      name_logo.animate(floating_bounce_keyframes, animation_options);
    }
  */
    
    // Setup Side Bar Menu

    var menu = doc.getElementById("menu");
    var side_panel = doc.getElementById("side_panel");
    var main_article = doc.getElementById("main_article");

    if (menu != null && side_panel != null && main_article != null)
    {
      var callback = function(evt)
      {
        menu.classList.toggle("opened");
        side_panel.classList.toggle("opened");
        main_article.classList.toggle("opened");
      };

      menu.onclick = callback;
    }
  }
  
  private static function onPortfolioItemClicked(evt:Event):Void
  {
    var button = cast(evt.currentTarget, js.html.Element);
    
    button.classList.toggle("opened");
  }

  private static function onUnLoad():Void
  {
  }

  private static function getFileName():String
  {
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
