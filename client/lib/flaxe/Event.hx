package flaxe;

class Event
{
	private var list:List<Dynamic>;
	private var forward:Bool;
	private var forward_argument_list:Array<Dynamic>;
	
	public function new()
	{
		this.forward = false;
		this.list = new List<Dynamic>();
	}
	
	public function call():Void
	{
		for(pair in this.list)
		{
			var handler = pair[0];
			var custom_argument_list:Array<Dynamic> = cast pair[1];
			
			// invoke the event with the custom argument list
			if(custom_argument_list.length > 0)
				Reflect.callMethod({}, handler, custom_argument_list);
			// invoke the event with this object
			else
				Reflect.callMethod( { }, handler, [this]);
		}
	}
	
	public function call_with(argument_list:Array<Dynamic>, completed:Bool = false):Void
	{
		for(pair in this.list)
		{
			var handler = pair[0];
			var custom_argument_list:Array<Dynamic> = cast pair[1];
			
			// invoke the event with the custom argument list
			if(custom_argument_list.length > 0)
				Reflect.callMethod({}, handler, custom_argument_list);
			// invoke the event with the specified argument list
			else
				Reflect.callMethod({}, handler, argument_list);
		}

		if(completed)
		{
			this.forward = true;
			this.forward_argument_list = argument_list;
		}
	}
	
	public function add(handler:Dynamic, custom_argument_list:Array<Dynamic> = null):Void
	{
		if(custom_argument_list == null)
			custom_argument_list = [];
			
		// this event has passed so we'll just pass it along
		if(this.forward)
		{
			// invoke the event with the custom argument list
			if(custom_argument_list != null)
				Reflect.callMethod({}, handler, custom_argument_list);
			// invoke the event with the last argument list used to invoke
			else
				Reflect.callMethod({}, handler, this.forward_argument_list);
		}
		// this event hasn't been called yet or is on an interval so we'll add it to the waiting list
		else
			this.list.add([handler, custom_argument_list]);
	}
	
	public function remove(handler:Dynamic):Void
	{
		//this.list.remove(handler);
	}
}
