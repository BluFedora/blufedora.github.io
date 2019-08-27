// This module depends on "blufedora.dom.js"

window.blufedora = window.blufedora || {};

window.blufedora.blog = {
  loadBlogpost: function (blog_path, current_post, post_header_id) {
    function addContent(root_element, contents) {
      var contents_type = typeof (contents);

      if (contents_type == "object") {
        for (var i = 0; i < contents.length; ++i) {
          var content_block = contents[i];
          var content_block_type = typeof (content_block);

          if (content_block_type == "object") {
            if (content_block["Type"] == "") {
              addContent(root_element, content_block["Content"]);
            }
            else {
              var block_element = document.createElement(content_block["Type"]);
              block_element.className = content_block["Class"] || "";
              block_element.style = content_block["Style"] || "";

              if (content_block["Type"] == "img") {
                block_element.src = content_block["Source"];
              }
              else if (content_block["Content"] !== undefined) {
                addContent(block_element, content_block["Content"]);
              }

              root_element.appendChild(block_element);
            }
          }
          else if (content_block_type == "string") {
            root_element.innerHTML += content_block;
          }
          else {
            console.error("addContent ERROR: Un able to parse content_block: " + JSON.stringify(contents));
          }
        }
      }
      else if (contents_type == "string") {
        root_element.innerHTML += contents;
      }
      else {
        console.error("addContent ERROR: Un able to parse contents: " + JSON.stringify(contents));
      }
    }

    var xobj = new XMLHttpRequest();
    xobj.overrideMimeType("application/json");
    xobj.open('GET', blog_path, true);
    xobj.onreadystatechange = function () {
      if (xobj.readyState == 4) {
        if (xobj.responseText === "") {
          window.location.href = "blog-post.html";
        }
        var json_data = JSON.parse(xobj.responseText);
        var root_doc = document.getElementById(current_post);
        var post_header = document.getElementById(post_header_id);

        document.title = json_data["Title"];

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