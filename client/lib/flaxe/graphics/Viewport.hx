package flaxe.graphics;

class Viewport
{
	public function new(?x:Int = 0, ?y:Int = 0, ?width:Int = 0, ?height:Int = 0, ?min_depth:Int = 0, ?max_depth:Int = 1)
	{
		this.x = x;
		this.y = y;
		
		this.width = width;
		this.height = height;
		
		this.min_depth = min_depth;
		this.max_depth = max_depth;
	}

	public inline function getAspect_ratio():Float
	{
		return this.height > 0 ? this.width / this.height : 0;
	}
	
	public inline function getTop():Int
	{
		return this.x;
	}
	
	public inline function getLeft():Int
	{
		return this.y;
	}
	
	public inline function getBottom():Int
	{
		return this.x + this.height;
	}
	
	public inline function getRight():Int
	{
		return this.y + this.width;
	}
	
	public inline function to_string():String
	{
		return "[viewport " + this.x + ", " + this.y + " width: " + this.width + " height: " + this.height + "]";
	}
	
	public var x:Int;
	public var y:Int;
	
	public var width:Int;
	public var height:Int;
	
	var min_depth:Float;
	var max_depth:Float;
}
