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
import feffects.Tween;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.geom.Transform;
import haxegui.Haxegui;
import haxegui.controls.Component;
import haxegui.controls.IAdjustable;
import haxegui.events.DragEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
import haxegui.toys.Socket;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
import haxegui.XmlParser;
//}}}


//{{{ ProgressBarIndicator
/**
*
* ProgressBarIndicator class
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class ProgressBarIndicator extends Component, implements IComposite {
	//{{{ init
	override public function init(?opts:Dynamic=null) {
		color = DefaultStyle.PROGRESS_BAR;


		super.init(opts);


		mouseEnabled = false;
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(ProgressBarIndicator);
	}
	//}}}
}
//}}}


//{{{ ProgressBar
/**
*
* ProgressBar class
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class ProgressBar extends Component, implements IAdjustable {

	//{{{ Members
	/** Indicator **/
	public var bar : ProgressBarIndicator;

	/** label showing percentage **/
	public var label : Label;

	/** progress 0-1 **/
	public var progress : Float;

	/** the adjusment for this widget **/
	public var adjustment : Adjustment;

	public var slot : Socket;

	/** true to start animating when created **/
	public var animate : Bool;

	public var mazk : Shape;

	static var xml = Xml.parse('
	<haxegui:Layout name="ProgressBar">
		<haxegui:controls:ProgressBarIndicator>
			<events>
				<script type="text/hscript" action="interval">
				<![CDATA[
					var x = -1;
					if(this.x < -parent.box.width/10) x = parent.box.width/10;
					// this.move(x,0);
					this.x+=x;
				]]>
				</script>
			</events>
		</haxegui:controls:ProgressBarIndicator>
		<haxegui:controls:Label text="{Math.round(100*parent.progress) + \'%\'}"/>
		<haxegui:toys:Socket x="-14" y="10" radius="6" visible="false"/>
	</haxegui:Layout>
	').firstElement();
	//}}}


	//{{{ init
	override public function init(opts:Dynamic=null) {
		adjustment = new Adjustment({ value: 0, min: 0, max: 100, step: 1, page: 1 });
		animate = true;
		box = new Size(140,20).toRect();
		color = DefaultStyle.BACKGROUND;
		progress = .5;


		super.init(opts);


		xml.set("name", name);


		XmlParser.apply(ProgressBar.xml, this);


		progress = Opts.optFloat(opts, "progress", progress);
		animate = Opts.optBool(opts, "animate", animate);

		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5, 8, 8, disabled ? .35 : .75, flash.filters.BitmapFilterQuality.HIGH, true, false, false)];

		// bar = new ProgressBarIndicator(this, "Indicator");
		// bar.init({disabled: this.disabled});

		bar = getElementsByClass(ProgressBarIndicator).next();
		// bar = cast firstChild();
		bar.cacheAsBitmap = true;
		bar.filters = [new flash.filters.DropShadowFilter (4, 0, DefaultStyle.DROPSHADOW, 0.5, 4, 4, disabled ? .35 : .75, flash.filters.BitmapFilterQuality.LOW, false, false, false)];


		//
		mazk = cast addChild(new Shape());
		mazk.graphics.beginFill(0xFF00FF);
		mazk.graphics.drawRect(0,0,progress*box.width,box.height);
		mazk.graphics.endFill();
		bar.mask = mazk;


		//
		// bar.setAction("interval", "var x = -1; if(this.x < -parent.box.width/10) x = parent.box.width/10; this.move(x,0);");
		bar.moveTo(0,1);
		if(animate)
		bar.startInterval(30);


		//
		// label = new Label(this);
		// label.init({ text: Math.round(100*progress) + "%" });
		label = getElementsByClass(Label).next();
		label.center();
		label.move(0,1);

		///
		// slot = new Socket(this);
		// slot.init({radius: 6, visible: Haxegui.slots});
		// slot.moveTo(-14, Std.int(this.box.height)>>1);



		adjustment.addEventListener (Event.CHANGE, onChanged, false, 0, true);
	}
	//}}}


	//{{{ onChanged
	private function onChanged(e:Event)	{progress = adjustment.getValue()/100;
		progress = adjustment.getValue()/100;
		update();
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(ProgressBar);
	}
	//}}}


	//{{{ update
	public function update() {
		progress = Math.max(0, Math.min(1, progress));


		if(label!=null)
		label.tf.text = Math.round(100*progress) + "%";


		if(mask!=null) {
			mazk = cast addChild(new Shape());
			mazk.graphics.clear();
			mazk.graphics.beginFill(0xFF00FF);
			mazk.graphics.drawRect(2,1,progress*box.width, box.height);
			mazk.graphics.endFill();
			bar.mask = mazk;
		}

		mazk.width = progress*box.width;
		//mazk.height = box.height;
	} //}}}


	//{{{ onResize
	public override function onResize(e:ResizeEvent) {
		label.center();
		label.move(0,2);


		bar.dirty = true;


		update();


		mazk.height = box.height;


		super.onResize(e);
	} //}}}


	public override function destroy() {
		bar.stopInterval();

		super.destroy();
	}
}
//}}}
