// [https://www.w3schools.com/jsref/met_document_queryselectorall.asp]

window.blufedora = window.blufedora || {};

window.blufedora.dom = {

  createDivWithClass: function (clzName)
  {
    var element = document.createElement("div");
    element.classList = clzName;
    return element;
  }

};
