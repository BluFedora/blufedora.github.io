function Dialog(title_text, onClose)
{
  this.dom = document.createElement("div");
  this.dom.classList.add("dialog");

  var title = document.createElement("div");
  title.classList.add("dialog_title");
  title.innerHTML = title_text;

  var close_btn = document.createElement("div");
  close_btn.classList.add("dialog_close");
  close_btn.innerHTML = "&times;";

  close_btn.dialog_parent = this;

  close_btn.addEventListener("click", function(e) {
    if (onClose) onClose(this);
    this.dialog_parent.hide();
  });

  var clear_div = document.createElement("div");
  clear_div.classList.add("clear");

  title.appendChild(close_btn);
  title.appendChild(clear_div);

  this.dom.appendChild(title);
}

function create_dialogElement()
{
  var element = document.createElement("div");
  element.classList.add("dialog_element");
  return element;
}

Dialog.prototype.pushLabel = function(text)
{
  var e = create_dialogElement();

    // <div class="dialog_label">Label: </div>
  var label = document.createElement("div");
  label.classList.add("dialog_label");
  label.innerHTML = text;

  e.appendChild(label);

  this.dom.appendChild(e);
  
  label.dialog_parent = this;

  return label;
};

Dialog.prototype.pushInputText = function(default_value, placeholder_text)
{
  var e = create_dialogElement();

  // <input type="text" value="" placeholder="Input Text Here">
  var text = document.createElement("input");
  text.type = "text";
  text.value = default_value || "";
  text.placeholder = placeholder_text || "";

  e.appendChild(text);

  this.dom.appendChild(e);
  
  text.dialog_parent = this;

  return text;
};

Dialog.prototype.pushOptions = function(options)
{
  var e = create_dialogElement();

  var select = document.createElement("select");

  /*
  <select onchange="alert(this.value);">
    <option value="volvo">Volvo</option>
    ...
  </select>
  */
  for (var i = 0; i < options.length; ++i)
  {
    var option_dom = document.createElement("option");
    var option = options[i];

    option_dom.innerHTML = option.label;
    option_dom.value = option.value;

    select.appendChild(option_dom);
  }

  e.appendChild(select);

  this.dom.appendChild(e);
  
  select.dialog_parent = this;

  return select;
};

Dialog.prototype.pushButton = function(text)
{
  var e = create_dialogElement();

  /*
    <input type="submit" value="Decline">
  */
  var submit = document.createElement("input");
  submit.type = "submit";
  submit.value = text;
  e.appendChild(submit);

  this.dom.appendChild(e);
  
  submit.dialog_parent = this;

  return submit;
};

Dialog.prototype.pushButtons = function(texts)
{
  var e = create_dialogElement();

  /*
    <input type="submit" value="text">
    ...
  */
  var buttons = [];

  for (var i = 0; i < texts.length; ++i) {
    var submit = document.createElement("input");
    submit.type = "submit";
    submit.value = texts[i];
    e.appendChild(submit);
    buttons.push(submit);
  }

  this.dom.appendChild(e);

  return buttons;
};

Dialog.prototype.show = function()
{
  document.body.appendChild(this.dom);
};

Dialog.prototype.hide = function()
{
  document.body.removeChild(this.dom);
};
