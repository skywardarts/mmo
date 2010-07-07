import flash.system.System;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.getTimer;
import flash.events.Event;
/*
public class SceneStatisticsComponent extends drawable_component
{
	public var VisibleModels:uint;
	public var InvisibleModels:uint;
	public var CulledModels:uint;
	public var TotalModels:uint;

	public var VisiblePrimitives:uint;
	public var InvisiblePrimitives:uint;
	public var CulledPrimitives:uint;
	public var TotalPrimitives:uint;
	
	public var VisibleVertices:uint;
	public var InvisibleVertices:uint;
	public var CulledVertices:uint;
	public var TotalVertices:uint;
	
	private var mc:MovieClip;
	private var txt:TextField;

	public function SceneStatistics(parent:MovieClip, x:Number, y:Number, width:Number, height:Number)
	{
		this.Reset();
		
		this.Visible = true;
		this.Active = true;
		
		this.mc = new MovieClip();
		
		parent.addChild(this.mc);
		
		this.txt = new TextField();
		this.txt.x = x; this.txt.y = y;
		this.txt.width = width; this.txt.height = height;
		this.txt.defaultTextFormat = new TextFormat("Verdana", 35, 0xFF0000, false, false, false);
		this.txt.selectable = false;
		
		this.mc.addChild(this.txt);
	}

	public function Reset():void
	{
		this.VisibleModels = 0;
		this.InvisibleModels = 0;
		this.CulledModels = 0;
		this.TotalModels = 0;

		this.VisiblePrimitives = 0;
		this.InvisiblePrimitives = 0;
		this.CulledPrimitives = 0;
		this.TotalPrimitives = 0;

		this.VisibleVertices = 0;
		this.InvisibleVertices = 0;
		this.CulledVertices = 0;
		this.TotalVertices = 0;
	}
	
	public override function Update(time:Time):void
	{
		this.txt.text = this.VisiblePrimitives.toString();
	}
}*/
