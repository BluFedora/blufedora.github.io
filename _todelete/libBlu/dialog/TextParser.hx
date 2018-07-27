package libBlu.dialog;

import libBlu._assetIO.Asset;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class TextParser 
{
  //the text file to parse
    private var _text:String;
  //temp var holding the current index
  private var _textIndex:Int;

  public function new(text:String, isFile:Bool = false):Void
  {
    _text = (isFile) ? Asset.getText(text):text;
    _textIndex = 0;
  }
  
  public function EndofFile():Bool
  {
    return (_textIndex >= _text.length - 1);
  }
  
  public function ReadString():String
  {
    var c:String;
        var retStr:String = "";
        c = _text.charAt(_textIndex++);
    
    while ((c == ' ' || c == '\t') && _textIndex < _text.length)
    {
      c = _text.charAt(_textIndex++);  
    }
        
    while (c != ' ' && c != '\t' && c != '\r' && c != '\n'  && _textIndex < _text.length)
    {
      retStr += c;
      c = _text.charAt(_textIndex++);
    }
    
    return retStr;
  }
  
  public function ReadInteger():Int
  {
    return Std.parseInt(ReadString());
  }
  
  public function GotoNextLine():Void
  {
      var c:String;
    c = _text.charAt(_textIndex++);
        while( c != '\n' && !EndofFile())
        {
      c = _text.charAt(_textIndex++);
        }
  }
  
  public function GetWholeLine():String
  {
    var c:String;
        var retStr:String = "";
      if ( _textIndex > _text.length-1) return retStr;
    
    do 
    {
      c = _text.charAt(_textIndex++);
    }
        while ( c == '\n' && _textIndex < _text.length);
    
    if ( _textIndex > _text.length-1) return retStr;
    
    // read whole line
        do 
    {
      retStr += c;
      c = _text.charAt(_textIndex++);
    }
    while ( c != '\n' && _textIndex < _text.length);
    
    return retStr;
  }
  
}

//Example of Usage:
  
/*  
var myTextParser:TextParser = new TextParser(myUILayout.toString());

while (!myTextParser.EndofFile())
{
  var Name:String = myTextParser.ReadString();
  trace(Name);
  
  if (Name == "#") //comment line
  {
    myTextParser.GotoNextLine();
  }
  
  var CallBackStr:String = myTextParser.ReadString();
  trace(CallBackStr);
  var IconStr:String = myTextParser.ReadString();
  trace(IconStr);
  var Color:uint = myTextParser.ReadInteger();
  trace(Color);
  var Label:String = myTextParser.ReadString();
  trace(Label);
  var LevelStr:String = myTextParser.ReadString();
  trace(LevelStr);
  myTextParser.GotoNextLine();
}

*/

/*
 * The Text File

  StartCell JGG_ChangeLevel 0xffffff null Start 0
  # comment: Name CallbackFunction BackgroundColor Icon Label Index
  Cell_0 JGG_ChangeLevel 0xffffff null Close 0,0
  Cell_1 JGG_ChangeLevel 0xffffff null New_Level 0,1
  Cell_2 CallBack 0xffffff null Label 0,2
  Cell_3 CallBack 0xffffff null Label 0,3
  Cell_4 CallBack 0xffffff testicon.png Label 0,4
  Cell_5 CallBack 0xffffff null Label 0,5
  Cell_6 CallBack 0xffffff null Label 0,6
  Cell_7 CallBack 0xffffff null Label 0,7
  Cell_8 CallBack 0xffffff null Label 0,8
  # label: _ for space, / for newline
  Cell_1_Cell_0 JGG_ChangeLevel 0x0000ff null Go/Back 0,1,0
  Cell_1_Cell_1 CallBack 0x0000ff null Label 0,1,1 
  Cell_1_Cell_2 CallBack 0x0000ff null Label 0,1,2
  Cell_1_Cell_3 CallBack 0x0000ff testicon.png Label 0,1,3
  Cell_1_Cell_4 CallBack 0x0000ff null Label 0,1,4
  Cell_1_Cell_5 CallBack 0x0000ff null Label 0,1,5
  Cell_1_Cell_6 CallBack 0x0000ff null Label 0,1,6
  Cell_1_Cell_7 CallBack 0x0000ff null Label 0,1,7
  Cell_1_Cell_8 CallBack 0x0000ff null Label 0,1,8

*/
