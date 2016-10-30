package libBlu._v2 ;


class Physics
{
	public static inline var GRAVITY:Float = .25;
	public static inline var FRICTION:Float = .96;
	public static inline var JUMP_POWER:Float = 11;
	
	public static inline var MAX_VELOCITY_X:Float = 1.8;
	public static inline var MAX_VELOCITY_Y:Float = 10;
	
	//public static var xml:Xml = Xml.parse(Assets.getText("assets/Physics.xml"));
	//public static var fast = new Fast(xml.firstElement());
	
	public static function updateVars():Void
	{
		/*if (FileSystem.exists("assets/Physics.xml"))
		{
			if (xml.toString() != Assets.getText("assets/Physics.xml").toString())
			{
				xml = Xml.parse(Assets.getText("assets/Physics.xml"));
				fast = new Fast(xml.firstElement());
				trace("Physics: Updated Physics Variables");
			}
		}*/
	}
	
	public static function G():Float
	{
		//if (FileSystem.exists("assets/Physics.xml"))
		//	return Std.parseFloat(fast.node.physics.node.gravity.innerData);
		//else
			return GRAVITY;
	}
	
	public static function F():Float
	{
		//if (FileSystem.exists("assets/Physics.xml"))
		//	return Std.parseFloat(fast.node.physics.node.friction.innerData);
		//else
			return FRICTION;
	}
	
	public static function J():Float
	{
		//if (FileSystem.exists("assets/Physics.xml"))
		//	return Std.parseFloat(fast.node.physics.node.jumpPower.innerData);
		//else
			return JUMP_POWER;
	}
	
	public static function VX():Float
	{
		//if (FileSystem.exists("assets/Physics.xml"))
		//	return Std.parseFloat(fast.node.physics.node.maxVelocityX.innerData);
		//else
			return MAX_VELOCITY_Y;
	}
	
	public static function VY():Float
	{
		//if (FileSystem.exists("assets/Physics.xml"))
		//	return Std.parseFloat(fast.node.physics.node.maxVelocityY.innerData);
		//else
			return MAX_VELOCITY_Y;
	}
}