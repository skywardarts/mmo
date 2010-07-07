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
import flash.geom.Rectangle;
import haxegui.Haxegui;
import haxegui.controls.AbstractButton;
import haxegui.controls.Button;
import haxegui.controls.IAdjustable;
import haxegui.managers.CursorManager;
import haxegui.managers.FocusManager;
import haxegui.managers.StyleManager;
import haxegui.toys.Socket;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


//{{{ CheckBox
/**
* An on\off CheckBox, special kind of PushButton.<br/>
* You can use the dispatched event:
* <pre class="code haxe">
* var chkbox = new CheckBox();
* chkbox.init();
* chkbox.addEventListener(Event.CHANGE, function(e){...});
* </pre>
* Or you could override the default action:
* <pre class="code haxe">
* var chkbox = new CheckBox();
* chkbox.init();
* chkbox.setAction("mouseClick",
* "// this is the default code
* if(!this.disabled) {
*	this.setSelected(!this.getSelected());
*	this.redraw();
*	this.updateColorTween( new feffects.Tween(50, 0, 150, feffects.easing.Linear.easeNone) );
*   // your code here...
* }
* ");
* </pre>
*
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
**/
class CheckBox extends PushButton {

	//{{{ Members
	static var styleXml = Xml.parse('
	<haxegui:Style name="CheckBox">
		<haxegui:controls:CheckBox>
			<events>
			<script type="text/hscript" action="mouseClick"><![CDATA[
			]]>
			</script>
			</events>
		</haxegui:controls:CheckBox>
	</haxegui:Style>
	').firstElement();

	static var layoutXml = Xml.parse('
	<haxegui:Layout name="CheckBox">
	</haxegui:Layout>
	').firstElement();
	//}}}

	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic=null) {
		adjustment = new Adjustment({ value: false, min: false, max: true, step:null, page: null});

		super.init(opts);

		box = Size.square(20).toRect();


		layoutXml.set("name", name);

		haxegui.XmlParser.apply(CheckBox.styleXml, true);
		haxegui.XmlParser.apply(CheckBox.layoutXml, this);


		mouseChildren = true;
		doubleClickEnabled = false;


		// label
		label = cast firstChild();
		if(label!=null) {
		label.box.width -= 30;
		label.center();
		label.move(30,0);
		}

		// slot
		// slot = new haxegui.toys.Socket(this);
		// slot.init({visible:  Haxegui.slots});
		// slot.moveTo(-14,Std.int(this.box.height)>>1);
		// slot.color = Color.tint(slot.color, .5);


		adjustment.addEventListener (Event.CHANGE, onChanged, false, 0, true);
	}
	//}}}


	//{{{ onChanged
	public function onChanged(e:Event) {
		// trace(e+"\t"+adjustment.valueAsString());
		selected = cast adjustment.getValue();
		redraw();
	}
	//}}}


	///{{{ __setDisabled
	override private function __setDisabled(v:Bool) : Bool {
		super.__setDisabled(v);
		if(this.disabled) {
			mouseEnabled = false;
			buttonMode = false;
		}
		else {
			mouseEnabled = Opts.optBool(initOpts,"mouseEnabled",true);
			buttonMode = Opts.optBool(initOpts,"buttonMode",true);
		}
		return v;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(CheckBox);
	}
	//}}}
	//}}}
}
//}}}