window.blufedora = window.blufedora || {};

window.blufedora.urlvars = (window.blufedora.urlvars ||
{
  init : function()
  {
    this.vars = {};
    
    window.location.href.replace(
      /[?&]+([^=&]+)=([^&]*)/gi,
      function(m, key, value)
      {
        blufedora.urlvars.vars[key] = value;
      }
    );
  },
  
  get : function(key, defaultValue)
  {
    var return_value = defaultValue;
  
    if (this.has(key))
    {
      return_value = this.vars[key];
    }

    return return_value;
  },
  
  has : function(key)
  {
    return (key in this.vars);
  }
});
