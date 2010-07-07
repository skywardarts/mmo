package flaxe.network;

class SendEvent
{
	public var client:flaxe.network.Client;
	public var message:falxe.network.Message;
	
	public function new(client:flaxe.network.Client, message:falxe.network.Message)
	{
		this.client = client;
		this.message = message;
	}
}

class ReceiveEvent
{
	public var client:flaxe.network.Client;
	
	public function new(client:flaxe.network.Client)
	{
		this.client = client;
	}
}

class Service extends flaxe.ServiceBase
{
	public var send_event_list:List<SendEvent>;
	public var receive_event_list:List<ReceiveEvent>;
	
	public function new()
	{
		super();
	}
	
	public function client_send_message(client:flaxe.network.Client, message:flaxe.network.Message)
	{
		this.send_event_list.push(new SendEvent(client, message));
	}
	
	public function client_receive_message(client:flaxe.network.Client)
	{
		this.receive_event_list.push(new ReceiveEvent(client));
	}
	
	public function update()
	{
		for(event in this.send_event_list)
		{
			event.client.send(message);
		}
		
		for(event in this.receive_event_list)
		{
			event.client.receive();
		}
	}
}
