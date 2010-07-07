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

package haxegui.containers;


//{{{ Imports
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.containers.IContainer;
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.MouseManager;
import haxegui.managers.ScriptManager;
import haxegui.managers.StyleManager;
import haxegui.toys.Arrow;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


using haxegui.controls.Component;


//{{{ DividerHandleButton
/**
* Button for the divider handle collapse\expand fully.<br/>
*/
class DividerHandleButton extends AbstractButton {

	public var arrow : Arrow;

	//{{{ init
	override public function init(opts : Dynamic=null) {
		if(untyped parent.parent.horizontal)
		box = new Rectangle(0,0,10,100);
		else
		box = new Rectangle(0,0,100,10);
		color = DefaultStyle.BACKGROUND;


		super.init(opts);


		// arrow
		arrow = new Arrow(this);
		arrow.init({width: 6, height: 8, color: this.color, mouseEnabled: false});

		if(untyped parent.parent.horizontal)
		arrow.moveTo(5, .5*(this.box.height-8));
		else {
			arrow.rotation = 90;
			arrow.moveTo(.5*(this.box.width-8), 5);
		}
		//arrow.filters = [new flash.filters.DropShadowFilter (1, 45, DefaultStyle.DROPSHADOW, .7, 2, 2, .7, flash.filters.BitmapFilterQuality.LOW, true, false, false)];

	}
	//}}}

	public override function onMouseClick(e:MouseEvent) {
		if((cast parent.parent).horizontal)
		parent.asComponent().moveTo(parent.parent.asComponent().box.width-10, 0);


		arrow.rotation += 180;

		(cast parent.parent).adjust();

		super.onMouseClick(e);
	}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(DividerHandle);
	}
	//}}}
}
//}}}


//{{{ DividerHandle
/**
* Handle to resize cells in the divider.<br/>
*/
class DividerHandle extends AbstractButton {

	public var button : DividerHandleButton;

	public var oldPos : Float;

	//{{{ init
	override public function init(opts : Dynamic=null) {
		box = new Size(10, (cast parent).box.height).toRect();
		if((cast parent).horizontal)
		box = new Size((cast parent).box.width,10).toRect();

		color = DefaultStyle.BACKGROUND;
		cursorOver = Cursor.NS;
		cursorPress = Cursor.DRAG;


		super.init(opts);

		var h = .5*(box.height-100);
		var w = .5*(box.width-100);

		button = new DividerHandleButton(this, cast(parent, Divider).horizontal ? 0 : w, cast(parent, Divider).horizontal ? h : 0);
		button.init();


		this.filters = [new flash.filters.DropShadowFilter (2, 45, DefaultStyle.DROPSHADOW, .5, 4, 4, 0.5, flash.filters.BitmapFilterQuality.HIGH, false, false, false)];

		parent.addEventListener(ResizeEvent.RESIZE, onParentResize, false, 0, true);
	}
	//}}}


	//{{{ onMouseMove
	public function onMouseMove(e:MouseEvent) {}
	//}}}


	//{{{ onParentResize
	public function onParentResize(e:ResizeEvent) {

		if((cast parent).horizontal) {
			box = new Size(10, (cast parent).box.height).toRect();
			button.y = Std.int(box.height-100)>>1;
		}
		else {
			box = new Size((cast parent).box.width,10).toRect();
			button.x = Std.int(box.width-100)>>1;
		}

		dirty = true;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(DividerHandle);
	}
	//}}}

}
//}}}


//{{{ Divider
/**
* Divider is a split pane containers.<br/>
*
* @version 0.2
* @author Russell Weir <damonsbane@gmail.com>
* @author Omer Goshen <gershon@goosemoose.com>
*/
class Divider extends Container {

	public var handle : DividerHandle;

	public var horizontal : Bool;

