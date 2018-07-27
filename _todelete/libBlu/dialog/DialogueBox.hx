package libBlu.dialog;

import libBlu.dialog.DialogStack;
import libBlu.dialog.DialogStack.DialogBlock;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class DialogueBox extends Sprite
{
  private var textfield:TextField = new TextField();

  public function new() 
  {
    super();
    x =  10;
    y = 430;
    
    graphics.beginFill(0x000000, .5);
    graphics.drawRect(0, 0, 600, 100);
    graphics.beginFill(0x676767, 1);
    graphics.drawRect(10, -15, 150, 20);
    graphics.endFill();
    
    //textfield.textColor = 0xD0CDF8;
    textfield.defaultTextFormat = new TextFormat(null, 20, 0xD0CDF8, true);
    textfield.selectable = false;
    textfield.height = 100;
    textfield.width = 600;
    addChild(textfield);
    textfield.y = -17;
    textfield.x = 20;
  }
  
  public function showDialog(dialog:DialogBlock):Void
  {
    textfield.text = dialog.speaker + ":\n" + dialog.text;
  }
  
  public function showDialogStack(dialog:DialogStack, index:Int = 0):Void
  {
    textfield.text = dialog.dialogs[index].speaker + ":\n" + dialog.dialogs[index].text;
  }
  
}