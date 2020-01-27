// This module depends on "blufedora.dom.js"
// This module depends on "blu_lib.js"

window.blufedora = window.blufedora || {};

window.blufedora.blog =
  {
    loadBlogpost: function (blog_path, current_post, post_header_id)
    {
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
                var block_element = document.createElement(content_block["Type"]);
                
                block_element.id = content_block["ID"] || "";

                if (content_block["Type"] == "img")
                {
                  block_element.src = content_block["Source"];
                }
                else if (content_block["Type"] == "video")
                {
                  var video_src = document.createElement("source");
                  video_src.src = content_block["Source"];
                  video_src.type = "video/mp4";
                  block_element.appendChild(video_src);
                }
                else if (content_block["Type"] == "file")
                {
                  // TODO: I need to make this async.
                  window.loadFile(content_block["Source"], ((function (obj)
                  {
                    return function (file_source)
                    {
                      obj.innerHTML = window.escapeHtml(file_source);
                    };
                  })(root_element)), false);
                  return; // Don't add this to the dom.
                }
                else if (content_block["Type"] == "pre")
                {
                  addContent(block_element, content_block["Content"]);
                  block_element.innerHTML = (window.PR !== undefined && window.PR !== null) ? "\n" + PR.prettyPrintOne(block_element.innerHTML) + "\n" : block_element.innerHTML;
                }
                else if (content_block["Type"] == "a")
                {
                  block_element.href = content_block["Source"];
                  block_element.innerHTML = content_block["Content"];
                }
                else if (content_block["Content"] !== undefined)
                {
                  addContent(block_element, content_block["Content"]);
                }

                block_element.className = content_block["Class"] || "";
                block_element.style = content_block["Style"] || "";

                root_element.appendChild(block_element);
              }
            }
            else if (content_block_type == "string")
            {
              root_element.innerHTML += content_block;
            }
            else
            {
              console.error("addContent ERROR: Unable to parse content_block: " + JSON.stringify(contents));
            }
          }
        }
        else if (contents_type == "string")
        {
          root_element.innerHTML += contents;
        }
        else
        {
          console.error("addContent ERROR: Unable to parse contents: " + JSON.stringify(contents));
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

          var root_doc = document.getElementById(current_post);
          var post_header = document.getElementById(post_header_id);

          // Strip out html formatting
          document.title = json_data["Title"].replace(/<[^>]*>?/gm, '');

          post_header.style.backgroundImage = json_data["Header"]["Image"];

          // <h2> Post Title </h2>
          var title_element = document.createElement("h2");
          title_element.innerHTML = json_data["Title"];
          root_doc.appendChild(title_element);

          // <h3>BY: Shareef Raheem | Date: 12/13/2017</h3>
          var author_element = document.createElement("h3");
          author_element.innerHTML = json_data["Header"]["Author"] + " | " + json_data["Header"]["Date"];
          root_doc.appendChild(author_element);

          var content_element = blufedora.dom.createDivWithClass("content");
          addContent(content_element, json_data["Content"]);
          root_doc.appendChild(content_element);
        }
      };

      xobj.send(null);
    }
  };
  