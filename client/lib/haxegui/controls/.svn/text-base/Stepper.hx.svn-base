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
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.geom.Rectangle;
import haxegui.Haxegui;
import haxegui.XmlParser;
import haxegui.controls.Component;
import haxegui.controls.Component;
import haxegui.controls.IAdjustable;
import haxegui.controls.Input;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
import haxegui.toys.Arrow;
import haxegui.toys.Socket;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


using haxegui.utils.Color;
using haxegui.controls.Component;


//{{{ StepperUpButton
/**
* A Button with an arrow pointing up.<br/>
*/
class StepperUpButton extends Button, implements IComposite {

	static var xml = Xml.parse('
	<haxegui:Layout name="StepperUpButton">
		<haxegui:toys:Arrow
		x="8" y="5"
		color="{Color.darken(parent.color, 20)}"
		rotation="-90"
		width="{parent.box.height>>1}"
		height="{parent.box.width>>1}"
		autoRepeat="{parent.autoRepeat}"
		repeatsPerSecond="{parent.repeatsPerSecond}"
		repeatWaitTime="{parent.repeatWaitTime}"
		/>
	</haxegui:Layout>
	').firstElement();

	//{{{ init
	/**
	* @throws String when not parented to a [Stepper]
	*/
	override public function init(opts:Dynamic=null) {
		if(!Std.is(parent, Stepper)) throw parent+" not a Stepper";
		mouseChildren = false;
		minSize = new Size(16,10);

		super.init(opts);

		box = new Size(16,10).toRect();
		moveTo((cast parent).box.width-10,0);

		xml.set("name", name);

		XmlParser.apply(StepperUpButton.xml, this);
	}
	//}}}

	public override function onAdded(e:Event) {}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(StepperUpButton);

	}
	//}}}
}
//}}}


//{{{ StepperDownButton
/**
* A Button with an arrow pointing down.<br/>
*/
class StepperDownButton extends Button, implements IComposite {

	static var xml = Xml.parse('
	<haxegui:Layout name="StepperDownButton">
		<haxegui:toys:Arrow
		x="8" y="5"
		color="{Color.darken(parent.color, 20)}"
		rotation="90"
		width="{parent.box.height>>1}"
		height="{parent.box.width>>1}"
		autoRepeat="{parent.autoRepeat}"
		repeatsPerSecond="{parent.repeatsPerSecond}"
		repeatWaitTime="{parent.repeatWaitTime}"
		/>
	</haxegui:Layout>
	').firstElement();


	//{{{ init
	/**
	* @throws String when not parented to a [Stepper]
	*/
	override public function init(opts:Dynamic=null) {
		if(!Std.is(parent, Stepper)) throw parent+" not a Stepper";
		mouseChildren = false;
		minSize = new Size(16,10);


		super.init(opts);

		box = new Size(16,10).toRect();

		xml.set("name", name);

		XmlParser.apply(StepperDownButton.xml, this);

		// firstChild().asComponent().center();
	}
	//}}}

	public override function onAdded(e:Event) {}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(StepperDownButton);
	}
	//}}}
}
//}}}


