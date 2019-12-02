importScripts("blufedora.worker.js");

onmessage = function(e) 
{
  var evt = e.data;

  if (evt.action == blufedora.worker.LOAD_POST)
  {
    blufedora.worker.loadBlogpost("../data/blog-posts/" + evt.post + ".json", "current-post", "post-header");
  }  
}


