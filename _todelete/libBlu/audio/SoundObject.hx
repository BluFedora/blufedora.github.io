package libBlu.audio;

import libBlu._assetIO.Asset;
import libBlu.display.GameObject;
import libBlu.geom.Vec;
import libBlu.math.Calc;
import libBlu.math.Calc;
import libBlu.math.Calc;
import libBlu.math.Calc;
import openfl.display.Graphics;
import openfl.media.Sound;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class SoundObject extends Vec
{
  //* Local Math Functions *//
  private var round = Math.round;
  private var cos   = Math.cos;
  private var sin   = Math.sin;
  
  private var _sound:Sound;
  
  private var _clipRect:GameObject = 0;
  
  private var _outerRadius:Int = 0;
  private var _innerRadius:Int = 0;
  private var _outerAngle:Int  = 0;
  private var _innerAngle:Int  = 0;
  
  private var _angleStart:Int = 0;
  private var _angleFinal:Int = 0;
  
  public var width(get, set):Int;

  public function new(soundPath:String) 
  {
    _sound = Asset.getSound(soundPath);
  }
  
  public function setSize(inner:Int, outer:Int):Void
  {
    _outerRadius = outer;
    _innerRadius = inner;
  }
  
  public function debugDraw(g:Graphics):Void
  {
    g.lineStyle(1, 0xFFCB1A, 1);
    if (_outerAngle != 360) _drawArc(g, _outerRadius, 10);
    else g.drawCircle(x, y, _outerRadius);
    
    
    g.lineStyle(1, 0xFFE48A, 1);
    if (_innerAngle != 360) _drawArc(g, _innerRadius, 10);
    else g.drawCircle(x, y, _innerRadius);
    
    g.endFill();
  }
  
  private function _drawArc(g:Graphics, radius:Int, precision:Int):Void
  {
    var angleDiff = _angleFinal - _angleStart;
    var steps = round(angleDiff * precision);
    var angle = _angleStart;
    
    var px = x + radius * cos(Calc.toRadians(angle));
    var py = y + radius * sin(Calc.toRadians(angle));
    
    g.moveTo(px, py);
    
    for (i in 0...steps)
    {
      angle = _angleStart + angleDiff / steps * i;
      g.lineTo(
        x + radius * cos(Calc.toRadians(angle)), 
        y + radius * sin(Calc.toRadians(angle))
      );
    }
  }
  
  private function get_width():Int 
  {
    return _outerRadius * 2;
  }
  
  private function set_width(value:Int):Int 
  {
    return _outerRadius = value / 2;
  }
  
}