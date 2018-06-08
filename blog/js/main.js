window.addEventListener("load", 
function(evtLoad)
{
	var nav = document.getElementById("nav");
	
	nav.onclick = function()
	{
		//window.toggle_menu();
	};
	
	window.toggle_menu = function()
	{
		console.log("WTF");
		var nav1 = document.getElementById("nav");
		nav1.children.item(0).classList.toggle("active");
	};
	
});