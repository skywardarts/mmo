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
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.controls.Component;
import haxegui.controls.IAdjustable;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.FocusManager;
import haxegui.managers.ScriptManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


using haxegui.utils.Color;
using haxegui.controls.Component;


//{{{ RadioGroup
/**
* Helper class to group radio buttons.<br/>
* @todo adjustment
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
**/
class RadioGroup extends Component, implements IAdjustable {

	public var adjustment : Adjustment;

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(RadioGroup);
	}
	//}}}
}
//}}}


//{{{ RadioButton
/**
* RadioButton allows the user to select only one of the predefined set of similar widgets.<br/>
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
**/
class RadioButton extends Button {

	public var group : RadioGroup;

		//{{{ Members
	static var styleXml = Xml.parse('
	<haxegui:Style name="RadioButton">
		<haxegui:controls:RadioButton>
			<events>
			<script type="text/hscript" action="mouseClick"><![CDATA[
			]]>
			</script>
			</events>
		</haxegui:controls:RadioButton>
	</haxegui:Style>
	').firstElement();

	static var layoutXml = Xml.parse('
	<haxegui:Layout name="RadioButton">
	</haxegui:Layout>
	').firstElement();
	//}}}

	//{{{ init
	override public function init(?opts:Dynamic) {
		super.init(opts);


		box = new Size(20,20).toRect();

		layoutXml.set("name", name);

		haxegui.XmlParser.apply(RadioButton.styleXml, true);
		haxegui.XmlParser.apply(RadioButton.layoutXml, this);


		selected = Opts.optBool(opts, "selected", selected);

		// label on by default
		if(Opts.optString(opts, "label", name)!="false") {
			label = new Label(this, 24, 4);
			label.init({
				text: Opts.optString(opts, "label", name),
				valign: "center",
				disabled: this.disabled
			});
		}

		// dropshadow filter
		filters = [new flash.filters.DropShadowFilter (1, 45, DefaultStyle.DROPSHADOW, 0.8, 2, 2, 0.65, flash.filters.BitmapFilterQuality.LOW, true, false, false )];


	}
	//}}}

	//{{{ onResize
	public override function onResize(e:ResizeEvent) {
		super.onResize(e);

		label.box = box.clone();
		label.onResize(e);
		// label.x = Math.min(box.width, box.height) + 4;
		// label.y = .5*box.height;
	}
	//}}}

	//{{{ onMouseClick
	public override function onMouseClick(e:MouseEvent) {
		if(disabled) return;

		for(child in parent.asComponent()) {
			if(Std.is(child, RadioButton))
			untyped if(child!=this && !child.disabled) {
				child.selected = false;
				child.redraw();
			}
		}
		selected = true;
		redraw();

		super.onMouseClick(e);
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(RadioButton);
	}
	//}}}

}
//}}}
