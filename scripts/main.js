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

window.addEventListener("load", init, false);