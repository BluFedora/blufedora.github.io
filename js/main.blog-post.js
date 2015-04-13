importScripts("blufedora.worker.js");

onmessage = function(e) 
{
  var evt = e.data;

  if (evt.action == blufedora.worker.LOAD_POST)
  {
    blufedora.worker.loadBlogpost("../blog/" + evt.post + ".json", "current-post", "post-header", "post-header-content");
  }  
}
