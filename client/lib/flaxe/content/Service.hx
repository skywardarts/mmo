package flaxe.content;

class Service extends flaxe.ServiceBase
{
	private var application:flaxe.Application;
	private var asset_list:Hash<Dynamic>;
	
	public function new(application:flaxe.Application)
	{
		super();
		
		this.application = application;
		
		this.asset_list = new Hash<Dynamic>();
	}
	
	public inline function set_asset(name:String, value:Dynamic)
	{
		this.asset_list.set(name, value);
	}
	
	public inline function get_asset(name:String)
	{
		this.begin_get_asset_event.call_with([name]);
		
		return this.asset_list.get(name);
	}
}