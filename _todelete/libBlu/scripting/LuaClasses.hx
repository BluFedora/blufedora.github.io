package libBlu.scripting;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class LuaClasses
{
  public static inline var Package:String = "assets/libBlu/";
  
  //* Display *//
  public static inline var GameObject:String = Package + "display/GameObject";
  public static inline var Tile:String       = Package + "display/Tile";
  
  //* Lua Specific *//
  public static inline var StackManager:String = Package + "managers/StackManager";
  public static inline var Main:String = Package + "Main";
  
  //* Math *//
  public static inline var Calc:String = Package + "math/Calc";
  
  //* Utils *//
  public static inline var Utils:String = Package + "utils/Utils";
}