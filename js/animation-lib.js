// Generated by Haxe 4.0.0-rc.2+77068e10c
(function ($global) { "use strict";
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.remove = function(a,obj) {
	var i = a.indexOf(obj);
	if(i == -1) {
		return false;
	}
	a.splice(i,1);
	return true;
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		var e1 = ((e) instanceof js__$Boot_HaxeError) ? e.val : e;
		return null;
	}
};
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) {
		return null;
	} else {
		var tmp1;
		if(o.__properties__) {
			tmp = o.__properties__["get_" + field];
			tmp1 = tmp;
		} else {
			tmp1 = false;
		}
		if(tmp1) {
			return o[tmp]();
		} else {
			return o[field];
		}
	}
};
Reflect.setProperty = function(o,field,value) {
	var tmp;
	var tmp1;
	if(o.__properties__) {
		tmp = o.__properties__["set_" + field];
		tmp1 = tmp;
	} else {
		tmp1 = false;
	}
	if(tmp1) {
		o[tmp](value);
	} else {
		o[field] = value;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var com_blufedora_Animation = function(target,options) {
	this.target = target;
	this.props = options;
	this.steps = [];
	this._index = 0;
	this._deltaTime = 0;
};
com_blufedora_Animation.__name__ = true;
com_blufedora_Animation.prototype = {
	to: function(step) {
		step.init(this.target);
		this.steps.push(step);
		return this;
	}
	,wait: function(ms) {
		return this.to(new com_blufedora_AnimationStep({ },ms,com_blufedora_Easing.easeLinear));
	}
	,update: function(ms) {
		this._deltaTime += ms;
		if(this.steps.length > 0 && this._index >= 0) {
			var step = this.steps[this._index];
			if(step != null) {
				if(this._deltaTime / step.time > 1.0) {
					if(this.incIndex()) {
						step = this.steps[this._index];
					} else {
						step = null;
					}
				}
			} else {
				this.setIndex(-1);
			}
			if(step != null) {
				var timeTot = step.time;
				var _g = 0;
				var _g1 = Reflect.fields(step.properties);
				while(_g < _g1.length) {
					var field = _g1[_g];
					++_g;
					var startVal = Reflect.field(step.startProps,field);
					var finalVal = Reflect.field(step.properties,field);
					var deltaValue = finalVal - startVal;
					var value = step.easing(this._deltaTime,startVal,deltaValue,timeTot);
					Reflect.setProperty(this.target,field,value);
				}
			}
		}
	}
	,incIndex: function() {
		return this.setIndex(this._index + 1);
	}
	,setIndex: function(value) {
		this._index = value;
		this._deltaTime = 0.0;
		if(this._index >= this.steps.length) {
			var newIndex = this.props.loop ? 0 : -1;
			return this.setIndex(newIndex);
		} else if(this._index < 0) {
			com_blufedora_Tweener.remove(this);
			return false;
		}
		this.steps[this._index].init(this.target);
		return true;
	}
	,__class__: com_blufedora_Animation
};
var com_blufedora_AnimationStep = function(properties,time,easeFunc) {
	this.properties = properties;
	this.startProps = { };
	this.easing = easeFunc;
	this.time = time;
	this._fields = Reflect.fields(this.properties);
};
com_blufedora_AnimationStep.__name__ = true;
com_blufedora_AnimationStep.prototype = {
	init: function(target) {
		var _g = 0;
		var _g1 = this._fields;
		while(_g < _g1.length) {
			var field = _g1[_g];
			++_g;
			this.startProps[field] = Reflect.getProperty(target,field);
		}
	}
	,__class__: com_blufedora_AnimationStep
};
var com_blufedora_Easing = function() { };
com_blufedora_Easing.__name__ = true;
com_blufedora_Easing.easeLinear = function(t,b,c,d) {
	return c * t / d + b;
};
com_blufedora_Easing.easeInSine = function(t,b,c,d) {
	return -c * Math.cos(t / d * com_blufedora_Easing.PI_D2) + c + b;
};
com_blufedora_Easing.easeOutSine = function(t,b,c,d) {
	return c * Math.sin(t / d * com_blufedora_Easing.PI_D2) + b;
};
com_blufedora_Easing.easeInOutSine = function(t,b,c,d) {
	return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
};
com_blufedora_Easing.easeInQuint = function(t,b,c,d) {
	return c * (t /= d) * t * t * t * t + b;
};
com_blufedora_Easing.easeOutQuint = function(t,b,c,d) {
	t = t / d - 1;
	return c * (t * t * t * t * t + 1) + b;
};
com_blufedora_Easing.easeInOutQuint = function(t,b,c,d) {
	if((t /= d / 2) < 1) {
		return c / 2 * t * t * t * t * t + b;
	}
	return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
};
com_blufedora_Easing.easeInQuart = function(t,b,c,d) {
	return c * (t /= d) * t * t * t + b;
};
com_blufedora_Easing.easeOutQuart = function(t,b,c,d) {
	t = t / d - 1;
	return -c * (t * t * t * t - 1) + b;
};
com_blufedora_Easing.easeInOutQuart = function(t,b,c,d) {
	if((t /= d / 2) < 1) {
		return c / 2 * t * t * t * t + b;
	}
	return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
};
com_blufedora_Easing.easeInQuad = function(t,b,c,d) {
	return c * (t /= d) * t + b;
};
com_blufedora_Easing.easeOutQuad = function(t,b,c,d) {
	return -c * (t /= d) * (t - 2) + b;
};
com_blufedora_Easing.easeInOutQuad = function(t,b,c,d) {
	if((t /= d / 2) < 1) {
		return c / 2 * t * t + b;
	}
	return -c / 2 * (--t * (t - 2) - 1) + b;
};
com_blufedora_Easing.easeInExpo = function(t,b,c,d) {
	if(t == 0) {
		return b;
	} else {
		return c * Math.pow(2,10 * (t / d - 1)) + b;
	}
};
com_blufedora_Easing.easeOutExpo = function(t,b,c,d) {
	if(t == d) {
		return b + c;
	} else {
		return c * (-Math.pow(2,-10 * t / d) + 1) + b;
	}
};
com_blufedora_Easing.easeInOutExpo = function(t,b,c,d) {
	if(t == 0) {
		return b;
	}
	if(t == d) {
		return b + c;
	}
	if((t /= d / 2) < 1) {
		return c / 2 * Math.pow(2,10 * (t - 1)) + b;
	}
	return c / 2 * (-Math.pow(2,-10 * --t) + 2) + b;
};
com_blufedora_Easing.easeInElastic = function(t,b,c,d,a,p) {
	var s;
	if(t == 0) {
		return b;
	}
	if((t /= d) == 1) {
		return b + c;
	}
	if(p == null) {
		p = d * .3;
	}
	if(a == null || a < Math.abs(c)) {
		a = c;
		s = p / 4;
	} else {
		s = p / com_blufedora_Easing.PI_M2 * Math.asin(c / a);
	}
	return -(a * Math.pow(2,10 * --t) * Math.sin((t * d - s) * com_blufedora_Easing.PI_M2 / p)) + b;
};
com_blufedora_Easing.easeOutElastic = function(t,b,c,d,a,p) {
	var s;
	if(t == 0) {
		return b;
	}
	if((t /= d) == 1) {
		return b + c;
	}
	if(p == null) {
		p = d * .3;
	}
	if(a == null || a < Math.abs(c)) {
		a = c;
		s = p / 4;
	} else {
		s = p / com_blufedora_Easing.PI_M2 * Math.asin(c / a);
	}
	return a * Math.pow(2,-10 * t) * Math.sin((t * d - s) * com_blufedora_Easing.PI_M2 / p) + c + b;
};
com_blufedora_Easing.easeInOutElastic = function(t,b,c,d,a,p) {
	var s;
	if(t == 0) {
		return b;
	}
	if((t /= d / 2) == 2) {
		return b + c;
	}
	if(p == null) {
		p = d * 0.44999999999999996;
	}
	if(a == null || a < Math.abs(c)) {
		a = c;
		s = p / 4;
	} else {
		s = p / com_blufedora_Easing.PI_M2 * Math.asin(c / a);
	}
	if(t < 1) {
		return -.5 * (a * Math.pow(2,10 * --t) * Math.sin((t * d - s) * com_blufedora_Easing.PI_M2 / p)) + b;
	}
	return a * Math.pow(2,-10 * --t) * Math.sin((t * d - s) * com_blufedora_Easing.PI_M2 / p) * .5 + c + b;
};
com_blufedora_Easing.easeInCircular = function(t,b,c,d) {
	return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
};
com_blufedora_Easing.easeOutCircular = function(t,b,c,d) {
	t = t / d - 1;
	return c * Math.sqrt(1 - t * t) + b;
};
com_blufedora_Easing.easeInOutCircular = function(t,b,c,d) {
	if((t /= d / 2) < 1) {
		return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
	}
	return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
};
com_blufedora_Easing.easeInBack = function(t,b,c,d,s) {
	if(s == null) {
		s = 1.70158;
	}
	return c * (t /= d) * t * ((s + 1) * t - s) + b;
};
com_blufedora_Easing.easeOutBack = function(t,b,c,d,s) {
	if(s == null) {
		s = 1.70158;
	}
	t = t / d - 1;
	return c * (t * t * ((s + 1) * t + s) + 1) + b;
};
com_blufedora_Easing.easeInOutBack = function(t,b,c,d,s) {
	if(s == null) {
		s = 1.70158;
	}
	if((t /= d / 2) < 1) {
		return c / 2 * (t * t * (((s *= 1.525) + 1) * t - s)) + b;
	}
	return c / 2 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b;
};
com_blufedora_Easing.easeInBounce = function(t,b,c,d) {
	return c - com_blufedora_Easing.easeOutBounce(d - t,0,c,d) + b;
};
com_blufedora_Easing.easeOutBounce = function(t,b,c,d) {
	if((t /= d) < 0.36363636363636365) {
		return c * (7.5625 * t * t) + b;
	} else if(t < 0.72727272727272729) {
		return c * (7.5625 * (t -= 0.54545454545454541) * t + .75) + b;
	} else if(t < 0.90909090909090906) {
		return c * (7.5625 * (t -= 0.81818181818181823) * t + .9375) + b;
	} else {
		return c * (7.5625 * (t -= 0.95454545454545459) * t + .984375) + b;
	}
};
com_blufedora_Easing.easeInOutBounce = function(t,b,c,d) {
	if(t < d / 2) {
		return com_blufedora_Easing.easeInBounce(t * 2,0,c,d) * .5 + b;
	} else {
		return com_blufedora_Easing.easeOutBounce(t * 2 - d,0,c,d) * .5 + c * .5 + b;
	}
};
com_blufedora_Easing.easeInCubic = function(t,b,c,d) {
	return c * (t /= d) * t * t + b;
};
com_blufedora_Easing.easeOutCubic = function(t,b,c,d) {
	t = t / d - 1;
	return c * (t * t * t + 1) + b;
};
com_blufedora_Easing.easeInOutCubic = function(t,b,c,d) {
	if((t /= d / 2) < 1) {
		return c / 2 * t * t * t + b;
	}
	return c / 2 * ((t -= 2) * t * t + 2) + b;
};
var com_blufedora_JSAnimObject = function(object) {
	this._object = object;
};
com_blufedora_JSAnimObject.__name__ = true;
com_blufedora_JSAnimObject.prototype = {
	get_x: function() {
		return com_blufedora_TweenUtils.parseFloat(this._object,"left");
	}
	,set_x: function(value) {
		this._object.style.left = value + "px";
		return value;
	}
	,get_y: function() {
		return com_blufedora_TweenUtils.parseFloat(this._object,"top");
	}
	,set_y: function(value) {
		this._object.style.top = value + "px";
		return value;
	}
	,__class__: com_blufedora_JSAnimObject
	,__properties__: {set_y:"set_y",get_y:"get_y",set_x:"set_x",get_x:"get_x"}
};
var com_blufedora_Main = function() { };
com_blufedora_Main.__name__ = true;
com_blufedora_Main.main = function() {
	window.onload = function() {
		com_blufedora_Tweener.init(window);
		var name_logo = window.document.getElementById("shareef");
		if(name_logo != null) {
			com_blufedora_Tweener.add(name_logo,{ loop : true}).to(new com_blufedora_AnimationStep({ y : 170},2300,com_blufedora_Easing.easeInOutSine)).to(new com_blufedora_AnimationStep({ y : 200},2000,com_blufedora_Easing.easeInOutSine));
		}
		var element = window.document.getElementById("portfolio");
		var xobj = new XMLHttpRequest();
		xobj.overrideMimeType("application/json");
		xobj.open("GET","data/" + "portfolio" + ".json",true);
		xobj.onreadystatechange = function() {
			if(xobj.readyState == 4 && xobj.status == 200) {
				var data = JSON.parse(xobj.responseText);
				var _g = 0;
				var _g1 = data.length;
				while(_g < _g1) {
					var i = _g++;
					var data1 = data[i];
					var ele = window.document.createElement("div");
					ele.classList.add("portfolio_cover");
					var circle_hover = window.document.createElement("div");
					circle_hover.classList.add("circle_hover");
					var portfolio_look_icon = window.document.createElement("div");
					portfolio_look_icon.classList.add("portfolio_look_icon");
					var portfolio_image = window.document.createElement("div");
					portfolio_image.classList.add("portfolio_image");
					portfolio_image.style.backgroundImage = "url('" + Std.string(data1.thumbnail) + "')";
					var portfolio_text = window.document.createElement("div");
					portfolio_text.classList.add("portfolio_text");
					portfolio_text.innerHTML = data1.title;
					var fields = Reflect.fields(data1);
					var _g2 = 0;
					while(_g2 < fields.length) {
						var f = fields[_g2];
						++_g2;
						ele.dataset[f] = Reflect.field(data1,f);
					}
					ele.appendChild(circle_hover);
					circle_hover.appendChild(portfolio_look_icon);
					circle_hover.appendChild(portfolio_image);
					circle_hover.appendChild(portfolio_text);
					ele.addEventListener("click",com_blufedora_portfolio_LoadPortfolio.onClick,false);
					element.appendChild(ele);
					com_blufedora_portfolio_LoadPortfolio.s_Items.push(ele);
				}
			}
		};
		xobj.send(null);
		var menu = window.document.getElementById("menu");
		var side_panel = window.document.getElementById("side_panel");
		var main_article = window.document.getElementById("main_article");
		if(menu != null && side_panel != null && main_article != null) {
			var callback = function(evt) {
				(js_Boot.__cast(evt.currentTarget , HTMLElement)).classList.toggle("opened");
				side_panel.classList.toggle("opened");
				main_article.classList.toggle("opened");
			};
			menu.onclick = callback;
		}
	};
	window.onunload = function() {
		com_blufedora_Tweener.destroy();
	};
};
com_blufedora_Main.getFileName = function() {
	var url = window.document.location.href;
	url = url.substring(0,url.indexOf("#") == -1 ? url.length : url.indexOf("#"));
	url = url.substring(0,url.indexOf("?") == -1 ? url.length : url.indexOf("?"));
	url = url.substring(url.lastIndexOf("/") + 1,url.length);
	return url;
};
var com_blufedora_TweenUtils = function() { };
com_blufedora_TweenUtils.__name__ = true;
com_blufedora_TweenUtils.parse = function(target,prop) {
	var val = parseInt(window.getComputedStyle(target).getPropertyValue(prop),10);
	if(val == NaN) {
		return 0;
	} else {
		return val;
	}
};
com_blufedora_TweenUtils.parseFloat = function(target,prop) {
	var val = parseFloat(window.getComputedStyle(target).getPropertyValue(prop));
	if(val == NaN) {
		return 0.0;
	} else {
		return val;
	}
};
var com_blufedora_Tweener = function() { };
com_blufedora_Tweener.__name__ = true;
com_blufedora_Tweener.init = function($window) {
	com_blufedora_Tweener.anims = [];
	com_blufedora_Tweener.toRemove = [];
	com_blufedora_Tweener.start = null;
	com_blufedora_Tweener.handle = 0;
	
			(function() 
			{
				var vendors = ['ms', 'moz', 'webkit', 'o'];
				var lastTime = 0;
				
				for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) 
				{
					window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame'];
					window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] 
											   || window[vendors[x] + 'CancelRequestAnimationFrame'];
				}
				
				if (!window.requestAnimationFrame) 
				{
					window.requestAnimationFrame = function(callback, element) 
					{
						var currTime = new Date().getTime();
						var timeToCall = Math.max(0, 16 - (currTime - lastTime));
						
						var id = window.setTimeout(
							function() { 
								callback(currTime + timeToCall); 
							}, 
							timeToCall);
							
						lastTime = currTime + timeToCall;
						return id;
					};
				}
				
				if (!window.cancelAnimationFrame) 
				{
					window.cancelAnimationFrame = function(id) 
					{
						clearTimeout(id);
					};
				}
			}());
		;
	com_blufedora_Tweener.updateTweens(0);
	return true;
};
com_blufedora_Tweener.add = function(target,params) {
	var anim = new com_blufedora_Animation(new com_blufedora_JSAnimObject(target),params);
	com_blufedora_Tweener.anims.push(anim);
	return anim;
};
com_blufedora_Tweener.remove = function(anim) {
	com_blufedora_Tweener.toRemove.push(anim);
};
com_blufedora_Tweener.updateTweens = function(timestamp) {
	if(com_blufedora_Tweener.start == null) {
		com_blufedora_Tweener.start = timestamp;
	}
	var progress = timestamp - com_blufedora_Tweener.start;
	var _g = 0;
	var _g1 = com_blufedora_Tweener.toRemove;
	while(_g < _g1.length) {
		var anim = _g1[_g];
		++_g;
		HxOverrides.remove(com_blufedora_Tweener.anims,anim);
	}
	com_blufedora_Tweener.toRemove.splice(0,com_blufedora_Tweener.toRemove.length);
	var _g2 = 0;
	var _g3 = com_blufedora_Tweener.anims;
	while(_g2 < _g3.length) {
		var anim1 = _g3[_g2];
		++_g2;
		anim1.update(progress);
	}
	com_blufedora_Tweener.start = timestamp;
	com_blufedora_Tweener.handle = window.requestAnimationFrame(com_blufedora_Tweener.updateTweens);
};
com_blufedora_Tweener.destroy = function() {
	window.cancelAnimationFrame(com_blufedora_Tweener.handle);
};
var com_blufedora_portfolio_LoadPortfolio = function() { };
com_blufedora_portfolio_LoadPortfolio.__name__ = true;
com_blufedora_portfolio_LoadPortfolio.setImage = function(idx) {
	if(idx == com_blufedora_portfolio_LoadPortfolio.s_Items.length) {
		idx = 0;
	} else if(idx == -1) {
		idx = 0;
	}
	var data = (js_Boot.__cast(com_blufedora_portfolio_LoadPortfolio.s_Items[idx] , HTMLDivElement)).dataset;
	var tmp = data.cover != null ? data.cover : data.thumbnail;
	com_blufedora_portfolio_Popup.get_popup().content.style.backgroundImage = "url(" + tmp + ")";
	com_blufedora_portfolio_Popup.get_popup().setText(data.title,data.comments);
	if(data.url != null && data.button != null) {
		com_blufedora_portfolio_Popup.get_popup().text.innerHTML += "<hr>";
		var tmp1 = com_blufedora_portfolio_Popup.get_popup().text;
		var url = data.url;
		var btn_txt = data.button;
		var ele = window.document.createElement("div");
		ele.classList.add("menu-item");
		var a = window.document.createElement("a");
		a.innerHTML = btn_txt;
		a.href = url;
		a.target = "_blank";
		ele.appendChild(a);
		tmp1.appendChild(ele);
		var clear_div = window.document.createElement("div");
		clear_div.className = "clear";
		com_blufedora_portfolio_Popup.get_popup().text.appendChild(clear_div);
	}
	com_blufedora_portfolio_Popup.get_popup().show();
	com_blufedora_portfolio_LoadPortfolio.s_CurrentIndex = idx;
};
com_blufedora_portfolio_LoadPortfolio.onClick = function(e) {
	com_blufedora_portfolio_LoadPortfolio.setImage(com_blufedora_portfolio_LoadPortfolio.s_Items.indexOf(e.currentTarget));
};
com_blufedora_portfolio_LoadPortfolio.makeLinkedBtn = function(url,btn_txt) {
	var ele = window.document.createElement("div");
	ele.classList.add("menu-item");
	var a = window.document.createElement("a");
	a.innerHTML = btn_txt;
	a.href = url;
	a.target = "_blank";
	ele.appendChild(a);
	return ele;
};
com_blufedora_portfolio_LoadPortfolio.makeButton = function(element,data) {
	var ele = window.document.createElement("div");
	ele.classList.add("portfolio_cover");
	var circle_hover = window.document.createElement("div");
	circle_hover.classList.add("circle_hover");
	var portfolio_look_icon = window.document.createElement("div");
	portfolio_look_icon.classList.add("portfolio_look_icon");
	var portfolio_image = window.document.createElement("div");
	portfolio_image.classList.add("portfolio_image");
	portfolio_image.style.backgroundImage = "url('" + Std.string(data.thumbnail) + "')";
	var portfolio_text = window.document.createElement("div");
	portfolio_text.classList.add("portfolio_text");
	portfolio_text.innerHTML = data.title;
	var fields = Reflect.fields(data);
	var _g = 0;
	while(_g < fields.length) {
		var f = fields[_g];
		++_g;
		ele.dataset[f] = Reflect.field(data,f);
	}
	ele.appendChild(circle_hover);
	circle_hover.appendChild(portfolio_look_icon);
	circle_hover.appendChild(portfolio_image);
	circle_hover.appendChild(portfolio_text);
	ele.addEventListener("click",com_blufedora_portfolio_LoadPortfolio.onClick,false);
	element.appendChild(ele);
	com_blufedora_portfolio_LoadPortfolio.s_Items.push(ele);
};
com_blufedora_portfolio_LoadPortfolio.load = function(path,element) {
	var xobj = new XMLHttpRequest();
	xobj.overrideMimeType("application/json");
	xobj.open("GET","data/" + path + ".json",true);
	xobj.onreadystatechange = function() {
		if(xobj.readyState == 4 && xobj.status == 200) {
			var data = JSON.parse(xobj.responseText);
			var _g = 0;
			var _g1 = data.length;
			while(_g < _g1) {
				var i = _g++;
				var data1 = data[i];
				var ele = window.document.createElement("div");
				ele.classList.add("portfolio_cover");
				var circle_hover = window.document.createElement("div");
				circle_hover.classList.add("circle_hover");
				var portfolio_look_icon = window.document.createElement("div");
				portfolio_look_icon.classList.add("portfolio_look_icon");
				var portfolio_image = window.document.createElement("div");
				portfolio_image.classList.add("portfolio_image");
				portfolio_image.style.backgroundImage = "url('" + Std.string(data1.thumbnail) + "')";
				var portfolio_text = window.document.createElement("div");
				portfolio_text.classList.add("portfolio_text");
				portfolio_text.innerHTML = data1.title;
				var fields = Reflect.fields(data1);
				var _g2 = 0;
				while(_g2 < fields.length) {
					var f = fields[_g2];
					++_g2;
					ele.dataset[f] = Reflect.field(data1,f);
				}
				ele.appendChild(circle_hover);
				circle_hover.appendChild(portfolio_look_icon);
				circle_hover.appendChild(portfolio_image);
				circle_hover.appendChild(portfolio_text);
				ele.addEventListener("click",com_blufedora_portfolio_LoadPortfolio.onClick,false);
				element.appendChild(ele);
				com_blufedora_portfolio_LoadPortfolio.s_Items.push(ele);
			}
		}
	};
	xobj.send(null);
};
var com_blufedora_portfolio_Popup = function() {
	var _gthis = this;
	var doc = window.document;
	this.popUp = doc.getElementById("pop-up");
	this.bg = doc.getElementById("pop-up-bg");
	this.prev = doc.getElementById("pop-up-prev");
	this.content = doc.getElementById("pop-up-content");
	this.text = doc.getElementById("pop-up-text");
	this.next = doc.getElementById("pop-up-next");
	this.prev.onclick = function() {
		com_blufedora_portfolio_LoadPortfolio.setImage(com_blufedora_portfolio_LoadPortfolio.s_CurrentIndex - 1);
	};
	this.next.onclick = function() {
		com_blufedora_portfolio_LoadPortfolio.setImage(com_blufedora_portfolio_LoadPortfolio.s_CurrentIndex + 1);
	};
	this.bg.onclick = function() {
		_gthis.popUp.classList.add("hidden");
	};
};
com_blufedora_portfolio_Popup.__name__ = true;
com_blufedora_portfolio_Popup.__properties__ = {get_popup:"get_popup"};
com_blufedora_portfolio_Popup.get_popup = function() {
	if(com_blufedora_portfolio_Popup.popup == null) {
		com_blufedora_portfolio_Popup.popup = new com_blufedora_portfolio_Popup();
	}
	return com_blufedora_portfolio_Popup.popup;
};
com_blufedora_portfolio_Popup.prototype = {
	setText: function(title,txt) {
		if(this.text != null) {
			if(txt != null) {
				this.text.innerHTML = "<h4>" + title + "</h4><hr>\n" + txt;
				this.text.classList.remove("hidden");
			} else {
				this.text.innerHTML = "";
				this.text.classList.add("hidden");
			}
		}
	}
	,show: function() {
		this.popUp.classList.remove("hidden");
	}
	,__class__: com_blufedora_portfolio_Popup
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	if(Error.captureStackTrace) {
		Error.captureStackTrace(this,js__$Boot_HaxeError);
	}
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if(((o) instanceof Array) && o.__enum__ == null) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var n = e.__constructs__[o._hx_index];
			var con = e[n];
			if(con.__params__) {
				s += "\t";
				var tmp = n + "(";
				var _g = [];
				var _g1 = 0;
				var _g2 = con.__params__;
				while(_g1 < _g2.length) {
					var p = _g2[_g1];
					++_g1;
					_g.push(js_Boot.__string_rec(o[p],s));
				}
				return tmp + _g.join(",") + ")";
			} else {
				return n;
			}
		}
		if(((o) instanceof Array)) {
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g3 = 0;
			var _g11 = l;
			while(_g3 < _g11) {
				var i1 = _g3++;
				str += (i1 > 0 ? "," : "") + js_Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e1 ) {
			var e2 = ((e1) instanceof js__$Boot_HaxeError) ? e1.val : e1;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var k = null;
		var str1 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str1.length != 2) {
			str1 += ", \n";
		}
		str1 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str1 += "\n" + s + "}";
		return str1;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	if(Object.prototype.hasOwnProperty.call(cc,"__interfaces__")) {
		var intf = cc.__interfaces__;
		var _g = 0;
		var _g1 = intf.length;
		while(_g < _g1) {
			var i = _g++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		return ((o) instanceof Array);
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return o != null;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return ((o | 0) === o);
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(((o) instanceof cl)) {
					return true;
				}
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(((o) instanceof cl)) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		if(o.__enum__ != null) {
			return $hxEnums[o.__enum__] == cl;
		} else {
			return false;
		}
	}
};
js_Boot.__cast = function(o,t) {
	if(o == null || js_Boot.__instanceof(o,t)) {
		return o;
	} else {
		throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { };
var Dynamic = { };
var Float = Number;
var Bool = Boolean;
var Class = { };
var Enum = { };
Object.defineProperty(js__$Boot_HaxeError.prototype,"message",{ get : function() {
	return String(this.val);
}});
js_Boot.__toStr = ({ }).toString;
com_blufedora_Easing.PI_M2 = Math.PI * 2.0;
com_blufedora_Easing.PI_D2 = Math.PI * 0.5;
com_blufedora_portfolio_LoadPortfolio.s_Items = [];
com_blufedora_portfolio_LoadPortfolio.s_CurrentIndex = 0;
com_blufedora_Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
