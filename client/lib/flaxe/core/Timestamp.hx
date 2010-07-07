package flaxe.core;

class Timestamp
{
	public var total_real_time:Int;
	public var elapsed_real_time:Int;
	
	public var total_flash_time:Int;
	public var elapsed_flash_time:Int;

	public function new(?total_real_time:Int = 0, ?elapsed_real_time:Int = 0, ?total_flash_time:Int = 0, ?elapsed_flash_time:Int = 0)
	{
		this.total_real_time = total_real_time;
		this.elapsed_real_time = elapsed_real_time;
		this.total_flash_time = total_flash_time;
		this.elapsed_flash_time = elapsed_flash_time;
	}

	public inline function getIs_running_slowly():Bool
	{
		return false;
	}
	
	public inline function clone():Timestamp
	{
		return new Timestamp(this.total_real_time, this.elapsed_real_time, this.total_flash_time, this.elapsed_flash_time);
	}
}

