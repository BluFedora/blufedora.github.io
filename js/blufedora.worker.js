

this.blufedora = this.blufedora || {};

function createAction(action, id)
{
  return {
    "action": blufedora.worker[action],
    "id": id
  };
}

function createSetFieldAction(id, field, value)
{
  var msg = createAction("SET_FIELD", id);

  msg.field = field;
  msg.value = value;

  return msg;
}

function createSetDatasetFieldAction(id, field, value)
{
  var msg = createAction("SET_DATASET", id);

  msg.field = field;
  msg.value = value;

  return msg;
}

function createSetStyleFieldAction(id, field, value)
{
  var msg = createAction("SET_STYLE_FIELD", id);

  msg.field = field;
  msg.value = value;

  return msg;
}

function createAddChildAction(id, child_id)
{
  var msg = createAction("ADD_CHILD", id);

  msg.child_id = child_id;

  return msg;
}

this.blufedora.loadFile = function (file, callback, async)
{
  if (async === undefined)
  {
    async = true;
  }

  var rawFile = new XMLHttpRequest();
  rawFile.open("GET", file, async);

  if (async)
  {
    rawFile.onreadystatechange = function ()
    {
      if (rawFile.readyState === 4)
      {
        if (rawFile.status === 200 || rawFile.status == 0)
        {
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

this.blufedora.escapeHtml = function (unsafe)
{
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

this.blufedora.worker =
  {
    "CREATE_ELEMENT": 0,
    "SET_FIELD": 1,
    "APPEND_HTML": 2,
    "SET_STYLE_FIELD": 3,
    "ADD_CHILD": 4,
    "LOAD_POST": 5,
    "GET_ELEMENT_BY_ID": 6,
    "SET_DOC_TITLE": 7,
    "SET_DATASET": 9,
    "DONE_LOADING": 10,

    globalID: 0,
    elementMap: {},

    onMessageMain: function (message)
    {
      var evt = message.data;

      if (evt.action == blufedora.worker.CREATE_ELEMENT)
      {
        var element = document.createElement(evt.type);
        blufedora.worker.elementMap[evt.id] = element;

        if (evt.type == "source")
        {
          element.type = "video/mp4";
        }
        else if (evt.type == "video")
        {
          element.controls = "_";
        }
      }
      else if (evt.action == blufedora.worker.SET_FIELD)
      {
        var element = blufedora.worker.elementMap[evt.id];

        element[evt.field] = evt.value;
      }
      else if (evt.action == blufedora.worker.APPEND_HTML)
      {
        var element = blufedora.worker.elementMap[evt.id];

        element.innerHTML += evt.value;
      }
      else if (evt.action == blufedora.worker.SET_STYLE_FIELD)
      {
        var element = blufedora.worker.elementMap[evt.id];

        element.style[evt.field] = evt.value;
      }
      else if (evt.action == blufedora.worker.ADD_CHILD)
      {
        var element = blufedora.worker.elementMap[evt.id];

        element.appendChild(blufedora.worker.elementMap[evt.child_id]);
      }
      else if (evt.action == blufedora.worker.GET_ELEMENT_BY_ID)
      {
        blufedora.worker.elementMap[evt.id] = document.getElementById(evt.name);
      }
      else if (evt.action == blufedora.worker.SET_DOC_TITLE)
      {
        document.title = evt.title;
      }
      else if (evt.action == blufedora.worker.SET_DATASET)
      {
        var element = blufedora.worker.elementMap[evt.id];
        
        element.dataset[evt.field] = evt.value === undefined ? element.innerHTML : evt.value;
      }
      else if (evt.action == blufedora.worker.DONE_LOADING)
      {
        PR.prettyPrint();
      }
      else
      {
        console.log("Invalid Event Action");
      }
    },

    createElement: function (type)
    {
      var msg = createAction("CREATE_ELEMENT", blufedora.worker.globalID);

      msg.type = type;

      postMessage(msg);
      ++blufedora.worker.globalID;

      return msg.id;
    },
    appendHTML: function (id, value)
    {
      var msg = createAction("APPEND_HTML", id);
      msg.value = value;
      postMessage(msg);
    },
    setClassName: function (id, value, id_value)
    {
      postMessage(createSetFieldAction(id, "className", value));
      postMessage(createSetFieldAction(id, "id", id_value || ""));
    },
    setData: function (id, field, value)
    {
      postMessage(createSetDatasetFieldAction(id, field, value));
    },
    setStyle: function (id, value)
    {
      postMessage(createSetFieldAction(id, "style", value));
    },
    setSource: function (id, value)
    {
      postMessage(createSetFieldAction(id, "src", value));
    },
    setHTML: function (id, value)
    {
      postMessage(createSetFieldAction(id, "innerHTML", value));
    },
    setHRef: function (id, value)
    {
      postMessage(createSetFieldAction(id, "href", value));
    },
    setStyleField: function (id, field, value)
    {
      postMessage(createSetStyleFieldAction(id, "href", value));
    },
    addChild: function (id, child_id)
    {
      postMessage(createAddChildAction(id, child_id));
    },
    getElementById: function (name)
    {
      var msg = createAction("GET_ELEMENT_BY_ID", blufedora.worker.globalID);

      msg.name = name;

      postMessage(msg);
      ++blufedora.worker.globalID;

      return msg.id;
    },
    setDocumentTitle: function (title)
    {
      var msg = createAction("SET_DOC_TITLE", blufedora.worker.globalID);
      msg.title = title;
      postMessage(msg);
    },
    loadBlogpost: function (blog_path, current_post, post_header_id)
    {
      var doc = blufedora.worker;

      function addContent(root_element, contents)
      {
        var contents_type = typeof (contents);

        if (contents_type == "object") 
        {
          for (var i = 0; i < contents.length; ++i) 
          {
            var content_block = contents[i];
            var content_block_type = typeof (content_block);

            if (content_block_type == "object")
            {
              if (content_block["Type"] == "")
              {
                addContent(root_element, content_block["Content"]);
              }
              else
              {
                var block_element = doc.createElement(content_block["Type"]);
                doc.setClassName(block_element, content_block["Class"] || "", content_block["ID"]);
                doc.setStyle(block_element, content_block["Style"] || "");

                if (content_block["Type"] == "img")
                {
                  doc.setSource(block_element, content_block["Source"]);
                }
                else if (content_block["Type"] == "video")
                {
                  var video_src = doc.createElement("source");
                  video_src.type = "video/mp4";

                  doc.setSource(video_src, content_block["Source"]);
                  doc.addChild(block_element, video_src);
                }
                else if (content_block["Type"] == "file")
                {
                  blufedora.loadFile("../" + content_block["Source"], ((function (obj)
                  {
                    return function (file_source)
                    {
                      doc.setHTML(obj, blufedora.escapeHtml(file_source));
                    };
                  })(root_element)), false);
                }
                else if (content_block["Type"] == "a")
                {
                  doc.setHRef(block_element, content_block["Source"]);
                  doc.setHTML(block_element, content_block["Content"]);
                }
                else if (content_block["Content"] !== undefined)
                {
                  addContent(block_element, content_block["Content"]);
                }

                doc.addChild(root_element, block_element);
              }
            }
            else if (content_block_type == "string")
            {
              doc.appendHTML(root_element, content_block);
            }
            else
            {
              console.error("addContent ERROR: Un able to parse content_block: " + JSON.stringify(contents));
            }
          }
        }
        else if (contents_type == "string")
        {
          doc.appendHTML(root_element, contents);
        }
        else
        {
          console.error("addContent ERROR: Un able to parse contents: " + JSON.stringify(contents));
        }
      }

      var xobj = new XMLHttpRequest();
      xobj.overrideMimeType("application/json");
      xobj.open('GET', blog_path, true);
      xobj.onreadystatechange = function ()
      {
        if (xobj.readyState == 4)
        {
          // TODO(Shareef): To make this better I should use the 404 blog-post file.
          // but there really isn't much of the need to do more IO than necessary.
          var json_data = (xobj.status !== 404) ? JSON.parse(xobj.responseText) : {
            "Title": "Post Could Not Be Found",
            "Header":
            {
              "Image": "url(images/covers/blog_cover_2.jpg)",
              "Author": "",
              "Date": ""
            },
            "Content":
              [
                {
                  "Type": "h4",
                  "Content": "404 Not Found"
                },
                {
                  "Type": "p",
                  "Content": "The post that you are looking for could not be found, please check out my other posts you may be interested in."
                }
              ]
          };

          var root_doc = doc.getElementById(current_post);
          var post_header = doc.getElementById(post_header_id);

          // Strip out html formatting
          doc.setDocumentTitle(json_data["Title"].replace(/<[^>]*>?/gm, ''))
          doc.setStyleField(post_header, "backgroundImage", json_data["Header"]["Image"])

          // <h2> Post Title </h2>
          var title_element = doc.createElement("h2");
          doc.setHTML(title_element, json_data["Title"]);
          doc.addChild(root_doc, title_element);

          // <h3>BY: Shareef Raheem | Date: 12/13/2017</h3>
          var author_element = doc.createElement("h3");
          doc.setHTML(author_element, json_data["Header"]["Author"] + " | " + json_data["Header"]["Date"]);
          doc.addChild(root_doc, author_element);

          var content_element = doc.createElement("div");
          doc.setClassName(content_element, "content");
          addContent(content_element, json_data["Content"]);
          doc.addChild(root_doc, content_element);

          postMessage(createAction("DONE_LOADING", 0));
        }
      };

      xobj.send(null);
    }
  };