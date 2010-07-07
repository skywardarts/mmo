// Copyright (c) 2009 The haxegui developers
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

package haxegui.windowClasses;

//{{{ Imports
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.geom.Point;
import haxegui.Window;
import haxegui.XmlParser;
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.controls.Image;
import haxegui.controls.Label;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.ScriptManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}

//{{{ CloseButton
/**
*
* Close CloseButton Class
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class CloseButton extends AbstractButton {
	//{{{ Constructor
	public function new(?parent:DisplayObjectContainer, ?name:String, ?x:Float, ?y:Float) {
		super (parent, name, x, y);
		//		description = "Close Window";
		description = null;
		setAction("mouseClick", "this.getParentWindow().destroy();");
	}
	//}}}

	///{{{ Functions
	//{{{ onMouseClick
	override public function onMouseClick(e:MouseEvent) : Void	{
		trace("Close clicked on " + parent.parent.toString());
		super.onMouseClick(e);
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(CloseButton);
	}
	//}}}
	//}}}
}
//}}}

//{{{ MinimizeButton
/**
* A TitleBar Button to minimize the window
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class MinimizeButton extends AbstractButton {

	//{{{ Constructor
	public function new(?parent:DisplayObjectContainer, ?name:String, ?x:Float, ?y:Float) {
		super (parent, name, x, y);
		//		description = "Minimize Window";
		description = null;
	}
	//}}}


	//{{{ onMouseClick
	override public function onMouseClick(e:MouseEvent) : Void	{
		trace("Minimized clicked on " + parent.parent.toString());
		//~ parent.dispatchEvent(new Event(Event.CLOSE));
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(MinimizeButton);
	}
	//}}}
}
//}}}

//{{{ MaximizeButton
/**
*
* MaximizeButton Class
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class MaximizeButton extends AbstractButton {

	//{{{ Constructor
	public function new(?parent:DisplayObjectContainer, ?name:String, ?x:Float, ?y:Float) {
		super (parent, name, x, y);
		//		description = "Maximize Window";
		description = null;
	}
	//}}}

	//{{{ Functions
	//{{{ onMouseClick
	override public function onMouseClick(e:MouseEvent) : Void {
		trace("Maximize clicked on " + parent.parent.toString());
		//~ parent.dispatchEvent(new Event(Event.CLOSE));
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(MaximizeButton);
	}
	//}}}
	//}}}
}
//}}}

//{{{ Titlebar
/**
*
* Titlebar class
*
* @todo icon
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.2
*/
class TitleBar extends AbstractButton {

	//{{{ Members
	//{{{ Static
	/** Title offset from center titlebar **/
	static inline var titleOffset : Point = new Point(0,-4);
	public static var iconFile : String = "applications-system.png";

	public var title : Label;

	static var layoutXml = Xml.parse('
	<haxegui:Layout name="TitleBar">
	<haxegui:windowClasses:CloseButton	  x="4"  y="4" color="{parent.color}"/>
	<haxegui:windowClasses:MinimizeButton x="20" y="4" color="{parent.color}"/>
	<haxegui:windowClasses:MaximizeButton x="36" y="4" color="{parent.color}"/>
	<haxegui:controls:Label text="{this.getParentWindow().name}" mouseEnabled="false"/>
	<haxegui:controls:Icon src="16x16/'+iconFile+'" x="{parent.box.width-12}"/>
	</haxegui:Layout>
	').firstElement();

	static var styleXml = Xml.parse('
	<haxegui:Style name="TitleBar">
	<haxegui:windowClasses:TitleBar>
	<events>
	<script type="text/hscript" action="mouseDoubleClick"><![CDATA[	]]></script>
	<script type="text/hscript" action="mouseDown">
	<![CDATA[
	if(event.target!=this) return;

	CursorManager.getInstance().lock = true;

	this.updateColorTween( new feffects.Tween(0, -50, 350, feffects.easing.Linear.easeOut) );

	var win = this.getParentWindow();
	if(win==null) return;

	win.startDrag();
	win.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.onStopDrag, false, 0, true);
	win.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMouseMove, false, 0, true);
	]]>
	</script>

	<script type="text/hscript" action="mouseUp">
	<![CDATA[
	CursorManager.getInstance().lock = false;
	this.updateColorTween( new feffects.Tween(-50, 0, 120, feffects.easing.Linear.easeNone) );

	if(this.hitTestObject( CursorManager.getInstance()._mc ))
	CursorManager.setCursor(this.cursorOver);
	else
	CursorManager.setCursor(Cursor.ARROW);

	var win = this.getParentWindow();
	if(win==null) return;

	win.stopDrag();
	if(win.hasEventListener(flash.events.MouseEvent.MOUSE_MOVE))
	win.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMouseMove);
	if(win.hasEventListener(flash.events.MouseEvent.MOUSE_UP))
	win.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.onStopDrag);
	]]>
	</script>
	</events>
	</haxegui:windowClasses:TitleBar>
	</haxegui:Style>
	').firstElement();
	//}}}
	//}}}


	//{{{ Functions
	//{{{ init
	/**
	* @throws String warning when not attached to a window		// xml.elementsNamed("haxegui:controls:Icon").next().set("src", "16x16/utilities-terminal.png");

	*/
	override public function init(?opts:Dynamic) {
		if(!Std.is(parent, Window)) throw parent+" not a Window";
		box = new flash.geom.Rectangle(0,0, (cast parent).box.width, 32);
		color = (cast parent).color;


		super.init(opts);


		layoutXml.set("name", name);

		XmlParser.apply(TitleBar.styleXml, true);
		XmlParser.apply(TitleBar.layoutXml, this);

		description = null;

		title = this.getElementsByClass(Label).next();

		parent.addEventListener(ResizeEvent.RESIZE, onParentResize, false, 0, true);
	}
	//}}}


	//{{{ onMouseMove
	public function onMouseMove(e:MouseEvent) {
		var win = this.getParentWindow();
		if(win==null) return;
		win.dispatchEvent(new MoveEvent(MoveEvent.MOVE));
	}
	//}}}


	//{{{ onStopDrag
	public function onStopDrag(e:MouseEvent) {
		var win = this.getParentWindow();
		if(win==null) return;

		win.stopDrag();
	}
	//}}}


	//{{{ onParentResize
	public function onParentResize(e:ResizeEvent) {
		box = new Size((cast parent).box.width+10, 32).toRect();
		redraw();

		var icon = this.getElementsByClass(Icon).next();
		if(icon==null) return;
		icon.moveTo((cast parent).box.width-12, 2);

		if(title==null) return;
		title.center();
		title.movePoint(titleOffset);
		title.x = Math.max(60, title.x);

		scrollRect = box;
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(TitleBar);
	}
	//}}}
	//}}}
}
//}}}

