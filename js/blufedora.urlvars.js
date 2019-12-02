window.blufedora = window.blufedora || {};

window.blufedora.urlvars = (window.blufedora.urlvars ||
  {
    init: function ()
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
      return this.has(key) ? this.vars[key] : defaultValue;
    },

    has: function (key)
    {
      return (key in this.vars);
    }
  });
