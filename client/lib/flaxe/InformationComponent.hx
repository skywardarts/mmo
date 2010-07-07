package flaxe;

class InformationComponent
{
	//private var stage:Stage;
	var frames_elasped:Int;
	var ms_elasped:Int;
	var ms_threshold:Int;
	var start_real_time:Int;
	var mc:flash.display.MovieClip;
	var fps_title:flash.text.TextField;
	var ms_title:flash.text.TextField;
	var memory_title:flash.text.TextField;
	public var fps:Int;
	public var ms:Int;
	
	public function new(mc:flash.display.MovieClip, x:Float, y:Float, width:Float, height:Float)
	{
		//this.stage = mc.stage;
		
		this.frames_elasped = this.ms_elasped = 0;

		this.ms_threshold = 1000;
		
		this.mc = new flash.display.MovieClip();
		
		mc.addChild(this.mc);
		
		var text_glow:flash.filters.GlowFilter = new flash.filters.GlowFilter(0x333333, 1, 2, 2, 3, 2, false, false);

		this.fps_title = new flash.text.TextField();
		this.fps_title.x = x; this.fps_title.y = y;
		//this.fps_title.width = width; this.fps_title.height = height;
		this.fps_title.defaultTextFormat = new flash.text.TextFormat("_sans", 18, 0xFFFFFF, true, false, false);
		this.fps_title.filters = [text_glow];
		this.fps_title.selectable = false;
		//this.fps_title.antiAliasType = AntiAliasType.ADVANCED;
		//this.fps_title.gridFitType = GridFitType.NONE;
		
		this.mc.addChild(this.fps_title);
		
		this.ms_title = new flash.text.TextField();
		this.ms_title.x = x; this.ms_title.y = y + 30;
		//this.ms_title.width = width; this.ms_title.height = height;
		this.ms_title.defaultTextFormat = new flash.text.TextFormat("_sans", 18, 0xFFFFFF, true, false, false);
		this.ms_title.filters = [text_glow];
		this.ms_title.selectable = false;
		//this.ms_title.antiAliasType = AntiAliasType.ADVANCED;
		//this.ms_title.gridFitType = GridFitType.NONE;
		
		this.mc.addChild(this.ms_title);
		
		this.memory_title = new flash.text.TextField();
		this.memory_title.x = x; this.memory_title.y = y + 60;
		//this.memory_title.width = width; this.memory_title.height = height;
		this.memory_title.defaultTextFormat = new flash.text.TextFormat("_sans", 18, 0xFFFFFF, true, false, false);
		this.memory_title.filters = [text_glow];
		this.memory_title.selectable = false;
		//this.memory_title.antiAliasType = AntiAliasType.ADVANCED;
		//this.memory_title.gridFitType = GridFitType.NONE;
		
		this.mc.addChild(this.memory_title);
	}
	
	public inline function start(time:flaxe.core.Timestamp):Void
	{
		this.start_real_time = time.total_real_time;
	}
	
	public inline function stop(time:flaxe.core.Timestamp):Void
	{
		this.ms = time.total_real_time - this.start_real_time;
		
		this.ms_title.text = cast ms + " MS";
		
		++this.frames_elasped;

		this.ms_elasped += time.elapsed_real_time;

		if(this.ms_elasped >= this.ms_threshold)
		{
			this.fps = this.frames_elasped;
			
			this.fps_title.text = cast this.fps + " FPS";

			this.frames_elasped = 0;
			this.ms_elasped = 0;
		}
		
		this.memory_title.text = cast flash.system.System.totalMemory / 1024 / 1024 + " MB";
	}
	
	public function update(time:flaxe.core.Timestamp):Void
	{

	}

	public function draw(device:flaxe.graphics.Device):Void
	{

	}
}
