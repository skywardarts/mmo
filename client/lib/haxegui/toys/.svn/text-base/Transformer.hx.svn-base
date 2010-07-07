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

package haxegui.toys;

//{{{ Import
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxegui.Haxegui;
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
import haxegui.toys.Circle;
import haxegui.toys.Rectangle;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


/**
* A Transformation widget, to visually translate and scale a component.<br/>
* pass it a target on creation and use it's 8 square handles on the corners and edges for resizing, and the center circle for moving.
* It listens for focus events from the target, if target has lost focus for anyone else but the transformer, it will automatically self-destruct.
*
* @todo freaks out when target is rotated
* @todo rotation controls
*/
class Transformer extends Component {
	//{{{ Members
	/** Component to transform **/
	public var target  : Component;

	/** Transformer uses [Size] for its operations and not [Rectangle] **/
	public var size : Size;

	/** circular pivot **/
	private var pivot   : Circle;

	/** square handles **/
	private var handles : Array<haxegui.toys.Rectangle>;

	/** the currently dragged object, either a handle or the pivot **/
	private var dragging : Dynamic;

	/** handle size in square pixels **/
	public static var handleSize : Int = 10;

	/** true to resize the [box], false to resize width & height **/
	public static var transformBoxes : Bool = true;
	//}}}


