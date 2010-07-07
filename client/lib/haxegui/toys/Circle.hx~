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

class Circle extends Component
{
	public var radius : Float;
	public var pivot : Point;
	
	override public function init(?opts:Dynamic=null) {
		box = new Size(100,100).toRect();
		//pivot = new Size(100,100).shift(1).toPoint();
		pivot = new Point();
		//radius = Point.distance(new Point(x,y), pivot);
		radius = Point.distance(new Point(x,y), new Size(100,100).shift(1).toPoint());
		color = cast Math.random() * 0xFFFFFF;
		
		
		super.init(opts);

		radius = Opts.optFloat(opts, "radius", radius);
		//pivot = new Point(-radius/2, -radius/2);
		box = new Size(2*radius,2*radius).toRect();
		//~ pivot = new Size(radius,radius).shift(1).toPoint();
		
		
		setAction("redraw",
		"
		this.graphics.clear();
		this.graphics.beginFill(this.color);
		this.graphics.drawCircle(this.pivot.x,this.pivot.y,this.radius);
		this.graphics.endFill();
		"
		);

		this.filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.25, 4, 4, 0.5, flash.filters.BitmapFilterQuality.HIGH, false, false, false )];
	
	}

	static function __init__() {
		haxegui.Haxegui.register(Circle);
	}
	
	
}
