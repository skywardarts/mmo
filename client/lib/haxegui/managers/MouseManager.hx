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

package haxegui.managers;


//{{{ Import
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import haxe.Timer;
import haxegui.controls.Component;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.utils.Color;
//}}}


class DwellIndicator extends Component {

	public override function init(?opts:Dynamic) {
		color = haxegui.utils.Color.random();


		super.init();

		// setAction("redraw",
		// "
		// this.graphics.beginFill(this.color);
		// this.graphics.drawCircle(0,0,32);
		// this.graphics.drawCircle(0,0,28);
		// this.graphics.endFill();
		// ");

		// setAction("interval",
		// "
		// var mazk = new flash.display.Shape();
		// mazk.graphics.beginFill(Color.MAGENTA);
		// mazk.graphics.moveTo(0,0);
		// mazk.graphics.lineTo(0,32);
		// mazk.graphics.lineTo(32,0);
		// mazk.graphics.lineTo(0,0);
		// mazk.graphics.endFill();
		// this.mask = mazk;
		// ");
		filters = [new flash.filters.GlowFilter (this.color, 1, 10, 10, 1, flash.filters.BitmapFilterQuality.HIGH, false, false)];

		var f = new feffects.Tween(0,1,750,feffects.easing.Bounce.easeOut);
		var self = this;
		f.setTweenHandlers(function(v){ self.scaleX=self.scaleY=v;});
		f.start();

		setAction("interval",
		"
		var x = -24*Math.sin(2.1*Math.PI*Timer.stamp());
		var y = 24*Math.cos(2.1*Math.PI*Timer.stamp());
		this.graphics.lineStyle(1, Color.tint(this.color, .5));
		this.graphics.beginFill(this.color, .5);
		this.graphics.drawCircle(x, y, 3);
		this.graphics.endFill();
		"
		);
		startInterval(16);
	}

}



/**
*
* Mouse Manager Class <br/>
*
* <p>Injects mouse position to fake cursor, leaving the real one free to drag.</p>
*
* @todo dwell click, delayed click, triple clicks...
*/
class MouseManager extends EventDispatcher {

	//{{{ Members
	///{{{ Public
	public var listeners		: Array<haxegui.logging.ILogger>;

	public var lastDown			: Float;
	public var dwellTimer		: Timer;
	public var dwellIndicator	: DwellIndicator;

	public var lastPosition 	: Point;
	public var delta 			: Point;

	//{{{ Static
	public static var lastSeenOnStage : Float;

	public static var moving    : Bool;
	public static var automated : Bool;

	public static var stage = flash.Lib.current.stage;
	//}}}
	//}}}

	//{{{ Private
	private static var _instance : MouseManager = null;
	//}}}

	//~ public var lock : Bool;
	//}}}


	//{{{ Functions
	//{{{ getInstance
	public static function getInstance ():MouseManager {
		if (MouseManager._instance == null)	{
			MouseManager._instance = new MouseManager ();
		}
		return MouseManager._instance;
	}
	//}}}


	//{{{ Constructor
	private function new () {
		super ();
	}
	//}}}


	//{{{ toString
	public override function toString () : String {
		return "MouseManager";
	}
	//}}}


	//{{{ init
	public function init() {
		lastPosition = new Point();
		delta = new Point();


		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);

		// stage.addEventListener(MouseEvent.CLICK, onMouseMove, false, 0, true);


		stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, 0, true);
	}
	//}}}

	//{{{ onMouseDown
	public function onMouseDown(e:MouseEvent) : Void {
		lastDown = Timer.stamp();

		CursorManager.getInstance().inject(e);

		// Timer.delay( doDwell, 50);


		// trace("Down");
	}
	//}}}

	public function onMouseUp(e:MouseEvent) : Void {
		// if(dwellTimer!=null) dwellTimer.stop();
		// if(dwellIndicator!=null) dwellIndicator.destroy();

		CursorManager.getInstance().inject(e);

		// trace("Up");
	}

	public function doDwell(){
		var o = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY)).pop();
		if(Std.is(o, haxegui.controls.IRepeater)) return;
		dwellIndicator = new DwellIndicator(stage.mouseX, stage.mouseY);
		dwellIndicator.init();
		Timer.delay( dwellIndicator.destroy, 1000 );
		dwellTimer = new Timer(1000);
		dwellTimer.run = showMenu;
	}

	public function showMenu(){
		if(dwellTimer!=null) dwellTimer.stop();

		var popup = new haxegui.controls.PopupMenu(flash.Lib.current);
		popup.dataSource = new haxegui.DataSource();
		popup.dataSource.data = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY)).reverse();
		popup.init();

		popup.toFront();
		popup.moveTo(stage.mouseX, stage.mouseY);

		// trace("Dwell");
	}

	//{{{ onMouseMove
	public function onMouseMove(e:MouseEvent) : Void {
		var position = new Point(e.stageX, e.stageY);

		// Calculate new mouse delta
		delta = position.subtract(lastPosition);
		moving = !delta.equals(new Point());
		lastPosition = position;
		if(!moving || position.equals(new Point())) return;

		if(dwellTimer!=null) dwellTimer.stop();
		if(dwellIndicator!=null) dwellIndicator.destroy();

		// Inject to fake cursor
		CursorManager.getInstance().inject(e);

		if(dwellIndicator!=null) dwellIndicator.moveTo(e.stageX, e.stageY);
		//~ e.updateAfterEvent();
	}
	//}}} onMouseMove


	//{{{ onMouseLeave
	public inline function onMouseLeave(e:Event) : Void	{
		//~ trace(e);
		lastSeenOnStage = haxe.Timer.stamp();
		CursorManager.getInstance().hideCursor();
		//~ CursorManager.getInstance()._mc.stopDrag();
	}
	//}}}


	//{{{ moveToPoint
	public function moveToPoint(p:Point) : MouseEvent {
		var e = new MouseEvent(MouseEvent.MOUSE_MOVE, false, true, p.x, p.y);
		stage.dispatchEvent(e);
		return e;
	}
	//}}}
	//}}}
}
