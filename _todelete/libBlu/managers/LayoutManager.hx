package libBlu.managers;

import libBlu.ui.Element;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class LayoutManager
{
  public static var elements:Array<Element> = [];
  
  public static inline function addElement(element:Element):Void
  {
    elements.push(element);
  }
  
  public static inline function resize():Void
  {
    for (ui in elements)
    {
      ui.onResize();
    }
  }
}