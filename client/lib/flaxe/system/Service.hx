package flaxe.system;

class Service extends flaxe.ServiceBase
{
	public function new(application:flaxe.Application)
	{
		super();
	}
	
	public function allocate_memory(x:Int, y:Int):Void
	{
		de.polygonal.ds.mem.MemoryManager.allocate(1024 * 50, 1024 * 50);
	}
}