package flaxe.math;

class Vector2
{
	public var x(getX, setX):Int;
	public var y(getY, setY):Int;
	
	public function new(?x_:Int = 0, ?y_:Int = 0)
	{
		this.x_ = x_;
		this.y_ = y_;
		
		this.changed = true;
	}

	public static inline function getBlank():Vector2 { return new Vector2(); }
	
	public static inline function getUp():Vector2 { return new Vector2(0, 1); }
	public static inline function getDown():Vector2 { return new Vector2(0, -1); }
	
	public static inline function getLeft():Vector2 { return new Vector2(-1, 0); }
	public static inline function getRight():Vector2 { return new Vector2(1, 0); }
	
	public static inline function getUnit_x():Vector2 { return new Vector2(1, 0); }
	public static inline function getUnit_y():Vector2 { return new Vector2(0, 1); }
	
	public static inline function getZero():Vector2 { return new Vector2(0, 0); }
	public static inline function getOne():Vector2 { return new Vector2(1, 1); }
	
	public inline function getX():Int
	{
		return this.x_;
	}
	
	public inline function setX(x_:Int):Int
	{
		if(this.x_ != x_)
		{
			this.x_ = x_;

			this.changed = true;
		}
		
		return x_;
	}
	
	public inline function getY():Int
	{
		return this.y_;
	}
	
	public inline function setY(y_:Int):Int
	{
		if(this.y_ != y_)
		{
			this.y_ = y_;

			this.changed = true;
		}
		
		return y_;
	}
	
	public inline function clone():Vector2
	{
		return new Vector2(this.x_, this.y_);
	}
	
	var x_:Int;
	var y_:Int;
	
	public var changed:Bool;
}
