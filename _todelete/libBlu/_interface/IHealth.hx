package libBlu._interface;

/**
 * @author Shareef Raheem (Blufedora)
 */
interface IHealth 
{
  public var health:Float;
  public var damage:Float;
  
  public function giveHealth(damage:Float):Void;
  public function takeDamage(damage:Float):Void;
}