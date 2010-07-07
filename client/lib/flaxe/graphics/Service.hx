package flaxe.graphics;

class Service extends flaxe.ServiceBase
{
	public var render_event:flaxe.Event;
	
	public var width(get_width, never):Int;
	public var height(get_height, never):Int;
	
	public var buffer:flash.Vector<UInt>;
	public var screen:flash.display.BitmapData;
	public var bmp:flash.display.Bitmap;
	public var viewport:flaxe.graphics.Viewport;
	public var display:flaxe.graphics.Display;
	public var layer:flash.display.MovieClip;
	
	private var application:flaxe.Application;
	
	public function new(application:flaxe.Application)
	{
		super();
		
		this.render_event = new flaxe.Event();
	}
	
	public function set_display_dimensions(display_width:Int, display_height:Int, viewport_width:Int, viewport_height:Int)
	{
		// wait until the application is loaded before initializing
		this.application.load_event.add(this.setup_display);
	}
	
	private function setup_display(application:flaxe.Application):Void
	{
		var max_width:Int = application.layer.stage.stageWidth;
		var max_height:Int = application.layer.stage.stageHeight;
		
		var min_width:Int = cast(160 * (application.layer.stage.stageWidth/application.layer.stage.stageHeight), Int);
		var min_height:Int = 160;
		
		this.buffer = new flash.Vector<UInt>(min_width * min_height);
		
		this.resize_display(min_width, min_height, false);
		
		this.resize_viewport(max_width, max_height, true);
	}
	
	public function resize_display(width:Int, height:Int, ?rescale:Bool = true):Void
	{
		this.display = new flaxe.graphics.Display(width, height);

		this.screen = new flash.display.BitmapData(width, height, false, 0x000000);
		
		if(this.bmp != null)
			this.layer.removeChild(this.bmp);
		
		this.bmp = new flash.display.Bitmap(this.screen);
		this.bmp.smoothing = false;
		this.bmp.pixelSnapping = flash.display.PixelSnapping.ALWAYS;
		
		if(rescale)
			this.rescale();
		
		this.layer.addChild(this.bmp);
	}
	
	public function resize_viewport(width:Int, height:Int, ?rescale:Bool = true):Void
	{
		this.viewport = new flaxe.graphics.Viewport(0, 0, width, height);

		if(rescale)
			this.rescale();
	}
	
	public function rescale():Void
	{
		this.bmp.scaleX = this.viewport.width / this.display.width;
		this.bmp.scaleY = this.viewport.height / this.display.height;
	}
	
	public function get_width():Int
	{
		return this.display.width;
	}
	
	public function get_height():Int
	{
		return this.display.height;
	}
	
	public function draw():Void
	{
		this.screen.unlock();

		this.screen.setVector(this.screen.rect, this.display.memory.toVector(this.buffer));

		this.screen.lock();

		this.clear(0); // temp(daemn) not gonna need this when using tiles
		
		this.render_event.call_with([this]);
	}
	
	public function clear(color:UInt):Void
	{
		this.display.clear();
	}
}
