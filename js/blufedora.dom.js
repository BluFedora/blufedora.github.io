// [https://www.w3schools.com/jsref/met_document_queryselectorall.asp]

window.blufedora = window.blufedora || {};

window.blufedora.dom = {

  createDivWithClass: function (clzName)
  {
    var element = document.createElement("div");
    element.classList = clzName;

    return element;
  },
  createElementWithContent: function (elem_type, content)
  {
    var element = document.createElement(elem_type);

    if (content !== undefined)
    {
      element.innerHTML = content;
    }

    return element;
  },
  escapeHtml: function(unsafe) {
      return unsafe
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&#039;");
  },
};
