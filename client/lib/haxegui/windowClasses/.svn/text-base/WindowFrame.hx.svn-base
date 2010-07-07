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


//{{{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.DragManager;
import haxegui.managers.FocusManager;
import haxegui.managers.MouseManager;
import haxegui.managers.ScriptManager;
import haxegui.managers.StyleManager;
import haxegui.managers.WindowManager;
import haxegui.utils.Color;
import haxegui.utils.Size;
import haxegui.utils.Opts;
import haxegui.windowClasses.TitleBar;
import haxegui.windowClasses.WindowFrame;
//}}}


//~ enum ResizeDirection {
//~ NESW;
//~ NS;
//~ NWSE;
//~ WE;
//~ }


/**
*
* WidowFrame optionaly resizing window frame.
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class WindowFrame extends Component {
	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic) {
		box = (cast parent).box.clone();
		color = (cast parent).color;


		super.init(opts);


		description = null;

		// Exclude modal windows from resizing
		if(!(cast parent).isModal()) {
			this.setAction("mouseDown",
			"
			CursorManager.getInstance().lock = true;

			this.updateColorTween( new feffects.Tween(0, 50, 150, feffects.easing.Linear.easeOut) );

			// Remove corner detection
			this.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMouseMove);

			// Event for stopping the interval
			this.stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.onStageMouseUp, false, 0, true);

			this.startInterval(12);


			this.filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5, 12, 12, 0.75, flash.filters.BitmapFilterQuality.LOW, false, false, false)];
			"
			);


			//{{{ mouseUp
			this.setAction("mouseUp", "" );
			//}}}


			//{{{ interval
			this.setAction("interval",
			"
			var e = new haxegui.events.ResizeEvent(events.ResizeEvent.RESIZE);
			e.oldWidth = this.parent.box.width;
			e.oldHeight = this.parent.box.height;

		// the corner delta
			var d = -5;
			//
			var w = this.parent;
			var p = new flash.geom.Point(this.stage.mouseX, this.stage.mouseY);
			var q = this.localToGlobal(new flash.geom.Point());
			var r = w.localToGlobal(new flash.geom.Point());

			// no case construct here...
			if(CursorManager.getInstance().cursor == Cursor.NS)
			w.box.height = p.y - r.y + d ;
			else
			if(CursorManager.getInstance().cursor == Cursor.WE) {
				if(p.x > r.x + .5*w.box.width)
				w.box.width 	  = p.x - q.x + d ;
				else {
					w.box.width  -= p.x - q.x + d;
					w.x += p.x - r.x + d ;
				}
			}
			else
			if(CursorManager.getInstance().cursor == Cursor.NWSE) {
				w.box.width   = p.x - q.x + d;
				w.box.height  = p.y - q.y + d;
			}
			else
			if(CursorManager.getInstance().cursor == Cursor.NESW) {
				w.box.width  -= p.x - q.x + d ;
				w.box.height  = p.y - q.y + d ;
				if(w.box.width<=w.minSize.width) return;
				w.x += p.x - r.x + d;
			}

			// this.redraw();
			// this.__setDirty(false);
		 if(w.box.width!=e.oldWidth || w.box.height!=e.oldHeight)
			this.dispatchEvent(e);
			"
			);
			// listener for changing cursor icon == resizing direction.
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		}
		//}}}


		filters =[new flash.filters.DropShadowFilter (2, 45, DefaultStyle.DROPSHADOW, 0.5, 8, 8, 0.5, flash.filters.BitmapFilterQuality.HIGH, false, false, false)];
	}
	//}}}


	//{{{ onMouseMove
	public function onMouseMove(e:MouseEvent) {

		if(e.buttonDown ) {
			//~ this.redraw();
			return;
		}

		var box = (cast this.parent).box;
		var d = 10;

		if(e.localX > d && e.localX < box.width -d)
		CursorManager.setCursor(Cursor.NS);

		if(e.localY > d && e.localY < box.height - d)
		CursorManager.setCursor(Cursor.WE);

		if(e.localX < d && e.localY > box.height - d)
		CursorManager.setCursor(Cursor.NESW);

		if(e.localX > box.width - d && e.localY > box.height - d)
		CursorManager.setCursor(Cursor.NWSE);
	}
	//}}}


	//{{{ onStageMouseUp
	public function onStageMouseUp(e:MouseEvent) {
		//~ trace(e);
		this.updateColorTween( new feffects.Tween(50, 0, 150, feffects.easing.Linear.easeOut) );
		if(this.filters==null)
		this.filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.9, 12, 12, 0.85, flash.filters.BitmapFilterQuality.HIGH, false, false, false)];

		CursorManager.getInstance().lock = false;
		this.stopInterval();


		stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);


		this.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ onRollOut
	public override function onRollOut(e:MouseEvent) {
		// if(e.buttonDown ) return;
		// CursorManager.setCursor(Cursor.ARROW);
	}
	//}}}


	//{{ onResize
	public override function onResize(e:ResizeEvent) {
			redraw();
	}
	//}}}


	//{{{ redraw
	override public function redraw(?opts:Dynamic=null):Void {

		parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));

		// ScriptManager.exec(this,"redraw", null);
		super.redraw();
	}
	//}}}

	//{{{ onRollOut
	public override function destroy() {
		this.stopInterval();
		super.destroy();
	}
	//}}}



	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(WindowFrame);
	}
	//}}}
	//}}}
}
