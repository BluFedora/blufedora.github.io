package com.blufedora.gfx;
import com.blufedora.IAnimObject;

/**
 * ...
 * @author BluFedora (Shareef Raheem)
 */
class Canvas 
{
	private var _children:Array<IAnimObject> = [];

	public function new() 
	{
	}
	
	public function addChild(child:IAnimObject):Void
	{
		this._children.push(child);
	}
	
	public function render(ctx)
	{
		for (object in this._children)
		{
			
		}
	}
}