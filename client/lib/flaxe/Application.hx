package flaxe;
import flash.display.MovieClip;
import flaxe.system.Service;

class Application
{
	public var load_event:flaxe.Event;
	public var activate_event:flaxe.Event;
	public var deactivate_event:flaxe.Event;
	public var begin_update_event:flaxe.Event;
	public var begin_end_event:flaxe.Event;
	public var end_update_event:flaxe.Event;
	public var end_end_event:flaxe.Event;
	
	public var fullscreen(get_fullscreen, set_fullscreen):Bool;
	
	private var active:Bool;
	private var initialized:Bool;
	
	public var layer:flash.display.MovieClip;

	private var domain:String;
	private var url:String;
	
	public var input_service:flaxe.input.Service;
	public var graphics_service:flaxe.graphics.Service;
	public var system_service:flaxe.system.Service;
	public var content_service:flaxe.content.Service;
	
	private var timer:flaxe.core.Timer;
	
	public function new(layer:flash.display.MovieClip)
	{
		this.load_event = new flaxe.Event();
		this.activate_event = new flaxe.Event();
		this.deactivate_event = new flaxe.Event();
		this.begin_update_event = new flaxe.Event();
		this.begin_end_event = new flaxe.Event();
		
		this.initialized = false;
		this.active = false;
		this.timer = new flaxe.core.Timer();
		
		this.layer = new flash.display.MovieClip();
		this.layer.x = 0;
		this.layer.y = 0;

		layer.addChild(this.layer);
	
		this.layer.addEventListener(flash.events.Event.ENTER_FRAME, this.main);
	}

