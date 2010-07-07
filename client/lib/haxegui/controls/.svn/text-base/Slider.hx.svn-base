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

package haxegui.controls;

//{{{ Imports
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.Haxegui;
import haxegui.XmlParser;
import haxegui.controls.Component;
import haxegui.controls.Component;
import haxegui.controls.IAdjustable;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.FocusManager;
import haxegui.managers.StyleManager;
import haxegui.managers.TooltipManager;
import haxegui.toys.Socket;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}

//{{{ SliderHandle
/**
*
* Draggable handle to slide values.
*
* @version 0.2
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class SliderHandle extends AbstractButton, implements IAggregate {

	//{{{ init
	override public function init(opts:Dynamic=null) {
		box = new Rectangle(0, 0, 24, 10);
		minSize = Size.fromRect(box);
		super.init(opts);
		y = .5*((cast parent).box.height - box.height);

		// add the drop-shadow filters
		filters = [new flash.filters.DropShadowFilter (disabled ? 1 : 2, 45, DefaultStyle.DROPSHADOW, disabled ? 0.25 : 0.5, 4, 4, disabled ?  0.25 : 0.5, flash.filters.BitmapFilterQuality.LOW, false, false, false )];
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(SliderHandle);
	}
	//}}}
}
//}}}


//{{{ Slider
/**
*
* Horizontal slider with a draggable handle.<br/>
*
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class Slider extends Component, implements IAdjustable {

	//{{{ Members
	/** Slider handle **/
	public var handle : SliderHandle;

	/** Adjustment object **/
	public var adjustment : Adjustment;

	/** Number of ticks **/
	public var ticks : Int;

	/** slot **/
	public var slot : Socket;

	/** true to show value in tooltip while dragging the handle **/
	public var showToolTip: Bool;


	static var xml = Xml.parse('
	<haxegui:Layout name="Slider">
	<haxegui:controls:SliderHandle color="{parent.color}" disabled="{parent.disabled}"/>
	</haxegui:Layout>
	').firstElement();
	//}}}

	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic=null) {
		adjustment = new Adjustment({ value: 0.0, min: Math.NEGATIVE_INFINITY, max: Math.POSITIVE_INFINITY, step: 5., page: 10.});
		box = new Size(140, 20).toRect();
		color = DefaultStyle.BACKGROUND;
		description = null;
		minSize = new Size(30,30);
		showToolTip = true;
		ticks = 25;


		adjustment.object.value = Opts.optFloat(opts,"value", adjustment.object.value);
		adjustment.object.min   = Opts.optFloat(opts,"min",   adjustment.object.min);
		adjustment.object.max   = Opts.optFloat(opts,"max",   adjustment.object.max);
		adjustment.object.step  = Opts.optFloat(opts,"step",  adjustment.object.step);
		adjustment.object.page  = Opts.optFloat(opts,"page",  adjustment.object.page);

		showToolTip = Opts.optBool(opts,"showToolTip", showToolTip);


		super.init(opts);

		xml.set("name", name);

		XmlParser.apply(Slider.xml, this);


		// handle
		handle = cast firstChild();


		// slot
		slot = new haxegui.toys.Socket(this);
		slot.init({ color: Color.tint(slot.color, .5), visible: false });
		slot.moveTo(-14,Std.int(this.box.height)>>1);

		handle.addEventListener (MouseEvent.MOUSE_DOWN, onHandleMouseDown, false, 0, true);

		adjustment.addEventListener (Event.CHANGE, onChanged, false, 0, true);

		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ destroy
	public override function destroy() {
		super.destroy();
	}
	//}}}


	//{{{ onChanged
	public function onChanged(e:Event) {
		handle.x = Math.max(0, Math.min( box.width- handle.box.width, adjustment.getValue()));
	}
	//}}}


	//{{{ onHandleMouseDown
	function onHandleMouseDown (e:MouseEvent) : Void {
		if(this.disabled) return;
		if(e.target!=handle) return;
		CursorManager.setCursor (Cursor.DRAG);
		CursorManager.getInstance().lock = true;
		handle.startDrag(false,new Rectangle(0, e.target.y, box.width - handle.box.width ,0));
		e.target.stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);

		handle.addEventListener (MouseEvent.MOUSE_UP,   onMouseUp, false, 0, true);
		handle.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);

		if(!showToolTip) return;
		tooltip = new Tooltip(handle);
		tooltip.label.setText(adjustment.valueAsString().substr(0,5));
		tooltip.balloon.box.width = tooltip.label.width + 24;
		tooltip.label.move(4,0);
		tooltip.balloon.redraw();
		tooltip.alpha=.8;
		tooltip.fadeTween.stop();
		tooltip.visible = true;
		tooltip.alpha = 1;
		tooltip.redraw();
	}
	//}}}


	//{{{ onMouseUp
	override public function onMouseUp (e:MouseEvent) : Void {
		if(this.disabled) return;

		if(e.target.stage.hasEventListener (MouseEvent.MOUSE_UP))
		e.target.removeEventListener (MouseEvent.MOUSE_UP, onMouseUp);

		if(e.target.stage.hasEventListener (MouseEvent.MOUSE_MOVE))
		e.target.stage.removeEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);

		CursorManager.getInstance().lock = false;
		if(hitTestObject( CursorManager.getInstance()._mc ))
		CursorManager.setCursor (Cursor.ARROW);

		handle.stopDrag();

		if(tooltip!=null)
		tooltip.destroy();

		super.onMouseUp(e);
	}
	//}}}


	//{{{ onMouseMove
	public function onMouseMove (e:MouseEvent) {
		adjustment.object.value = handle.x;
		adjustment.adjust(adjustment.object);
		if(tooltip!=null) {
			tooltip.label.setText(adjustment.valueAsString());
			tooltip.box.width = tooltip.label.width + 8;
			tooltip.redraw();
		}
	}
	//}}}


	//{{{ onResize
	public override function onResize(e:ResizeEvent) {
		super.onResize(e);


		if(slot!=null)
		slot.y = Std.int( this.box.height - slot.box.height )>>1;


		// if((Std.int(box.height)>>1) < handle.minSize.height) return;
		handle.box.height = .5*box.height;
		handle.dirty = true;

		handle.y = .5*(this.box.height - handle.box.height);
		handle.x = Math.max(0, Math.min( box.width - handle.box.width, handle.x ));
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Slider);
	}
	//}}}
	//}}}
}
//}}}
