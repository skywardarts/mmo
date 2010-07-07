package flaxe.game;

class World
{
	public function new()
	{
		this.player_list = new List<flaxe.game.Player>();
		this.object_list = new List<flaxe.game.Object>();
		this.npc_list = new List<flaxe.game.NPC>();
	}

	public inline function get_player_by_id(id:Int):flaxe.game.Player
	{
		for(player in this.player_list)
		{
			if(player.id == id)
				return player;
		}
		
		throw "Player not found";
	}
	
	public inline function add_player(player:flaxe.game.Player):player:flaxe.game.Player
	{
		this.player_list.add(player);
		
		return player;
	}
	
	public inline function remove_player(player:flaxe.game.Player):player:flaxe.game.Player
	{
		this.player_list.remove(player);
		
		return player;
	}
	
	public inline function add_object(object:flaxe.game.Object):flaxe.game.Object
	{
		this.object_list.add(object);
		
		return object;
	}

	public function draw(device:flaxe.graphics.Service):Void
	{
		for(object in this.object_list)
		{
			if(object.x + object.width >= this.scene.camera.x - device.width / 2
			   && object.y + object.height >= this.scene.camera.y - device.height / 2
			   && object.x - object.width <= this.scene.camera.x + device.width / 2
			   && object.y - object.height <= this.scene.camera.y + device.height / 2)
			{
				this.scene.add_model(object.model);
			}
		}
		
		for(player in this.player_list)
		{
			if(player.x + player.width >= this.scene.camera.x - device.width / 2
			   && player.y + player.height >= this.scene.camera.y - device.height / 2
			   && player.x - player.width <= this.scene.camera.x + device.width / 2
			   && player.y - player.height <= this.scene.camera.y + device.height / 2)
			{
				this.scene.add_model(player.model);
			}
		}
		
		for(npc in this.npc_list)
		{
			if(npc.x + npc.width >= this.scene.camera.x - device.width / 2
			   && npc.y + npc.height >= this.scene.camera.y - device.height / 2
			   && npc.x - npc.width <= this.scene.camera.x + device.width / 2
			   && npc.y - npc.height <= this.scene.camera.y + device.height / 2)
			{
				this.scene.add_model(npc.model);
			}
		}
		
		this.scene.draw(device);
	}
	
	public function update(time:flaxe.core.Timestamp):Void
	{
		for(object in this.object_list)
		{
			object.update(time);
		}
				
		for(player in this.player_list)
		{
			player.update(time);
		}
			
		for(npc in this.npc_list)
		{
			npc.update(time);
		}
		
		this.scene.update(time);
	}
	
	public var scene:flaxe.graphics.Scene<flaxe.graphics.Object>;
	public var object_list:List<flaxe.game.Object>;
	public var player_list:List<flaxe.game.Player>;
	public var npc_list:List<flaxe.game.NPC>;
	
}
