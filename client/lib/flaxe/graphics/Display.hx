package flaxe.graphics;

class Display
{
	public var width:Int;
	public var height:Int;
	public var memory:de.polygonal.ds.mem.IntMemory;
	public var buffer:flash.Vector<UInt>;
	
	public function new(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;
		
		this.memory = de.polygonal.ds.mem.MemoryManager.getIntMemory(width * height);
		
		var bmp = new flash.display.BitmapData(width, height, false, 0x000000);
		
		this.buffer = bmp.getVector(bmp.rect);
	}
	
	public inline function clear():Void
	{
		this.memory.fromVector(this.buffer);
	}
	
	public inline function draw_object(object:flaxe.graphics.Object, offset:flash.geom.Point):Void
	{
		this.draw_display(object.asset.display, offset);
	}
	
	public inline function draw_display(display:Display, offset:flash.geom.Point):Void
	{
		if(offset.x >= 0 && offset.x <= (this.width - display.width) 
		&& offset.y >= 0 && offset.y <= (this.height - display.height))
		{
			var y1:Int = 0, y2 = display.height;
		
			while(y1 < y2)
			{
				var x1:Int = 0, x2 = display.width;
				
				while(x1 < x2)
				{
					var i1:Int = y1 * display.width + x1;
					
					var i2:Int = cast ((y1 + offset.y) * this.width + (x1 + offset.x));
					
					this.memory.set(i2, display.memory.get(i1));
					
					++x1;
				}
				
				++y1;
			}
		}
	}
	
	public static inline function from_bitmap_data(bmp:flash.display.BitmapData):Display
	{
		var display = new Display(bmp.width, bmp.height);
		
		display.memory.fromVector(bmp.getVector(bmp.rect));
		
		return display;
	}
}
