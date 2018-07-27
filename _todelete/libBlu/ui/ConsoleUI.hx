package libBlu.ui;

import libBlu.scripting.HxsEngine;
import minimalComps.bit101.components.List;
import libBlu.ui.Key;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class ConsoleUI extends Sprite
{
  private var history:Array<String> = [];
  public var textField:TextField;
  private var historyList:List;
  private var current:Int = 0;

  public function new(heightPercent:Int = 30) 
  {
    super();
    initTextfield();
    draw(heightPercent);
  }
  
  private function initTextfield():Void
  {
    textField = new TextField();
    
    textField.autoSize = TextFieldAutoSize.LEFT;
    textField.type = TextFieldType.INPUT;
    
    textField.backgroundColor = 0x45297E;
    textField.textColor = 0xE8E1F4;
    textField.background = true;
    textField.wordWrap = true;
    textField.alpha = .8;
    textField.x = 10;
    
    addChild(textField);
    
    historyList = new List(this, 10, 5, ["Vk Debug Console: <You Can Run Scripts Here>"]);
    historyList.addEventListener(MouseEvent.CLICK, historyChange);
    historyList.setSize(width - 10, height - 35);
    historyList.autoHideScrollBar = true;
    historyList.defaultColor = 0xE8E1F4;
    historyList.alpha = .8;
  }
  
  public function show():Void
  {
    if(parent != null)
      parent.addChild(this);
    visible = true;
  }
  
  public function hide():Void
  {
    visible = false;
  }
  
  public function toggle():Void
  {
    parent.addChild(this);
    visible = !visible;
  }
  
  public function resize():Void
  {
    parent.addChild(this);
    draw(30);
  }
  
  public function onKey(char:Int):Void
  {
    if (char == Key.UP_ARROW)
    {
      if (current + 1 < history.length) 
        current++;
      else
        current = 0;
      textField.text = history[current];
    }
    
    if (char == Key.DOWN_ARROW)
    {
      if (current - 1 > 0) 
        current--;
      else
        current = 0;
      textField.text = history[current];
    }
  }
  
  public function runScript(global:HxsEngine):Void
  {
    global.runScript(textField.text, false);
    clear();
  }
  
  private function clear():Void
  {
    historyList.addItem(textField.text);
    history.unshift(textField.text);
    textField.text = "";
    current = 0;
  }
  
  private function historyChange(e:MouseEvent):Void 
  {
    textField.text = history[historyList.selectedIndex - 1];
  }
  
  private function draw(heightPercent:Int = 30):Void
  {
    var h:Int = Std.int((Lib.current.stage.stageHeight / 100) * heightPercent);
    historyList.setSize(Lib.current.stage.stageWidth - 20, h - 40);
    textField.width = Lib.current.stage.stageWidth - 20;
    y = Lib.current.stage.stageHeight - h;
    textField.y = h - 30;
    
    graphics.clear();
    graphics.beginFill(0x1E112F, .7);
    graphics.drawRect(5, 0, Lib.current.stage.stageWidth - 10, h - 5);
    graphics.endFill();
  }
  
}