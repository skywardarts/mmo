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

//{{{ Imports
import flash.text.TextField;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxegui.controls.Component;
import haxegui.controls.Label;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
import haxegui.toys.Pin;
//}}}

class Note extends haxegui.toys.Rectangle, implements haxegui.controls.IText
{
	public var tf : TextField;
	public var text (getText, setText)  : String;

	public var pin : Pin;

	override public function init(?opts:Dynamic) {
		box = new Size(100,100).toRect();
		color = Color.random();
		pivot = new Point();
		if(text==null) text=name;

		super.init(opts);

		roundness = Opts.optFloat(opts, "roundness", 8);

		tf = new TextField();
		tf.name = "tf";
		tf.x = 2;
		tf.y = 2;
		//tf.border = true;
		//tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
		tf.focusRect = false;
		tf.multiline = true;
		tf.selectable = true;
		tf.type = flash.text.TextFieldType.INPUT;
		tf.wordWrap = Opts.optBool(opts, "wordWrap", true);

		//if(!box.isEmpty()) {
			tf.width = box.width - 4;
			tf.height = box.height - 4;
		//}


		var fmt = new flash.text.TextFormat("Comic Sans MS", 16);
		tf.defaultTextFormat = fmt;
		this.addChild(tf);


		tf.text = Opts.optString(opts, "text", text);
		//tf.setTextFormat(DefaultStyle.getTextFormat(Opts.optInt(opts, "size", DefaultStyle.FONT_SIZE), Opts.optInt(opts, "color", DefaultStyle.LABEL_TEXT)));
		tf.setTextFormat(fmt);


		//~ var shadow = new flash.filters.DropShadowFilter (8, 45, DefaultStyle.DROPSHADOW, 0.8, 4, 4, 0.65, flash.filters.BitmapFilterQuality.HIGH, false, false, false );
		//~ this.filters = [shadow];

		setAction("mouseDown", "this.toFront();");
	//	setAction("focusOut", "this.toFront();");

		setAction("redraw",
		"
		this.graphics.clear();
		this.graphics.beginFill(this.color);
		this.graphics.drawRoundRect(this.pivot.x,this.pivot.y,this.box.width,this.box.height, this.roundness, this.roundness);
		this.graphics.endFill();
		"
		);

		pin = new Pin(this, .5*this.box.width, -2);
		pin.init();

		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5, 4, 4, 0.5, flash.filters.BitmapFilterQuality.HIGH, false, false, false )];
	}


	//{{{ getText
	public function getText() : String {
		if(tf==null) return null;
		return tf.text;
	}
	//}}}


	//{{{ setText
	public function setText(s:String) : String {
		if(tf==null || s==null) return null;
		tf.text = s;
		//tf.setTextFormat(DefaultStyle.getTextFormat());
		//dispatchEvent(new Event(Event.CHANGE));
		resize(new Size(tf.width, tf.height));
		return tf.text;
	}
	//}}}

	//{{{ onResize
	public override function onResize(e:ResizeEvent) {
		super.onResize(e);

		if(tf==null) return;
		tf.width = box.width - 4;
		tf.height = box.height - 4;

		if(pin==null) return;
		pin.moveTo(.5*this.box.width, -2);
	}
	///}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Note);
	}
	//}}}

}