	//{{{ Constructor
	/**
	* @param target [Component] to transform.
	*/
	public function new (target:Component) {
		this.target = target;
		super(flash.Lib.current, "Transformer_"+target.name, target.x, target.y);
	}
	//}}}


	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic=null) {
		color = cast Math.random() * 0xFFFFFF;
		handles = [];


		if(target.box==null || target.box.isEmpty())
		size = Size.fromRect(target.getBounds(this));
		else
		size = Size.fromRect(target.box.clone());


		// make room for handles
		size.add(Size.square(2*handleSize));
		var mid = size.clone().shift(1).toPoint();


		super.init(opts);


		description = null;

		// XOR like display, as not to hide the transformee
		blendMode = flash.display.BlendMode.DIFFERENCE;


		// register event for closing
		if(Std.is(target, Component))
		target.addEventListener(FocusEvent.FOCUS_OUT, onTargetFocusOut, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onClose, false, 0, true);


		// create the 8 square handles
		for(i in 0...8) {
			handles.push(new haxegui.toys.Rectangle(this, "handle"+i));
			handles[i].init({roundness: 0, color: this.color});
			handles[i].box = Size.square(Transformer.handleSize).toRect();
			handles[i].description = null;
			// handles[i].setAction("redraw", " this.graphics.clear(); this.graphics.beginFill(this.color); this.graphics.drawRect(0,0, toys.Transformer.handleSize, toys.Transformer.handleSize); this.graphics.endFill(); " );
			handles[i].addEventListener(MouseEvent.MOUSE_DOWN, onHandleMouseDown, false, 0, true);

			var midHandle = Std.int(handleSize)>>1;

			switch(i) {
				case 0:
				case 1:
				handles[i].x = mid.x - midHandle;
				case 2:
				handles[i].x = size.width - handleSize;
				case 3:
				handles[i].x = size.width - handleSize;
				handles[i].y = mid.y - midHandle;
				case 4:
				handles[i].x = size.width - handleSize;
				handles[i].y = size.height - handleSize;
				case 5:
				handles[i].x = mid.x - midHandle;
				handles[i].y = size.height - handleSize;
				case 6:
				handles[i].y = size.height - handleSize;
				case 7:
				handles[i].y = mid.y - midHandle;
			}

		}


		// center pivot
		pivot = new Circle(this, "pivot") ;
		pivot.init({color: Color.WHITE, radius: Math.max(4, handleSize - 4) });
		pivot.description = null;
		pivot.addEventListener(MouseEvent.MOUSE_DOWN, onHandleMouseDown, false, 0, true);
		pivot.x = mid.x;
		pivot.y = mid.y;


		// draw the frame
		this.setAction("redraw",
		"
		this.graphics.clear();
		this.graphics.lineStyle (1, Color.darken(this.color, 30), .4, false, flash.display.LineScaleMode.NONE);
		this.graphics.beginFill(this.color, .15);
		this.graphics.drawRect(0,0,this.size.width,this.size.height);
		this.graphics.drawRect(toys.Transformer.handleSize, toys.Transformer.handleSize, this.size.width-toys.Transformer.handleSize*2, this.size.height-toys.Transformer.handleSize*2);
		this.graphics.endFill();
		"
		);
	}
	//}}}


	//{{{ onHandleMouseDown
	public function onHandleMouseDown(e:MouseEvent) {
		dragging = e.target;
		CursorManager.getInstance().lock = true;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, onHandleMouseUp, false, 0, true);
	}
	//}}}


	//{{{ onHandleMouseUp
	public function onHandleMouseUp(e:MouseEvent) {
		dragging = null;
		CursorManager.getInstance().lock = false;
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onHandleMouseUp);
	}
	//}}}


	//{{{ onTargetFocusOut
	public function onTargetFocusOut(e:FocusEvent) {
		if(!Std.is(e.relatedObject, Component)) return;
		if(e.relatedObject==this || this.contains(e.relatedObject)) return;
		//~ trace(e);
		this.destroy();
	}
	//}}}


	//{{{ onMouseMove
	public function onMouseMove(e:MouseEvent) {

		// Mouse Position
		var mp = new Point(this.mouseX, this.mouseY);
		var smp = mp.subtract(new Point(mp.x%Haxegui.gridSpacing, mp.y%Haxegui.gridSpacing));

		// absolute coordinates
		var p = target.parent.globalToLocal(new Point(this.x, this.y));
		// var p = target.globalToLocal(new Point(this.x, this.y));

		// the box's center
		var mid = size.clone().shift(1).toPoint();

		// handle's half-size for centering handles
		var midHandle = Std.int(handleSize)>>1;


		//
		switch(dragging) {
			// TopLeft
			case handles[0]:
			dragging.x = mp.x;
			dragging.y = mp.y;

			if(Haxegui.gridSnapping) {
				dragging.x -= smp.x;
				dragging.y -= smp.y;
			}

			size.subtract(new Size(dragging.x, dragging.y));

			x += dragging.x;
			y += dragging.y;

			dragging.x = dragging.y = 0;


			handles[2].x = handles[3].x = handles[4].x = size.width - handleSize;
			handles[1].x = handles[5].x = mid.x - midHandle;
			handles[3].y = handles[7].y = mid.y - midHandle;
			handles[4].y = handles[5].y = handles[6].y = size.height - handleSize;
			// Top
			case handles[1]:
			dragging.y = mp.y;

			if(Haxegui.gridSnapping)
			dragging.y -= smp.y;

			y += dragging.y;
			size.height -= Std.int(dragging.y);
			dragging.y = 0;

			handles[3].y = handles[7].y = mid.y - midHandle;
			handles[4].y = handles[5].y = handles[6].y = size.height - handleSize;

			// TopRight
			case handles[2]:
			dragging.x = mp.x + handleSize;
			dragging.y = mp.y;

			if(Haxegui.gridSnapping) {
				dragging.x -= mp.x % Haxegui.gridSpacing;
				dragging.y -= mp.y % Haxegui.gridSpacing;
			}

			y += dragging.y;

			size.width = dragging.x + handleSize;
			size.height -= Std.int(dragging.y);

			dragging.y = 0;

			handles[3].x = handles[4].x = dragging.x;
			handles[1].x = handles[5].x = mid.x - midHandle;
			handles[3].y = handles[7].y = mid.y - midHandle;
			handles[4].y = handles[5].y = handles[6].y = size.height - handleSize;

			// Right
			case handles[3]:
			dragging.x = mp.x - mp.x % Haxegui.gridSpacing + handleSize;
			size.width = dragging.x + handleSize;
			handles[1].x = handles[5].x = mid.x - midHandle;
			handles[2].x = handles[4].x = dragging.x;

			// BottomRight
			case handles[4]:
			dragging.x = mp.x - handleSize + Haxegui.gridSpacing;
			dragging.y = mp.y - handleSize + Haxegui.gridSpacing;

			if(Haxegui.gridSnapping) {
				dragging.x -= mp.x % Haxegui.gridSpacing;
				dragging.y -= mp.y % Haxegui.gridSpacing;
			}

			size = new Size(dragging.x, dragging.y);

			dragging.x = size.width - handleSize;
			dragging.y = size.height - handleSize;


			handles[1].x = handles[5].x = mid.x - midHandle;
			handles[2].x = handles[3].x = dragging.x;

			handles[3].y = handles[7].y = mid.y - midHandle;
			handles[5].y = handles[6].y = dragging.y;

			// Bottom
			case handles[5]:

			if(Haxegui.gridSnapping)
			dragging.y = mp.y - mp.y % Haxegui.gridSpacing - handleSize + Haxegui.gridSpacing;
			else
			dragging.y = mp.y - handleSize + Haxegui.gridSpacing;

			size.height = dragging.y;
			dragging.y = size.height - handleSize;
			handles[3].y = handles[7].y = mid.y - midHandle;
			handles[4].y = handles[6].y = dragging.y;

			// BottomLeft
			case handles[6]:
			dragging.x = mp.x;
			dragging.y = mp.y - handleSize + Haxegui.gridSpacing;

			if(Haxegui.gridSnapping) {
				dragging.x -= smp.x;
				dragging.y -= smp.y;
			}

			x += dragging.x;
			size.width  -= Std.int(dragging.x);
			size.height  = Std.int(dragging.y);


			dragging.x   = 0;
			dragging.y   = size.height - handleSize;

			handles[1].x = handles[5].x = mid.x - midHandle;
			handles[2].x = handles[3].x = handles[4].x = size.width - midHandle;
			handles[3].y = handles[7].y = mid.y - midHandle;
			handles[4].y = handles[5].y = dragging.y;

			// Left
			case handles[7]:
			dragging.x = mp.x;

			if(Haxegui.gridSnapping)
			dragging.x -= smp.x;

			x += dragging.x;
			size.width -= Std.int(dragging.x);

			dragging.x = 0;
			dragging.y = mid.y - midHandle;

			handles[1].x = handles[5].x = mid.x - midHandle;
			handles[2].x = handles[3].x = handles[4].x = size.width - handleSize;

			// Center
			case pivot:
			// move the transformer
			x += mp.x - mid.x;
			y += mp.y - mid.y;


			pivot.x = mid.x;
			pivot.y = mid.y;
			// snapping without snap() to avoid dispatching MoveEvent.
			if(Haxegui.gridSnapping) {
				x -= (x-handleSize) % Haxegui.gridSpacing;
				y -= (y-handleSize-midHandle) % Haxegui.gridSpacing;
			}
		}

		if(size.width <= target.minSize.width) size.width = target.minSize.width + 2*handleSize;
		if(size.height <= target.minSize.height) size.height = target.minSize.height + 2*handleSize;

		// resize
		if(dragging!=pivot) {

			if(transformBoxes)
			// resize the target, it checks for minSize and also dispatches a ResizeEvent
			target.resize(size.clone().subtract(Size.square(2*handleSize)));
			else {
				if(size.width >= target.minSize.width)
				target.width = size.width;

				if(size.height >= target.minSize.height)
				target.height = size.height;
				// target.dispatchEvent
			}

			// redraw target
			//~ target.dirty = true;
			target.redraw();

			// redraw the transformer
			redraw();

			// re-center the pivot
			pivot.x = mid.x;
			pivot.y = mid.y;
		}

		// move target
		p.offset(handleSize, handleSize);
		target.moveToPoint(p);
		//~ target.snap();


		e.updateAfterEvent();
	}
	//}}}


	//{{{ onMouseDown
	override public function onMouseDown(e:MouseEvent) {}
	//}}}


	//{{{ onMouseUp
	override public function onMouseUp(e:MouseEvent) {}
	//}}}


	//{{{ onClose
	function onClose(e:Dynamic) {
		if(Std.is(e, MouseEvent))
		if(e.target==this || this.contains(e.target)) return;
		this.destroy();
	}
	//}}}


	//{{{ destroy
	override public function destroy() {
		for(h in handles)
		h.removeEventListener(MouseEvent.MOUSE_DOWN, onHandleMouseDown);
		pivot.removeEventListener(MouseEvent.MOUSE_DOWN, onHandleMouseDown);

		super.destroy();
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Transformer);
	}
	//}}}
}