//{{{ Stepper
/**
* Stepper for numeric values, has an input and up\down buttons.<br/>
*
*
* @author Omer Goshen Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class Stepper extends Component, implements IAdjustable {

	//{{{ Members
	public var adjustment 	: Adjustment;
	public var up 			: StepperUpButton;
	public var down 		: StepperDownButton;
	public var input 		: Input;
	public var slot 	  	: Socket;


	static var xml = Xml.parse('
	<haxegui:Layout name="Stepper">
		<haxegui:controls:Input width="{parent.box.width-10}" text="{parent.adjustment.getValue()}"/>
		<haxegui:controls:StepperUpButton color="{parent.color}" autoRepeat="{parent.initOpts.autoRepeat}" repeatsPerSecond="{parent.initOpts.repeatsPerSecond}" repeatWaitTime="{parent.initOpts.repeatWaitTime}"/>
		<haxegui:controls:StepperDownButton color="{parent.color}" autoRepeat="{parent.initOpts.autoRepeat}" repeatsPerSecond="{parent.initOpts.repeatsPerSecond}" repeatWaitTime="{parent.initOpts.repeatWaitTime}"/>
	</haxegui:Layout>
	').firstElement();
	//}}}


	//{{{ Functions
	//{{{ init
	override public function init(opts:Dynamic=null) {
		// adjustment = new Adjustment({ value: .0, min: Math.NEGATIVE_INFINITY, max: Math.POSITIVE_INFINITY, step: 1, page: 10 });
		adjustment = new Adjustment({ value: 0, min: -(2<<15), max: 2<<15, step: 1, page: 10 });
		// adjustment = new Adjustment(Adjustment.newAdjustmentObject(Int));
		box = new Size(40, 20).toRect();
		minSize = new Size(20,20);
		color = DefaultStyle.BACKGROUND;

		// input = new Input(this);
		// up = new StepperUpButton(this);
		// down = new StepperDownButton(this);

		var aOpts = Opts.clone(opts);

		adjustment.object.value = Opts.optFloat(opts, "value", adjustment.object.value);
		adjustment.object.min   = Opts.optFloat(opts, "min",   adjustment.object.min);
		adjustment.object.max   = Opts.optFloat(opts, "max",   adjustment.object.max);
		adjustment.object.step  = Opts.optFloat(opts, "step",  adjustment.object.step);
		adjustment.object.page  = Opts.optFloat(opts, "page",  adjustment.object.page);

		Opts.removeFields(aOpts, ["value","step", "page", "min","max"]);


		super.init(aOpts);


		xml.set("name", name);

		XmlParser.apply(Stepper.xml, this);


		// since we removed fields, reset the initOpts
		this.initOpts = Opts.clone(opts);

		var bOpts = Opts.clone(aOpts);
		Opts.optBool(bOpts, "autoRepeat", true);
		Opts.optFloat(bOpts, "repeatsPerSecond", 50);
		Opts.optFloat(bOpts, "repeatWaitTime", .75);

		input = getElementsByClass(Input).next();
		input.tf.restrict = "0-9.";

		// init children
		// input.init({text: adjustment.object.value, width: box.width, height: box.height, disabled: this.disabled });
		input.box = box.clone();
		// input.setText(adjustment.object.value);

		// up.init(bOpts);
		// down.init(bOpts);

		// this prevents too many glow filters
		input.setAction("focusIn", "");
		input.setAction("focusOut", "");

		// input
		input.tf.addEventListener (KeyboardEvent.KEY_DOWN, onInput, false, 0, true);
		input.addEventListener (MoveEvent.MOVE, onInputMoved, false, 0, true);
		input.addEventListener (ResizeEvent.RESIZE, onInputResized, false, 0, true);

		// slot
		slot = new haxegui.toys.Socket(this);
		slot.init({radius: 6, visible: false});
		slot.moveTo(-14,Std.int(this.box.height)>>1);

		adjustment.addEventListener (Event.CHANGE, onChanged, false, 0, true);
	}
	//}}}


	//{{{ onInput
	/**
	* @todo handle null and bool too
	*/
	private function onInput(e:KeyboardEvent) {
		switch(e.keyCode) {
			case flash.ui.Keyboard.ENTER:
			adjustment.setValue(Std.parseFloat(e.target.text));
		}
	}
	//}}}


	//{{{ onInputMoved
	private function onInputMoved(e:MoveEvent) {
		move(input.x, input.y);
		input.removeEventListener (MoveEvent.MOVE, onInputMoved);
		input.moveTo(0,0);
		input.addEventListener (MoveEvent.MOVE, onInputMoved, false, 0, true);

	}
	//}}}


	//{{{ onInputResized
	private function onInputResized(e:ResizeEvent) {
		if(input==null) return;
		box = input.box.clone();

		if(up!=null) {
			up.moveTo(box.width-up.box.width, 0);
			up.dirty = true;
		}

		if(down!=null) {
			down.moveTo(box.width-down.box.width, .5*up.box.height);
			down.dirty = true;
		}
	}
	//}}}

	public override function destroy() {
		input.removeEventListener (MoveEvent.MOVE, onInputMoved);
		super.destroy();
	}

	//{{{ onChanged
	private function onChanged(e:Event)	{
		input.setText(adjustment.valueAsString());
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Stepper);
	}
	//}}}
	//}}}
	//}}}
}
//}}}