	public function initialize():Void
	{
		this.initialize_settings();
		
		this.graphics_service = new flaxe.graphics.Service(this);
		this.input_service = new flaxe.input.Service(this);
		this.system_service = new flaxe.system.Service(this);
		this.content_service = new flaxe.content.Service(this);
		
		this.graphics_service.set_display_dimensions(240, 160, 1024, 800);
		this.system_service.allocate_memory(1024 * 50, 1024 * 50);
		
		this.layer.stage.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.on_mouse_wheel);
		this.layer.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, this.on_key_down);
		this.layer.stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, this.on_key_up);
		this.layer.stage.addEventListener(flash.events.Event.RESIZE, this.on_resize);
		this.layer.stage.addEventListener(flash.events.Event.DEACTIVATE, this.on_deactivate);
		this.layer.stage.addEventListener(flash.events.Event.ACTIVATE, this.on_activate);
	}
	
	public function initialize_settings():Void
	{
		haxe.Log.setColor(0xFFFFFF);
		
		this.layer.stage.showDefaultContextMenu = false;
		this.layer.stage.quality = flash.display.StageQuality.HIGH;
		this.layer.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		this.layer.stage.align = flash.display.StageAlign.TOP_LEFT;
		this.layer.stage.frameRate = 100;

		this.domain = new flash.net.LocalConnection().domain;
		
		flash.system.Security.allowDomain("*");
		flash.system.Security.allowInsecureDomain("*");
		
		trace("[flaxe_application] Attempting to load privacy file (" + this.domain + ":" + 843 + ").");
		
		flash.system.Security.loadPolicyFile("xmlsocket://" + this.domain + ":" + "843");
		
		this.url = this.layer.loaderInfo.url;
	}

	public function on_mouse_wheel(e:flash.events.MouseEvent):Void
	{
		var width_step:Int = cast(-e.delta * (240 / 160) * 30, Int);
		var height_step:Int = cast(width_step * (this.layer.stage.stageHeight/this.layer.stage.stageWidth), Int);
		
		var width:Int = this.graphics_service.width + width_step;
		var height:Int = this.graphics_service.height + height_step;
		
		var max_width:Int = this.layer.stage.stageWidth;
		var max_height:Int = this.layer.stage.stageHeight;
		
		var min_width:Int = cast(160 * (this.layer.stage.stageWidth / this.layer.stage.stageHeight), Int);
		var min_height:Int = 160;
		
		trace("stage: " + this.layer.stage.stageWidth + "/" + this.layer.stage.stageHeight + " min: " + min_width + "/" + min_height + " max: " + max_width + "/" + max_height + " norm: " + width + "/" + height);
		
		if(width > max_width)
			width = max_width;
		else if(width < min_width)
			width = min_width;
		
		if(height > max_height)
			height = max_height;
		else if(height < min_height)
			height = min_height;
		
		this.graphics_service.resize_display(width, height);
	}
	
	public function on_key_down(e:flash.events.KeyboardEvent):Void
	{
		this.input_service.set_key_down(e.keyCode);
	}

	public function on_key_up(e:flash.events.KeyboardEvent):Void
	{
		if(e.keyCode == flaxe.input.KeyCode.F11)
		{
			if(this.fullscreen)
				this.fullscreen = false;
			else
				this.fullscreen = true;
		}
		else
			this.input_service.set_key_up(e.keyCode);
	}
	
	public function on_resize(e:flash.events.Event):Void
	{
		trace("[flaxe:core_application] Resizing.");
		
		this.active = true;
		
		this.graphics_service.resize_viewport(this.layer.stage.stageWidth, this.layer.stage.stageHeight);
	}
	
	public function on_activate(e:flash.events.Event):Void
	{
		trace("[flaxe:core_application] Activating.");
		
		this.active = true;
	}
	
	public function on_deactivate(e:flash.events.Event):Void
	{
		trace("[flaxe:core_application] Deactivating.");
		
		this.active = false;
		
		this.input_service.clear();
	}
	
	public function get_fullscreen():Bool
	{
		return this.layer.stage.displayState == flash.display.StageDisplayState.FULL_SCREEN;
	}
	
	public function set_fullscreen(value:Bool):Bool
	{
		if(value && !this.fullscreen)
		{
			trace("[flaxe:core_application] Fullscreen enabled.");
			
			this.layer.stage.displayState = flash.display.StageDisplayState.FULL_SCREEN;
		}
		else if(!value && this.fullscreen)
		{
			trace("[flaxe:core_application] Fullscreen disabled.");
			
			this.layer.stage.displayState = flash.display.StageDisplayState.NORMAL;
		}
		
		return value;
	}
	
	public function main(e:flash.events.Event):Void
	{
		// application doesn't start activated
		if(this.active)
		{
			this.timer.update();
			
			this.begin_update_event.call_with([this.timer.current_time]);
			
			this.timer.update();
			
			this.end_update_event.call_with([this.timer.current_time]);
		}
		else
		{
			// initialize all the key components and memory
			if(!this.initialized)
			{
				this.initialized = true;
				
				this.initialize();
				
				// now we can set the application loose
				this.active = true;
				
				this.load_event.call_with([this], true);
			}
		}
	}
	
	public function initialize_input():Void
	{
		
	}
	
	public function get_layer():MovieClip
	{
		return this.layer;
	}
	/*
	////////////////////// main
	
	var client = new Client(application, application.graphics_service, application.network_service, application.input_service);

	///////////////////// client

	this.application.add_event_handler(flaxe.core.events.APPLICATION_UPDATE, function()
	{
		self.world.update();
	});

	this.game_server = new flaxe.network.Socket(this.application.network_service);

	////////////////// game_service
	
	this.application.add_event_handler(flaxe.core.events.APPLICATION_INITIALIZED, function()
	{
		//self.init
	});
	
	class flaxe.ServiceBase
	{
		function post(handler:Dynamic, arguments:Array<Dynamic>) { Reflect.callMethod({}, handler, arguments); }
	}

	class flaxe.network.Service extends flaxe.ServiceBase
	{
		
	}
	
	///////////////// 
	
	class flaxe.game.events // enum events
	{
		public static var KEEP_ALIVE = 1;
		public static var CREATE_WORLD = 2;
		public static var UPDATE_WORLD = 3;
		public static var REMOVE_WORLD = 4;
		public static var CREATE_OBJECT = 5;
		public static var UPDATE_OBJECT = 5;
		public static var REMOVE_OBJECT = 6;
		public static var CREATE_PLAYER = 7;
		public static var UPDATE_PLAYER = 8;
		public static var REMOVE_PLAYER = 9;
		public static var CHAT_MESSAGE = 10;
	}
	
	///////////////// 
	
	class flaxe.network.events // enum events
	{
		public static var SOCKET_CONNECT_SUCCESSFUL = 1;
		public static var SOCKET_CONNECT_FAILURE = 2;
		public static var SOCKET_SEND_SUCCESSFUL = 3;
		public static var SOCKET_SEND_FAILURE = 4;
		public static var SOCKET_RECEIVE_SUCCESSFUL = 5;
		public static var SOCKET_RECEIVE_FAILURE = 6;
		public static var SOCKET_DISCONNECT = 7;
	}
	
	///////////////// 
	
	class flaxe.graphics.events // enum events
	{
		public static var SCENE_RENDER = 1;
	}
	
	/////////////// client... game_server:flaxe.network.Socket
	
	this.game_server.add_event_handler(flaxe.network.events.SOCKET_RECEIVE_SUCCESSFUL, function()
	{
		event_id = read
		event_length = read
		event_data = read
		
		switch(event_id)
		{
			case flaxe.game.events.CREATE_WORLD:
			
			
			case flaxe.game.events.CREATE_PLAYER:
				player_id = readInt
				name_length = readInt
				player_name = readUTFBytes
				
				for(event in self.events[flaxe.game.events.ADD_PLAYER])
					self.game_service.post(event, [player_id, player_name]);
			
			case flaxe.game.events.REMOVE_PLAYER:
				player_id = readInt
				
				self.remove_player_event.call(player_id);
			
			case 5:
				request_id =
				
			
			case flaxe.game.events.CHAT_MESSAGE:
				player_id = readInt
				message_length = readInt
				message_text = readUTFBytes
				
				for(event in self.events[flaxe.game.events.CHAT_MESSAGE])
					event(player_id, message_length, message_text);

				// todo(daemn) parse message text for linked items/etc.
		}
	}
	
	// client
	on_add_player():Void
	{
		
	}
	
	this.client.add_player_event.add(function()
	{
		
	});
	
	
	this.game_server.recieve_successful_event.add(function()
	{
		
	});

	
	var recieve_successful_event:flaxe.Event<Void->Void>;
	
	
	var add_player_event:flaxe.Event<Void->Int->String>;
	
	self.recieve_successful_event.call(); //call just goes through list
	
	//////////////////// client... world:flaxe.game.World
	
	var self = this;
	
	this.game_service.add_event_handler(flaxe.game.events.ADD_PLAYER, function(player_id:int, player_name:String)
	{
		self.world.add_player(new flaxe.game.Player(id, name));
	});
	
	this.game_service.add_event_handler(flaxe.game.events.CHAT_MESSAGE, function(player_id:int, message_text:String)
	{
		var player = self.world.find_player(player_id);
		
		self.chat.text += player.name + ": " + message_text;
	});
	
	this.game_service.add_event_handler(flaxe.game.events.ADD_WORLD, function()
	{
		if(self.world != null)
		{
			// todo(daemn) cleanup
		}
		
		self.world = new flaxe.game.World();
	});
	
	// physics_service
	
	
	/////////////////// client... application:flaxe.Application
	
	this.graphics_service.add_event_handler(flaxe.graphics.events.RENDER, client.draw);
	
	
	
	this.input_service.add_event_handler(flaxe.input.events.KEY_DOWN, function(key:flaxe.input.KeyCode)
	{
		
	});
	
	*/
	
}
