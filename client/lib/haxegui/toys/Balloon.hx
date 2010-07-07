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
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}

class Balloon extends haxegui.toys.Rectangle
{

	override public function init(?opts:Dynamic) {
		box = new Size(100,100).toRect();
		color = Color.random();
		roundness = Opts.optFloat(opts, "roundness", 16);
		pivot = new Point();

		super.init(opts);

		//~ var shadow = new flash.filters.DropShadowFilter (8, 45, DefaultStyle.DROPSHADOW, 0.8, 4, 4, 0.65, flash.filters.BitmapFilterQuality.HIGH, false, false, false );
		//~ this.filters = [shadow];

		setAction("redraw",
		"
		this.graphics.clear();
		this.graphics.beginFill(this.color);
		this.graphics.drawRoundRect(this.pivot.x,this.pivot.y,this.box.width,this.box.height, this.roundness, this.roundness);
		this.graphics.moveTo(10, this.box.height);
		this.graphics.lineTo(15, this.box.height+8);
		this.graphics.lineTo(25, this.box.height);
		this.graphics.endFill();
		"
		);
	}

	static function __init__() {
		haxegui.Haxegui.register(Balloon);
	}


}