	//{{{ init
	override public function init(opts : Dynamic=null) {
		box = parent.asComponent().box.clone();
		horizontal = Opts.optBool(opts, "horizontal", true);


		super.init(opts);

		handle = new DividerHandle(this);
		handle.init();
		if(horizontal)
		handle.moveTo(.5*box.width, 0);
		else
		handle.moveTo(0, .5*box.height);

		this.graphics.clear();

		parent.addEventListener(ResizeEvent.RESIZE, onParentResize, false, 0, true);
		parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ addChild
	public override function addChild(o:DisplayObject) {
		var r = super.addChild(o);
		if(handle!=null) handle.toFront();
		return r;
	}
	//}}}

	public override function onChildMoved(e:MoveEvent) {
	}

	//{{{ onMouseDown
	public override function onMouseDown(e:MouseEvent) {
		if(e.target==handle) {
			if(this.horizontal)
			handle.startDrag(false, new Rectangle(-this.stage.stageWidth,0,2*this.stage.stageWidth,0));
			else
			handle.startDrag(false, new Rectangle(0,-this.stage.stageHeight,0,2*this.stage.stageHeight));
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			// adjust();
			handle.dispatchEvent(new MoveEvent(MoveEvent.MOVE));
			dispatchEvent(new Event(Event.CHANGE));
		}
		super.onMouseDown(e);
	}
	//}}}


	//{{{ onMouseUp
	public override function onMouseUp(e:MouseEvent) {
		handle.stopDrag();
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		super.onMouseUp(e);
	}
	//}}}


	//{{{ onMouseMove
	public function onMouseMove(e:MouseEvent) {
		adjust();

		handle.dispatchEvent(new MoveEvent(MoveEvent.MOVE));
		dispatchEvent(new Event(Event.CHANGE));
	}
	//}}}


	//{{{ adjust
	public function adjust() {
		if(handle==null) return;
		handle.toFront();

		if(horizontal) {
			if(firstChild()!=null) {
				firstChild().asComponent().box.width = handle.x ;
				firstChild().asComponent().box.height = box.height;

				if(Std.is(firstChild(), ScrollPane)) {
					var sp = cast (firstChild(), ScrollPane);
					sp.box.width -= 20;
					sp.box.height -= 20;
				}

				firstChild().asComponent().dirty = true;
				firstChild().dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
			}

			if(this.numChildren==3) {
				firstChild().asComponent().nextSibling().x = handle.x + 10;
				firstChild().asComponent().nextSibling().asComponent().box.width = this.box.width - handle.x - 11;
				firstChild().asComponent().nextSibling().asComponent().box.height = this.box.height;

				if(Std.is(firstChild().asComponent().nextSibling(), ScrollPane)) {
					var sp = cast (firstChild().asComponent().nextSibling(), ScrollPane);
					if(sp.vert.visible) sp.asComponent().box.width -= 20;
					if(sp.horz.visible) sp.asComponent().box.height -= 20;
				}

				firstChild().asComponent().nextSibling().asComponent().dirty = true;
				firstChild().asComponent().nextSibling().dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
			}
		}
		else {
			if(firstChild()!=null) {
				firstChild().asComponent().box.width = box.width;
				firstChild().asComponent().box.height = handle.y ;

				if(Std.is(firstChild(), ScrollPane)) {
					firstChild().asComponent().box.width -= 20;
					firstChild().asComponent().box.height -= 20;
				}

				firstChild().asComponent().dirty = true;
				firstChild().dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
			}
			if(this.numChildren==3) {
				firstChild().asComponent().nextSibling().y = handle.y + 10;
				firstChild().asComponent().nextSibling().asComponent().box.width = box.width;
				firstChild().asComponent().nextSibling().asComponent().box.height = box.height - handle.y - 1;


				if(Std.is(firstChild().asComponent().nextSibling(), ScrollPane)) {
					firstChild().asComponent().nextSibling().asComponent().box.width -= 20;
					firstChild().asComponent().nextSibling().asComponent().box.height -= 20;
				}

				if(Std.is(firstChild().asComponent().nextSibling(), Divider)) {
					firstChild().asComponent().nextSibling().asComponent().box.height -= 20;
				}

				firstChild().asComponent().nextSibling().asComponent().dirty = true;
				firstChild().asComponent().nextSibling().dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
			}
		}
	}
	//}}}


	//{{{ onResize
	override function onResize(e:ResizeEvent) {
		if(handle==null) return;
		if(horizontal)
		handle.x = Math.min( handle.x, box.width-10 );
		else
		handle.y = Math.min( handle.y, box.height-10 );

		adjust();
	}
	//}}}


	//{{{ onParentResize
	private override function onParentResize(e:ResizeEvent) {
		if(Std.is(parent, Divider)) {
			if((cast parent).horizontal)
			box.height = parent.asComponent().box.height;
			else
			box.width = parent.asComponent().box.width;
		}
		else
//		super.onParentResize(e);
		box = parent.asComponent().box.clone();

		if(Std.is(parent, haxegui.Window)) {
			box.width -= 10;
			box.height -= 20;
		}

		adjust();

		//this.graphics.clear();
		dirty = true;

		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Divider);
	}
	//}}}
}
//}}}

class VDivider extends Divider {}
class HDivider extends Divider {
	public override function init(?opts:Dynamic) {
		horizontal = false;
		if(opts==null) opts={};
		Reflect.setField(opts, "horizontal", horizontal);
		super.init(opts);
	}
}
