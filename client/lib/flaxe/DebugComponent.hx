import flash.display.*;
import flash.text.*;

class DebugComponent
{
	static var box:TextField;
	public static var enabled:Bool;
	
	public static function initialize(mc:MovieClip)
	{
		enabled = true;
		
		box = new TextField();
		box.x = 0; box.y = 0;
		box.width = 800; box.height = 200;
		box.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF, false, false, false);
		box.selectable = false;
		box.multiline = true;
		box.wordWrap = true;
		box.background = false;
		box.mouseWheelEnabled = true;
		//box.embedFonts = true;
		//box.backgroundColor = 0x000000;
		
		mc.addChild(box);
	}
	
	public static function log(message:String)
	{
		trace(message);
		
		if(enabled)
		{
			box.appendText(message + "\n");
			
			if(box.numLines > 13)
				box.scrollV = box.numLines - 13;
		}
	}
}
