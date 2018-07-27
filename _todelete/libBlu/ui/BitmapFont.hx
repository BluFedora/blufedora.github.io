package libBlu.ui ;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class BitmapFont extends Bitmap 
{  
  public var align:String;
  public var multiLine:Bool;
  public var autoUpperCase:Bool;
  public var customSpacingX:Int;
  public var customSpacingY:Int;
  private var _text:String;

  public static var ALIGN_LEFT:String = "left";
  public static var ALIGN_RIGHT:String = "right";
  public static var ALIGN_CENTER:String = "center";

  public static inline var TEXT_SET1:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
  public static inline var TEXT_SET2:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  public static inline var TEXT_SET3:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ";
  public static inline var TEXT_SET4:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789";
  public static inline var TEXT_SET5:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,/() '!?-*:0123456789";
  public static inline var TEXT_SET6:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!?:;0123456789\"(),-.' ";
  public static inline var TEXT_SET7:String = "AGMSY+:4BHNTZ!;5CIOU.?06DJPV,(17EKQW\")28FLRX-'39";
  public static inline var TEXT_SET8:String = "0123456789 .ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  public static inline var TEXT_SET9:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ()-0123456789.:,'\"?!";
  public static inline var TEXT_SET10:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  public static inline var TEXT_SET11:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\"-+!?()':;0123456789";

  private var fontSet:BitmapData;
  private var offsetX:Int;
  private var offsetY:Int;
  private var characterWidth:Int;
  private var characterHeight:Int;
  private var characterSpacingX:Int;
  private var characterSpacingY:Int;
  private var characterPerRow:Int;
  private var grabData:Array<Rectangle>;

  public function new(fontURL:String, width:Int, height:Int, chars:String, charsPerRow:Int, xSpacing:Int = 0, ySpacing:Int = 0, xOffset:Int = 0, yOffset:Int = 0):Void
  {
    super();
    
    align = "left";
    multiLine = false;
    autoUpperCase = true;
    customSpacingX = 0;
    customSpacingY = 0;
    
    fontSet = BitmapData.fromFile(fontURL);
    
    characterWidth = width;
    characterHeight = height;
    characterSpacingX = xSpacing;
    characterSpacingY = ySpacing;
    characterPerRow = charsPerRow;
    offsetX = xOffset;
    offsetY = yOffset;
    
    grabData = new Array();
    
    var currentX:Int = offsetX;
    var currentY:Int = offsetY;
    var r:Int = 0;
    
    for(c in 0...chars.length)
    {
      grabData[chars.charCodeAt(c)] = new Rectangle(currentX, currentY, characterWidth, characterHeight);
      r++;
      
      if (r == characterPerRow)
      {
        r = 0;
        currentX = offsetX;
        currentY += characterHeight + characterSpacingY;
      }
      else
      {
        currentX += characterWidth + characterSpacingX;
      }
    }
  }

  public var text(get_text, set_text):String;

  public function set_text(content:String):String
  {
    if(autoUpperCase)
    {
      _text = content.toUpperCase();
    }
    else
    {
      _text = content;
    }
    
    removeUnsupportedCharacters(multiLine);
    
    buildBitmapFontText();
    
    return _text;
  }

  public function get_text():String
  {
    return _text;
  }

  public function setText(content:String, multiLines:Bool = false, characterSpacing:Int = 0, lineSpacing:Int = 0, lineAlignment:String = "left", allowLowerCase:Bool = false):Void
  {
    customSpacingX = characterSpacing;
    customSpacingY = lineSpacing;
    align = lineAlignment;
    multiLine = multiLines;
    
    if (allowLowerCase)
    {
      autoUpperCase = false;
    }
    else
    {
      autoUpperCase = true;
    }
    
    text = content;
  }

  private function buildBitmapFontText():Void
  {
    var temp:BitmapData;
    
    if (multiLine)
    {
      var lines:Array<String> = _text.split("\n");
      
      var cx:Int = 0;
      var cy:Int = 0;
      
      temp = new BitmapData(getLongestLine() * (characterWidth + customSpacingX), (lines.length * (characterHeight + customSpacingY)) - customSpacingY, true, 0xf);
      
      for(i in 0...lines.length)
      {
        switch (align)
        {
          case "left":
          cx = 0;
          break;
          
          case "right":
          cx = temp.width - (lines[i].length * (characterWidth + customSpacingX));
          break;
          
          case "center":
          cx = Math.floor((temp.width / 2) - ((lines[i].length * (characterWidth + customSpacingX)) / 2));
          cx += Math.floor(customSpacingX / 2);
          break;
        }
        
        pasteLine(temp, lines[i], cx, cy, customSpacingX);
        cy += characterHeight + customSpacingY;
      }
    }
    else
    {
      temp = new BitmapData(_text.length * (characterWidth + customSpacingX), characterHeight, true, 0xf);
      pasteLine(temp, _text, 0, 0, customSpacingX);
    }
    
    this.bitmapData = temp;
  }

  /**
  * Returns a single character from the font set as an FlxsSprite.
  * 
  * @param  char  The character you wish to have returned.
  * 
  * @return  An <code>FlxSprite</code> containing a single character from the font set.
  */
  public function getCharacter(char:String):Bitmap
  {
    var output:Bitmap = new Bitmap();
    
    var temp:BitmapData = new BitmapData(characterWidth, characterHeight, true, 0xf);
    
    if(Std.is(grabData[char.charCodeAt(0)], Rectangle) && char.charCodeAt(0) != 32)
    {
      temp.copyPixels(fontSet, grabData[char.charCodeAt(0)], new Point(0, 0));
    }
    
    output.bitmapData = temp;
    
    return output;
  }

  /**
  * Internal function that takes a single line of text (2nd parameter) and pastes it into the BitmapData at the given coordinates.
  * Used by getLine and getMultiLine
  * 
  * @param  output  The BitmapData that the text will be drawn onto
  * @param  line  The single line of text to paste
  * @param  x  The x coordinate
  * @param  y
  * @param  customSpacingX
  */
  private function pasteLine(output:BitmapData, line:String, x:Int = 0, y:Int = 0, customSpacingX:Int = 0):Void
  {
    for(c in 0...line.length)
    {
      //  If it's a space then there is no point copying, so leave a blank space
      if(line.charAt(c) == " ")
      {
        x += characterWidth + customSpacingX;
      }
      else
      {
        //  If the character doesn't exist in the font then we don't want a blank space, we just want to skip it
        if(Std.is(grabData[line.charCodeAt(c)], Rectangle))
        {
          output.copyPixels(fontSet, grabData[line.charCodeAt(c)], new Point(x, y));
          x += characterWidth + customSpacingX;
        }
      }
    }
  }

  /**
  * Works out the longest line of text in _text and returns its length
  * 
  * @return  A value
  */
  private function getLongestLine():Int
  {
    var longestLine:Int = 0;
    
    if(_text.length > 0)
    {
      var lines:Array<String> = _text.split("\n");
      
      for(i in 0...lines.length)
      {
        if(lines[i].length > longestLine)
        {
          longestLine = lines[i].length;
        }
      }
    }
    
    return longestLine;
  }

  private function removeUnsupportedCharacters(stripCR:Bool = true):String
  {
    var newString:String = "";
    
    for(c in 0..._text.length)
    {
      if(Std.is(grabData[_text.charCodeAt(c)], Rectangle) || _text.charCodeAt(c) == 32 || (stripCR == false && _text.charAt(c) == "\n"))
      {
        newString = newString + _text.charAt(c);
      }
    }
    
    return newString;
  }
  
}