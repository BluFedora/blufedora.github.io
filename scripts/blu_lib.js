(function () {
  var EventHandler = function () {
    this.events = [];
  };

  EventHandler.prototype.bindEvent = function (event, callback, targetElement) {
    this.unbindEvent(event, targetElement);

    targetElement.addEventListener(event, callback, false);

    this.events.push({
      type: event,
      event: callback,
      target: targetElement
    });
  };

  EventHandler.prototype.findEvent = function (event) {
    return this.events.filter(function (evt) {
      return (evt.type === event); //if event type is a match return
    }, event)[0];
  };

  EventHandler.prototype.unbindEvent = function (event, targetElement) {
    var foundEvent = this.findEvent(event);

    if (foundEvent !== undefined) {
      targetElement.removeEventListener(event, foundEvent.event, false);
    }

    //update the events array
    this.events = this.events.filter(function (evt) {
      return (evt.type !== event);
    }, event);
  };

  var DomElement = function (selector) {
    this.selector = selector || null;
    this.element = null;
    this.eventHandler = new EventHandler();
  };

  DomElement.prototype.init = function () {
    if (typeof this.selector === "string") {
      switch (this.selector[0]) {
        case '<':
          {
            var matches = this.selector.match(/<([\w-]*)>/);

            if (matches === null || matches === undefined) {
              throw 'Invalid Selector / Node';
              // return false;
            }

            var nodeName = matches[0].replace('<', '').replace('>', '');
            this.element = document.createElement(nodeName);
            break;
          }

        default:
          {
            this.element = document.querySelector(this.selector);
            break;
          }
      }
    }
    else {
      this.element = this.selector;
    }
  };

  DomElement.prototype.on = function (event, callback) {
    this.eventHandler.bindEvent(event, callback, this.element);
    return this;
  };

  DomElement.prototype.off = function (event) {
    this.eventHandler.unbindEvent(event, this.element);
    return this;
  };

  DomElement.prototype.value = function (newVal) {
    return (newVal !== undefined ? this.element.value = newVal : this.element.value);
  };

  DomElement.prototype.append = function (html) {
    this.element.innerHTML = this.element.innerHTML + html;
    return this;
  };

  DomElement.prototype.prepend = function (html) {
    this.element.innerHTML = html + this.element.innerHTML;
    return this;
  };

  DomElement.prototype.html = function (html) {
    if (html === undefined) {
      return this.element.innerHTML;
    }

    this.element.innerHTML = html;
    return this;
  };

  DomElement.prototype.appendClass = function (className) {
    this.element.className += " " + className;
  };

  DomElement.prototype.hasClass = function (className) {
    return this.element.className.match(new RegExp('(\\s|^)' + className + '(\\s|$)'));
  };

  DomElement.prototype.removeClass = function (className) {
    if (this.hasClass(className)) {
      var ele = this.element;
      var reg = new RegExp('(\\s|^)' + className + '(\\s|$)');
      ele.className = ele.className.replace(reg, ' ');
    }
  };

  var $ = function (selector) {
    var el = new DomElement(selector);
    el.init();
    return el;
  };

  window.blu = $;

  window.loadFile = function (file, callback, async) {
    if (async === undefined)
    {
      async = true;
    }

    var rawFile = new XMLHttpRequest();
    rawFile.open("GET", file, async);

    if (async)
    {
      rawFile.onreadystatechange = function () {
        if (rawFile.readyState === 4) {
          if (rawFile.status === 200 || rawFile.status == 0) {
            var allText = rawFile.responseText;
            callback(allText);
          }
        }
      }
    }

    rawFile.send(null);

    if (!async)
    {
      var allText = rawFile.responseText;
      callback(allText);
    }
  };

  window.escapeHtml = function(unsafe) {
    return unsafe
         .replace(/&/g, "&amp;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;")
         .replace(/'/g, "&#039;");
 }
})();