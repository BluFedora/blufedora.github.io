package libBlu.system;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class DynamicClass implements Dynamic
{
  public var script:String = "assets/lua";
  public var name:String   = "Lua_Class";
  
  public function new(luaScript:String) 
  {
    this.script = luaScript;
  }
  
  private function resolve(field:String):String
  {
    return "Tried to resolve " + field;
  }
}