package mmo;
import flaxe.Event;

class MainUI
{
	public var register_event:flaxe.Event;
	
	public function new()
	{
		this.register_event = new flaxe.Event();
	}
	
	public function initialize()
	{
			var console = new haxegui.Console(flash.Lib.current);
			console.init({x: 120, y: 300});

			haxe.Log.clear();
			haxe.Log.trace = cast console.log;
			
			Reflect.setField(flash.Lib.current, "ui", this);

            var xml_loader = new flash.net.URLLoader();
			
            xml_loader.addEventListener(flash.events.Event.COMPLETE, function(event:flash.events.Event):Void
			{
				try
				{
					var register_event:flaxe.Event = new flaxe.Event();
					haxegui.managers.LayoutManager.loadLayouts(Xml.parse(event.target.data));
					haxegui.managers.LayoutManager.setLayout(Xml.parse(event.target.data).firstElement().get("name"));
				} 
				catch(error:Dynamic)
				{
					trace("Could not parse the XML");
					trace(Std.string(error));
				}
			});
			
            xml_loader.load(new flash.net.URLRequest("MainUI.xml"));
	}
}