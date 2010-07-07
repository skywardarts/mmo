package flaxe;

class ServiceBase
{
	public function new()
	{
	
	}
	
	public function post(handler:Dynamic, arguments:Array<Dynamic>)
	{
		// todo(daemn) add to an event list, record times, threading or anything else
		
		Reflect.callMethod({}, handler, arguments);
	}
}
