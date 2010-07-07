package flaxe.graphics;

class Camera2
{
	public var x(get_x, set_x):Int;
	public var y(get_y, set_y):Int;
	public var target(get_target, set_target):flaxe.graphics.Object;
	
	public function new(x_:Int, y_:Int)
	{
		this.position = new flaxe.math.Vector2(x_, y_);
	}
	
	public function update(time:flaxe.core.Timestamp):Void
	{
		if(this.target_ != null)
		{
			this.position.x = this.target_.position.x;
			this.position.y = this.target_.position.y;
			
			//trace("cam: " + this.position.x + " / " + this.position.y);
		}
	}
	
	public inline function get_x():Int
	{
		return this.position.x;
	}
	
	public inline function set_x(x_:Int):Int
	{
		this.position.x = x_;
		
		return x_;
	}
	
	public inline function get_y():Int
	{
		return this.position.y;
	}
	
	public inline function set_y(y_:Int):Int
	{
		this.position.y = y_;
		
		return y_;
	}
	
	public inline function get_target():flaxe.graphics.Object
	{
		return this.target_;
	}
	
	public inline function set_target(target_:flaxe.graphics.Object):flaxe.graphics.Object
	{
		this.target_ = target_;
		
		return this.target_;
	}
	
	public var target_:flaxe.graphics.Object;
	public var position:flaxe.math.Vector2;
}
