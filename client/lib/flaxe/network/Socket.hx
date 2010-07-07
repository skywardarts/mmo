package flaxe.network;

class Socket
{
	public var connect_successful_event:flaxe.Event;
	public var connect_failure_event:flaxe.Event;
	public var receive_successful_event:flaxe.Event;
	public var receive_failure_event:flaxe.Event;
	public var send_successful_event:flaxe.Event;
	public var send_failure_event:flaxe.Event;
	
	private var host:String;
	private var port:Int;
	
	private var socket:flash.net.Socket;

	private var data:flash.utils.ByteArray;
	
	public function new(host:String, port:Int)
	{
		this.data = new flash.utils.ByteArray();
		
		this.connect_successful_event = new flaxe.Event();
		this.connect_failure_event = new flaxe.Event();
		this.receive_successful_event = new flaxe.Event();
		this.receive_failure_event = new flaxe.Event();
		this.send_successful_event = new flaxe.Event();
		this.send_failure_event = new flaxe.Event();
		
		this.host = host;
		this.port = port;
		
		this.socket = new flash.net.Socket();
		this.socket.endian = flash.utils.Endian.LITTLE_ENDIAN;
		
		this.initialize();
	}
	
	public function initialize():Void
	{
		this.initialize_handler_list();
	}

	function initialize_handler_list():Void
	{
		this.socket.addEventListener(flash.events.Event.CLOSE, this.on_close);
		this.socket.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.on_error);
		this.socket.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.on_error);
		this.socket.addEventListener(flash.events.ProgressEvent.SOCKET_DATA, this.on_receive);
	}
	
	public function on_close(event:flash.events.Event):Void
	{
		trace("[flaxe:network:on_close] Socket disconnected.");
	}
	
	public function on_error(event:flash.events.Event):Void
	{
		trace("[flaxe:network:on_error] " + event);
	}
	
	public function on_receive(event:flash.events.Event):Void
	{
		trace("[flaxe:network:on_receive] " + event);
		
		this.receive();
	}
	
	public function connect(successful:Void->Void = null, failure:Void->Void = null):Void
	{
		var self = this;
		
		var connect_successful_handler:flash.events.Event->Void = null;
		var connect_failure_handler:flash.events.Event->Void = null;
		
		connect_successful_handler = function(e:flash.events.Event):Void
		{
			self.socket.removeEventListener(flash.events.Event.CONNECT, connect_successful_handler);
			self.socket.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, connect_successful_handler);
			self.socket.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, connect_successful_handler);
			
			if(successful != null)
				successful();
			else
				self.connect_successful_event.call([]);
		};
		
		connect_failure_handler = function(e:flash.events.Event):Void
		{
			self.socket.removeEventListener(flash.events.Event.CONNECT, connect_successful_handler);
			self.socket.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, connect_failure_handler);
			self.socket.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, connect_failure_handler);
			
			if(failure != null)
				failure();
			else
				self.connect_failure_event.call([]);
		};
		
		this.socket.addEventListener(flash.events.Event.CONNECT, connect_successful_handler);
		this.socket.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, connect_failure_handler);
		this.socket.addEventListener(flash.events.IOErrorEvent.IO_ERROR, connect_failure_handler);

		this.socket.connect(this.host, this.port);
	}
	
	public function send(data:flash.utils.ByteArray, successful:Void->Void = null, failure:Void->Void = null):Void
	{
		var self = this;
		// todo(daemn) check if connected
		
		this.socket.writeBytes(data);
		this.socket.flush();
		
		if(successful != null)
			successful();
		else
			this.send_successful_event.call([]);
	}
	
	public function receive(successful:Void->Void = null, failure:Void->Void = null):Void
	{
		if(this.socket.bytesAvailable > 0)
		{
			this.socket.readBytes(this.data, this.data.length);
			
			this.data.position = 0;
			
			trace("[flaxe:network:socket] Received data.");
			
			if(successful != null)
				successful();
			else
				this.receive_successful_event.call_with([this.data]);
		}
		else
		{

		}
	}
}
