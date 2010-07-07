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


using haxegui.utils.Color;


/**
* Component with basic drawRect script.<br/>
* <p>Default proprties are set to random colors and some roundess.</p>
*/
class Rectangle extends Component {

	public var roundness : Float;
	public var stroke : UInt;
	public var thickness : Float;
	public var pivot : Point;

	//{{{ init
	override public function init(?opts:Dynamic=null) {
		box = new Size(100,100).toRect();
		color = Color.random().tint(.5);
		stroke = color.darken(20);
		thickness = 1;
		roundness = 20;
		pivot = new Point();


		super.init(opts);


		roundness = Opts.optFloat(opts, "roundness", roundness);
		thickness = Opts.optFloat(opts, "thickness", thickness);
		stroke = Opts.optInt(opts, "stroke", stroke);


		setAction("redraw",
		"
		this.graphics.clear();
		this.graphics.lineStyle(this.thickness, this.stroke, 1, true, flash.display.LineScaleMode.NONE);
		this.graphics.beginFill(this.color);
		this.graphics.drawRoundRect(this.pivot.x,this.pivot.y,this.box.width,this.box.height, this.roundness, this.roundness);
		this.graphics.endFill();

		"
		);
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Rectangle);
	}
	//}}}
}
