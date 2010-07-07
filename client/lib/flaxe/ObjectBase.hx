package flaxe;

class ObjectBase
{
	public function new()
	{
		
	}
	
	public function toString():String
	{
		return this.to_string();
	}
	
	public function to_string():String
	{
		return "[flaxe:object]";
	}
}
