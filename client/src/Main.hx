package;

import flash.net.URLVariables;
import Global;

class Main 
{
	public static function main() 
	{
		haxe.Log.setColor(0xFFFFFF);
		haxegui.Haxegui.init();
		
		var main_ui = new mmo.MainUI();
		
		main_ui.initialize();
		
		main_ui.register_event.add(function(username:String, password:String):Void
		{
			trace(username);
			
			var url = "http://stokegames.com/mmo/register";
			
            var loader = new flash.net.URLLoader();
			
            loader.addEventListener(flash.events.Event.COMPLETE, function(event:flash.events.Event):Void
			{
				trace(event);
			});
			
			var r1 = new flash.net.URLRequest(url);
			
			var data:URLVariables = new flash.net.URLVariables();
			data.username = username;
			data.password = password;
			
			r1.data = data;
			r1.method = flash.net.URLRequestMethod.POST;

            loader.load(r1);
		});
	}
}