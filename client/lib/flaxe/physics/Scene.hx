package flaxe.physics;

class Scene
{
	public function new()
	{
		this.object_list = new haxe.FastList<flaxe.physics.ObjectBase>();
	}
	
	public inline function add_object(model:flaxe.physics.ObjectBase):Void
	{
		this.object_list.add(model);
	}

	public inline function remove_object(model:flaxe.physics.ObjectBase):Void
	{
		this.object_list.remove(model);
	}

	public function update(time:flaxe.core.Timestamp):Void
	{

	}
	
	private var object_list:haxe.FastList<flaxe.physics.ObjectBase>;
}
