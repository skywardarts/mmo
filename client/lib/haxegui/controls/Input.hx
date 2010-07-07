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
import flash.events.TextEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import haxegui.controls.Component;
import haxegui.controls.IAdjustable;
import haxegui.controls.PopupMenu;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Align;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


//{{{ Input
/**
* Input wraps an editable [TextField].<br/>
*
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.2
*/
class Input extends Component, implements IText {

	//{{{ Members
	public var password 					: Bool;
	public var selection(getSelection, null): String;
	public var text(getText, setText) 		: String;
	public var tf 							: TextField;
	public var align						: Alignment;
	//}}}

	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic) : Void	{
		box = new Size(140, 20).toRect();
		align = { horizontal: HorizontalAlign.LEFT, vertical: VerticalAlign.CENTER };


		super.init(opts);


		mouseChildren = true;
		mouseEnabled = true;
		tabEnabled = true;

		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.8, 4, 4, 0.65, flash.filters.BitmapFilterQuality.HIGH, true, false, false )];


		tf = new TextField();
		tf.autoSize =  TextFieldAutoSize.NONE;
		tf.background = false;
		tf.border = false;
		tf.embedFonts = true;
		tf.height -=4;
		tf.height = box.height;
		tf.mouseEnabled = true;
		tf.name = "tf";
		tf.selectable = ! disabled;
		tf.tabEnabled = false;
		tf.text = Opts.optString(opts, "text", name);
		tf.restrict = Opts.optString(opts, "restrict", null);
		tf.type = TextFieldType.INPUT;
		tf.width = box.width;
		tf.x = 0;
		tf.y = 4;

		var fmt = DefaultStyle.getTextFormat();
		fmt.leftMargin = 4;
		fmt.leading = 14;
		tf.defaultTextFormat = fmt;
		tf.setTextFormat(fmt);

		addChild(tf);
		//addEventListener(TextEvent.TEXT_INPUT, onChanged, false, 0, true);
	} //}}}



	public override function onResize(e:ResizeEvent) {
		tf.width = box.width - 4;
		tf.height = box.height - 4;

		dirty = true;
	}



	//{{{ __setDisabled
	override private function __setDisabled(v:Bool) : Bool {
		super.__setDisabled(v);
		if(this.disabled) {
			mouseEnabled = false;
			buttonMode = false;
			if(tf!=null) {
				tf.mouseEnabled = false;
				tf.selectable = false;
			}
		}
		else {
			mouseEnabled = Opts.optBool(initOpts,"mouseEnabled",true);
			buttonMode = Opts.optBool(initOpts,"buttonMode",true);
			if(tf!=null) {
				tf.mouseEnabled = false;
				tf.selectable = true;
			}
		}
		return v;
	}
	//}}}


	//{{{ getText
	public function getText() : String {
		return tf.text;
	} //}}}


	//{{{ setText
	public function setText(s:String) : String {
		tf.text = s;
		this.dispatchEvent(new Event(Event.CHANGE));
		return s;
	} //}}}


	//{{{ getSelection
	public function getSelection() : String {
		return tf.selectedText;
	} //}}}


	//{{{ setSelection
	public function setSelection(s:String) : String {
		return selection;
	} //}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Input);
	}
	//}}}
	//}}}
}
//}}}


class AutoCompleteInput extends Input {

	public var popup : PopupMenu;

}
