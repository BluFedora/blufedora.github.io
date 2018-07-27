package libBlu.dialog;

import libBlu._assetIO.Asset;
import haxe.xml.Fast;
import sys.FileSystem;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */

@:allow(libBlu.dialog.DialogueBox)
class DialogStack
{
  private var CONVERSATION:String = "conversation";
  private var CONTINUE:String = "continue";
  private var NPC:String = "npc";
  
  private var GREETINGS:String = "greetings";
  private var GREET:String = "greet_";
  
  private var QUESTION:String = "question";
  private var OPTIONS:String = "options";
  
  private var AMOUNT:String = "amount";
  private var TYPE:String = "type";
  private var SAY:String = "say_";
  private var SAY2:String = "say";
  
  private var ENDINGS:String = "endings";
  private var END:String = "end_";
  
  private var dialogs:Array<DialogBlock> = [];

  public function new(name:String, text:String) 
  {
    addDialog(name, text);
  }
  
  public function addDialog(name:String, text:String):Void
  {
    dialogs.push( 
    { 
      speaker:name, 
      text:text 
    });
  }
  
  public function loadXML(path:String):Void
  {
    if (FileSystem.exists(path))
    {
      var xml:Xml = Xml.parse(Asset.getText(path));
      var fast = new Fast(xml.firstElement());
      
      var greetArray:Array<String> = getGreetings(fast);
      var endArray:Array<String>   = getEndings(fast);
      var convoArray:Array<String> = [];
      
      var name = fast.node.resolve(NPC).att.name;
      var inNpc = fast.node.resolve(NPC);
      
      var inConvo = inNpc.node.resolve(CONVERSATION);
      var count = Std.parseInt(inConvo.att.resolve(AMOUNT));
      
      for (i in 0...count)
      {
        if (inConvo.node.resolve(SAY + (i + 1)).att.resolve(TYPE) == QUESTION)
        {
          convoArray.push(inConvo.node.resolve(SAY + (i + 1)).node.resolve(QUESTION).innerData);
          var inOptions = inConvo.node.resolve(SAY + (i + 1)).node.resolve(OPTIONS);
          convoArray = convoArray.concat(getOptions(inOptions));
        }
        else if (inConvo.node.resolve(SAY + (i + 1)).att.resolve(TYPE) == "continue")
        {
          convoArray.push(inConvo.node.resolve(SAY + (i + 1)).node.resolve("continue").innerData);
          var inOptions = inConvo.node.resolve(SAY + (i + 1)).node.resolve("say");
          convoArray = convoArray.concat(getOptions(inOptions, true));
          continueBlock();
        }
        else
        {
          convoArray.push(inConvo.node.resolve(SAY + (i + 1)).innerData);
        }
      }
      
      trace(convoArray);
    }
  }
  
  private function getGreetings(root:Fast):Array<String>
  {
    var greetings:Array<String> = [];
    var inNpc = root.node.resolve(NPC);
    var count = Std.parseInt(inNpc.node.resolve(GREETINGS).att.resolve(AMOUNT));
    for (i in 0...count) greetings.push(inNpc.node.resolve(GREETINGS).node.resolve(GREET + (i + 1)).innerData);
    return greetings;
  }
  
  private function continueBlock():Void
  {
    
  }
  
  private function getOptions(inOptions:Fast, continueBlock:Bool = false):Array<String>
  {
    var statements:Array<String> = [];
    
    var count:Int = 1;
    if (!continueBlock)count = Std.parseInt(inOptions.att.resolve(AMOUNT));
    
    for (i in 0...count)
    {
      if (!continueBlock)
      {
        var option = inOptions.node.resolve(SAY + (i + 1));
        
        if (option.att.resolve(TYPE) == QUESTION)
        {
          statements.push(option.node.resolve(QUESTION).innerData);
          statements = statements.concat(getOptions(option.node.resolve(OPTIONS)));
        }
        else
        {
          statements.push(option.innerData);
        }
      }
      else
      {
        var option = inOptions;
        
        if (option.att.resolve(TYPE) == CONTINUE)
        {
          statements.push(option.node.resolve(CONTINUE).innerData);
          statements = statements.concat(getOptions(option.node.resolve(SAY2), true));
        }
        else
        {
          statements.push(option.innerData);
        }
      }
    }
    
    return statements;
  }
  
  private function getEndings(root:Fast):Array<String>
  {
    var endings:Array<String> = [];
    var inNpc = root.node.resolve(NPC);
    var count = Std.parseInt(inNpc.node.resolve(ENDINGS).att.resolve(AMOUNT));
    for (i in 0...count) endings.push(inNpc.node.resolve(ENDINGS).node.resolve(END + (i + 1)).innerData);
    return endings;
  }
  
}

typedef DialogBlock = 
{
  var speaker:String;
  var text:String;
}