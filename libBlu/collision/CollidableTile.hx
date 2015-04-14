package libBlu.collision;

import libBlu._enum.Location;
import libBlu.collision.Collision;
import libBlu.collision.Locate2;
import libBlu.display.GameObject;
import libBlu.geom.Vec;

/**
 * ...
 * @author Shareef Raheem (Blufedora)
 */

typedef L = Locate2;
typedef LOC_POS = Location;
 
class CollidableTile extends GameObject
{	
	private var bottomCenter:Vec = new Vec();
	private var bottomRight:Vec = new Vec();
	private var bottomLeft:Vec = new Vec();
	private var topCenter:Vec = new Vec();
	private var topRight:Vec = new Vec();
	private var midRight:Vec = new Vec();
	private var midLeft:Vec = new Vec();
	private var topLeft:Vec = new Vec();
	private var center:Vec = new Vec();
	public var point:Array<Vec>;

	public function new(x:Float, y:Float, width:Float, height:Float) 
	{
		super(x, y, width, height);
		
		point = [
			topLeft, topCenter, topRight, 
			midLeft, midRight, center,
			bottomLeft, bottomCenter, bottomRight
		];
	}
	
	public function updatePoints():Void
	{
		var i = 0;
		for (p in point)
		{
			p.setEqual(L.pointLoc(this, L.LOC[i]));
			i++;
		}
	}
	
	//* Uses Sides
	public function topColliding(collider:GameObject):Bool
	{
		if (collider.bottom >= top && collider.bottom < bottom) return true;
		return false;
	}
	
	public function rightColliding(collider:GameObject):Bool
	{
		if (collider.left >= right && collider.left < left) return true;
		return false;
	}
	
	public function leftColliding(collider:GameObject):Bool
	{
		if (collider.right >= left && collider.right < right) return true;
		return false;
	}
	
	public function bottomColliding(collider:GameObject):Bool
	{
		if (collider.top >= bottom && collider.top < top) return true;
		return false;
	}
	
	//* Uses Points
	public function collide(collider:GameObject, position:EnumValue):Bool
	{
		switch(position)
		{
			//* Sides *//
			case LOC_POS.TOP:    return Collision.hitTestVec(collider, point[0]) || Collision.hitTestVec(collider, point[1]) || Collision.hitTestVec(collider, point[2]);
			case LOC_POS.BOTTOM: return Collision.hitTestVec(collider, point[6]) || Collision.hitTestVec(collider, point[7]) || Collision.hitTestVec(collider, point[8]);
			case LOC_POS.RIGHT:  return Collision.hitTestVec(collider, point[2]) || Collision.hitTestVec(collider, point[4]) || Collision.hitTestVec(collider, point[8]);
			case LOC_POS.LEFT:   return Collision.hitTestVec(collider, point[0]) || Collision.hitTestVec(collider, point[3]) || Collision.hitTestVec(collider, point[6]);
			
			//* Specific Points *//
			case LOC_POS.TOP_LEFT:     return Collision.hitTestVec(collider, point[0]);
			case LOC_POS.TOP_MID:      return Collision.hitTestVec(collider, point[1]);
			case LOC_POS.TOP_RIGHT:    return Collision.hitTestVec(collider, point[2]);
			case LOC_POS.MID_LEFT:     return Collision.hitTestVec(collider, point[3]);
			case LOC_POS.MID_RIGHT:    return Collision.hitTestVec(collider, point[4]);
			case LOC_POS.CENTER:       return Collision.hitTestVec(collider, point[5]);
			case LOC_POS.BOTTOM_LEFT:  return Collision.hitTestVec(collider, point[6]);
			case LOC_POS.BOTTOM_MID:   return Collision.hitTestVec(collider, point[7]);
			case LOC_POS.BOTTOM_RIGHT: return Collision.hitTestVec(collider, point[8]);
			
			case LOC_POS.CONTAINS: return Collision.hitTestVec(this, new Vec(collider.x, collider.y));
			default: return false;
		}
	}
	
}