/******************************************************************************/
/*!
 * @file   Main.hx
 * @author Shareef Abdoul-Raheem (http://blufedora.github.io/)
 * @date   2020-12-25
 * @brief
 *   Main entry point to the my website's interativity.
 *
 * @copyright Copyright (c) 2019-2020
 */
/******************************************************************************/
package blufedora;

import js.Browser;
import js.html.Event;
import js.html.XMLHttpRequest;

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
  }

  private static inline function loadJson(path:String, callback:String->Void)
  {
    var xobj = new XMLHttpRequest();
    
    xobj.overrideMimeType("application/json");
    xobj.open("GET", path, true);
    
    xobj.onreadystatechange = function () 
    {
      if (xobj.readyState == XMLHttpRequest.DONE && xobj.status == 200) 
      {
        callback(xobj.responseText);
      }
    };
    
    xobj.send(null);  
  }

  private static function onLoad()
  {
    var doc = Browser.document;
    
    // Load Up Portfolio Content
    var portfolio_container = doc.getElementById("portfolio-container");

    if (portfolio_container != null)
    {
      loadJson(
        "portfolio/portfolio.json",
        function(json_text)
        {
          var items:Array<Dynamic> = haxe.Json.parse(json_text);
          
          for (item in items)
          {
            var folder:String     = item.folder;
            var size:String       = item.size;
            var height:Null<String>  = item.height;
            var brief_text:String = item.brief;
            var element           = doc.createElement("div");
            var brief_block       = doc.createElement("div");
            var brief_text_div    = doc.createElement("div");
            
            element.classList.add("portfolio-block");
            element.classList.add(size);

            if (height != null)
            {
              element.classList.add(height);
            }

            element.style.backgroundImage = 'url(portfolio/$folder/thumbnail.png)';

    
            element.addEventListener("click", onPortfolioItemClicked);
            
            brief_text_div.innerText = brief_text;
            brief_text_div.classList.add("portfolio-brief-text");
            brief_block.appendChild(brief_text_div);
            
            brief_block.classList.add("portfolio-brief");
            element.appendChild(brief_block);
            
            brief_block.classList.add("no-select");
            
            if (item.url != null || item.post != null)
            {              
              var learn_more = doc.createElement("a");
              
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
  }
  
  private static function onPortfolioItemClicked(evt:Event):Void
  {
    var button = cast(evt.currentTarget, js.html.Element);
    
    button.classList.toggle("opened");
  }
}
