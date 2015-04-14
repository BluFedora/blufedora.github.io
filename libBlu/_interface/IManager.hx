package libBlu._interface;


/**
 * Interface for the Manager Classes
 * @author Shareef Raheem (Blufedora)
 */
interface IManager 
{
	public var itemList:Array<Dynamic>;	
	public var itemName:Array<String>;
	
	public function addItem(object:Dynamic):Void;
	public function removeItem(object:Dynamic):Void;
	public function getItem(name:String, ?index:Int):Dynamic;
	
	public function clear():Void;
}