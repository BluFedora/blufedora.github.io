package blufedora;

import js.html.Window;
import js.Browser;

@:keep
@:expose("blufedora.urlvars")
class UrlVars
{
  private static var s_Variables:Map<String, String> = null;
    
  private static function main(): Void
  {
    s_Variables = new Map<String, String>();

    var window:Window = Browser.window;
    var url:String = window.location.href;
    var parse_start:Int= url.indexOf('?') + 1;
    
    if (parse_start != 0)
    {
      var parse_end:Int = url.indexOf('#', parse_start);

      if (parse_end == -1) parse_end = url.length;

      if (parse_start != parse_end)
      {
        var vars:String = url.substring(parse_start, parse_end);
        var var_parts = vars.split("&");
  
        for (part in var_parts)
        {
          var decoded_part = StringTools.urlDecode(part);
          var key_value = decoded_part.split("=");
  
          if (key_value.length > 0)
          {
            if (key_value.length > 1)
            {
              s_Variables.set(key_value[0], key_value[1]);
            }
            else
            {
              s_Variables.set(key_value[0], "");
            }
          }
        }
      }
    }
  }

  public static function get(key:String, ?default_value:String):String
  {
    var value = s_Variables.get(key);

    if (value == null)
    {
      value = default_value;
    }

    return value;
  }

  public static function has(key:String):Bool
  {
    return s_Variables.exists(key);
  }
}