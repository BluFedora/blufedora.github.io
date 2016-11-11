//* CONSTANTS *//
var kHomeLink       = "index.html";
var kPortfolioLink  = "portfolio.html";
var kYoutubeLink    = "https://www.youtube.com/channel/UCV_Vr7RDDFQfAH4_WIHmSfg";
var kAboutLink      = "about.html";
var kContactLink    = "contact.html";

var window          = window;
var document        = document;

function forEachClass(className, f)
{
    var elements = document.getElementsByClassName(className);

    for(var i = 0; i < elements.length; i++) 
    {
        f(elements[i]);
    }
}

function setHrefFunctor(hrefName)
{
    return function(element)
    {
        element.href = hrefName;
    };
}

function init()
{
    forEachClass(
        "youtubeLink", 
        function(element)
        {
            element.href    = kYoutubeLink;
            element.target  = "_blank";
        }
    );

    forEachClass("homeLink",        setHrefFunctor(kHomeLink));
    forEachClass("portfolioLink",   setHrefFunctor(kPortfolioLink));
    forEachClass("aboutLink",       setHrefFunctor(kAboutLink));
    forEachClass("contactLink",     setHrefFunctor(kContactLink));
};

function readTextFile(file, callback)
{
	var rawFile = new XMLHttpRequest();
	rawFile.open("GET", file, true);
	rawFile.onreadystatechange = function ()
	{
		if(rawFile.readyState === 4)
		{
			if(rawFile.status === 200 || rawFile.status == 0)
			{
				var allText = rawFile.responseText;
				callback(allText);
			}
		}
	}
	rawFile.send(null);
}

window.addEventListener("load", init, false);