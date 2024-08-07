package blufedora.animation;

class Easing
{
  private static var PI_M2 = Math.PI * 2.0;
  private static var PI_D2 = Math.PI * 0.5;

  /*
  Linear
  ---------------------------------------------------------------------------------
  */
  public static function easeLinear (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c*t/d + b;
  }

  /*
  Sine
  ---------------------------------------------------------------------------------
  */
  public static function easeInSine (t:Float, b:Float, c:Float, d:Float):Float
  {
    return -c * Math.cos(t/d * PI_D2) + c + b;
  }

  public static function easeOutSine (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c * Math.sin(t/d * PI_D2) + b;
  }

  public static function easeInOutSine (t:Float, b:Float, c:Float, d:Float):Float
  {
    return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
  }

  /*
  Quintic
  ---------------------------------------------------------------------------------
  */
  public static function easeInQuint (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c*(t/=d)*t*t*t*t + b;
  }

  public static function easeOutQuint (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c*((t=t/d-1)*t*t*t*t + 1) + b;
  }

  public static function easeInOutQuint (t:Float, b:Float, c:Float, d:Float):Float
  {
    if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
    return c/2*((t-=2)*t*t*t*t + 2) + b;
  }

  /*
  Quartic
  ---------------------------------------------------------------------------------
  */
  public static function easeInQuart (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c*(t/=d)*t*t*t + b;
  }

  public static function easeOutQuart (t:Float, b:Float, c:Float, d:Float):Float
  {
    return -c * ((t=t/d-1)*t*t*t - 1) + b;
  }

  public static function easeInOutQuart (t:Float, b:Float, c:Float, d:Float):Float
  {
    if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
    return -c/2 * ((t-=2)*t*t*t - 2) + b;
  }

  /*
  Quadratic
  ---------------------------------------------------------------------------------
  */
  public static function easeInQuad (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c*(t/=d)*t + b;
  }

  public static function easeOutQuad (t:Float, b:Float, c:Float, d:Float):Float
  {
    return -c *(t/=d)*(t-2) + b;
  }

  public static function easeInOutQuad (t:Float, b:Float, c:Float, d:Float):Float
  {
    if ((t/=d/2) < 1) return c/2*t*t + b;
    return -c/2 * ((--t)*(t-2) - 1) + b;
  }

  /*
  Exponential
  ---------------------------------------------------------------------------------
  */
  public static function easeInExpo (t:Float, b:Float, c:Float, d:Float):Float
  {
    return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
  }

  public static function easeOutExpo (t:Float, b:Float, c:Float, d:Float):Float
  {
    return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
  }

  public static function easeInOutExpo (t:Float, b:Float, c:Float, d:Float):Float
  {
    if (t==0) return b;
    if (t==d) return b+c;
    if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
    return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
  }

  /*
  Elastic
  ---------------------------------------------------------------------------------
  */
  public static function easeInElastic (t:Float, b:Float, c:Float, d:Float, a:Null<Float>=null, p:Null<Float>=null):Float
  {
    var s:Float;
    if (t==0) return b;  if ((t/=d)==1) return b+c;  if (p == null) p=d*.3;
    if (a == null || a < Math.abs(c)) { a=c; s=p/4; }
    else s = p/PI_M2 * Math.asin (c/a);
    return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*PI_M2/p )) + b;
  }

  public static function easeOutElastic (t:Float, b:Float, c:Float, d:Float, a:Null<Float>=null, p:Null<Float>=null):Float
  {
    var s:Float;
    if (t==0) return b;  if ((t/=d)==1) return b+c;  if (p == null) p=d*.3;
    if (a == null || a < Math.abs(c)) { a=c; s=p/4; }
    else s = p/PI_M2 * Math.asin (c/a);
    return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*PI_M2/p ) + c + b);
  }

  public static function easeInOutElastic (t:Float, b:Float, c:Float, d:Float, a:Null<Float>=null, p:Null<Float>=null):Float
  {
    var s:Float;
    if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (p == null) p=d*(.3*1.5);
    if (a == null || a < Math.abs(c)) { a=c; s=p/4; }
    else s = p/PI_M2 * Math.asin (c/a);
    if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*PI_M2/p )) + b;
    return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*PI_M2/p )*.5 + c + b;
  }

  /*
  Circular
  ---------------------------------------------------------------------------------
  */
  public static function easeInCircular (t:Float, b:Float, c:Float, d:Float):Float
  {
    return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
  }

  public static function easeOutCircular (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
  }

  public static function easeInOutCircular (t:Float, b:Float, c:Float, d:Float):Float
  {
    if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
    return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
  }

  /*
  Back
  ---------------------------------------------------------------------------------
  */
  public static function easeInBack (t:Float, b:Float, c:Float, d:Float, s:Float=1.70158):Float
  {
    return c*(t/=d)*t*((s+1)*t - s) + b;
  }

  public static function easeOutBack (t:Float, b:Float, c:Float, d:Float, s:Float=1.70158):Float
  {
    return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
  }

  public static function easeInOutBack (t:Float, b:Float, c:Float, d:Float, s:Float=1.70158):Float
  {
    if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
    return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
  }

  /*
  Bounce
  ---------------------------------------------------------------------------------
  */
  public static function easeInBounce (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c - easeOutBounce (d-t, 0, c, d) + b;
  }

  public static function easeOutBounce (t:Float, b:Float, c:Float, d:Float):Float
  {
    if ((t/=d) < (1/2.75))
    {
      return c*(7.5625*t*t) + b;
    }
    else if (t < (2/2.75))
    {
      return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
    }
    else if (t < (2.5/2.75))
    {
      return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
    }
    else {
      return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    }
  }

  public static function easeInOutBounce (t:Float, b:Float, c:Float, d:Float):Float
  {
    if (t < d/2) return easeInBounce (t*2, 0, c, d) * .5 + b;
    else return easeOutBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
  }

  /*
  Cubic
  ---------------------------------------------------------------------------------
  */
  public static function easeInCubic (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c*(t/=d)*t*t + b;
  }

  public static function easeOutCubic (t:Float, b:Float, c:Float, d:Float):Float
  {
    return c*((t=t/d-1)*t*t + 1) + b;
  }

  public static function easeInOutCubic (t:Float, b:Float, c:Float, d:Float):Float
  {
    if ((t/=d/2) < 1) return c/2*t*t*t + b;
    return c/2*((t-=2)*t*t + 2) + b;
  }
}