package flaxe.input;

class KeyState
{
	public var key_list:flash.Vector<Bool>;
	
	public function new()
	{
		this.key_list = new flash.Vector<Bool>(256, true);
		
		for(key in this.key_list)
			key = false;
	}
	
	public inline function is_key_down(key:Int):Bool
	{
		return this.key_list[key];
	}
	
	public inline function is_key_up(key:Int):Bool
	{
		return !this.key_list[key];
	}
	
	public inline function clone():KeyState
	{
		var state = new KeyState();

		for(i in 0...this.key_list.length)
			state.key_list[i] = this.key_list[i];
		
		return state;
	}
	
	public inline function clear():Void
	{
		for(key in this.key_list)
			key = false;
	}
}
