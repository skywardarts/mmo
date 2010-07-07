package flaxe.game;

class NPC extends flaxe.game.Object
{
	public var changed(getChanged, setChanged):Bool;
	
	public function new()
	{
		super();
		
		this.name = "Undefined";
	}

	public override function getChanged():Bool
	{
		if(this.model.changed)
			return true;
			
		return false;
	}
	
	public override function setChanged(changed_:Bool):Bool
	{
		this.model.changed = changed_;
		
		return changed_;
	}
	
	public var name:String;
}
