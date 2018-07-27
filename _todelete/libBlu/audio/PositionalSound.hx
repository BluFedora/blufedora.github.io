package libBlu.audio;

import libBlu.math.Calc;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */
class PositionalSound
{
  public static var shouldClearZeroVolumeSounds:Bool = false;
  private static var m_helperPoint:Point = new Point;
  
  private var sound:Sound = null;
  private var m_sound:Sound            = null;  // the sound that this class is for
  private var m_transform:SoundTransform      = null; // the sound transform object that we'll use to modify our volume etc
  private var m_channel:SoundChannel        = null; // the sound channel that we're currently playing
  private var m_pos:Point              = null;  // the position of our sound in the world
  private var m_prevPos:Point            = null;  // a point used to see if our position has changed
  private var m_followObj(get, set):DisplayObject = null;  // an object to follow, if we should move automatically
  private var m_refObj(get, set):DisplayObject  = null;  // the reference object, that we'll use to adjust our volume and pan
  private var m_refPos(get, set):Point      = null;  // the reference point, that we'll use to adjust our volume and pan
  private var m_prevRefPos:Point          = null;  // a point used to see if our reference position has changed
  private var m_prevRefObjRotation:Float      = 0.0;  // used to see if our reference object rotation has changed
  private var m_rotation(get, set):Float          = 0.0;  // the rotation of the sound
  private var m_rotationRads:Float        = 0.0;  // the rotation of the sound, in radians
  private var m_innerRadius:Float         = 0.0;   // the inner radius for the sound - volume is at 100% here
  private var m_outerRadius:Float         = 0.0;  // the outer radius for the sound - volume is a outerRadiusVolume and scales up
  private var m_innerAngle:Float          = 0.0;  // the inner angle for our sound
  private var m_outerAngle:Float          = 0.0;  // the outer angle for our sound
  private var m_volume:Float            = 0.0;  // the max volume for the sound, when our reference obj/pos is inside the innerRadius
  private var m_currVolume:Float          = 0.0;  // the current volume for the sound
  private var m_outerRadiusVolume:Float      = 0.0;  // the volume for when our reference obj/pos is outside the outerRadius
  private var m_fadeVolume:Float          = 0.0;  // a separate volume to control the fade of the sound (e.g. if we want to have a global sound volume level)
  //private var m_panType:PositionalSoundPanType  = null; // the type that describes how to deal with pan for the object
  private var m_currPan:Float              = 0.0;  // the current pan for the sound
  private var m_maxPan:Float            = 0.0;  // the max pan that we can have, on either channel
  private var m_posVolLimit:Float            = 0.0;  // the limit at which we consider a sound being "behind" us, for positional volume
  private var m_posVolMult:Float          = 0.0;  // the mult that we apply for sounds "behind" us, for positional volume
  private var m_position:Float          = 0.0;  // the position of the sound
  private var m_startTime:Float          = 0.0;  // the start time that we'll loop back to
  private var m_isPaused:Bool              = false;// is the sound paused?
  private var m_isPlaying:Bool          = false;// is the sound playing?
  private var m_loops:UInt            = 0;  // the Float of times to loop the sound
  private var m_clipRect:Rectangle        = null;  // the clip rect, to clip our sound boundaries
  private var m_clipRectRotation:Float      = 0.0;  // the rotation of the clip rect
  private var m_clipRectRotationRads:Float    = 0.0;  // the rotation of the clip rect, in radians
  private var m_isClipRectInversed:Bool        = false;// is the clip rect inversed (i.e. we hear when we're *outside* of it)
  private var m_isDirty:Bool              = false;// to know if we need to update or not

  public function new() 
  {
    
  }
  
  private function get_followObj():DisplayObject { return m_followObj; }
  private function set_followObj(value:DisplayObject):DisplayObject 
  {
    this.m_isDirty = true;
    return m_followObj = value;
  }
  
  private function get_refObj():DisplayObject { return m_refObj; }
  private function set_refObj(value:DisplayObject):DisplayObject 
  {
    this.m_isDirty = true;
    return m_refObj = value;
  }
  
  private function get_refPos():Point { return m_refPos; }
  private function set_refPos(value:Point):Point 
  {
    this.m_isDirty = true;
    return m_refPos = value;
  }
  
  private function get_rotation():Float { return m_rotation; }
  private function set_rotation(value:Float):Float 
  {
    this.m_isDirty = true;
    m_rotation = value
    
    // clamp between -180 and 180
    while ( this.m_rotation < -180.0 )
      this.m_rotation += 360.0;
    while ( this.m_rotation > 180.0 )
      this.m_rotation -= 360.0;
    
    this.m_rotationRads = Calc.toRadians(m_rotation);
    
    return m_rotation;
  }
  
  private function _drawCone(g:Graphics, angle:Float, radius:Float):Void
  {
    var hr = Calc.toRadians(angle) * .5;
    
    var p  = PositionalSound.m_helperPoint;
    var rp = PositionalSound.m_helperPoint;
    p.setTo( radius, 0.0 );
    
    var iters:Int = Std.int(angle / 10);
    var rIters  = ( iters > 0 ) ? ( hr * 2.0 ) / iters : 0.0;
    
    g.moveTo( this.m_pos.x, this.m_pos.y );
    
    for (i in 0...iters)
    {
      p.setTo( radius, 0.0 );
    }
  }
  
}