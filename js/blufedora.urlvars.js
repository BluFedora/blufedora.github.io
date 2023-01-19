window.blufedora = window.blufedora || {};

window.blufedora.urlvars = (window.blufedora.urlvars ||
  {
    vars : undefined,

    _init: function ()
    {
      this.vars = {};

      window.location.href.replace(
        /[?&]+([^=&]+)=([^&]*)/gi,
        function (m, key, value)
        {
          blufedora.urlvars.vars[key] = value;
        }
      );
    },

    get: function (key, defaultValue)
    {
      if (this.vars === undefined) { this._init(); }
      
      return this.has(key) ? this.vars[key] : defaultValue;
    },
    
    has: function (key)
    {
      if (this.vars === undefined) { this._init(); }

      return (key in this.vars);
    }
  });
