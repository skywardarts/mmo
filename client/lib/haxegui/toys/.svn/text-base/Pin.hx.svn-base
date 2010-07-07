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
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}

class Pin extends AbstractButton {

	public var radius : Float;

	//{{{ init
	override public function init(?opts:Dynamic=null) {

		super.init(opts);

		radius = Opts.optFloat(opts, "radius", 8);
		box = Size.square(Std.int(2*radius)).toRect();
		color = Color.tint(Color.random(), .85);
		description = null;

		setAction("mouseDown", "
		this.toFront();
		parent.startDrag();
		"
		);

		setAction("mouseUp", "
		parent.stopDrag();
		var oa = stage.getObjectsUnderPoint(new flash.geom.Point(event.stageX, event.stageY));

		"
		);

		setAction("redraw",
		"
		this.graphics.clear();

		this.graphics.lineStyle(3, Color.BLACK, 1, true, flash.display.LineScaleMode.NONE);
		this.graphics.moveTo(-this.radius*.75,this.radius);
		this.graphics.lineTo(this.radius,-this.radius*.75);

		this.graphics.lineStyle(1, Color.darken(this.color, 30), 1, true, flash.display.LineScaleMode.NONE);

		var colors = [Color.tint(this.color, .5), this.color, Color.darken(this.color, 30)];
		var matrix = new flash.geom.Matrix ();
		//matrix.createGradientBox (this.box.width, this.box.height, .5*Math.PI, 0, this.box.height>>1);
		matrix.createGradientBox (2*this.radius,2*this.radius, .5*Math.PI, this.radius*.5, -this.radius*3);

		this.graphics.beginGradientFill (flash.display.GradientType.RADIAL, colors, [1, 1, 1], [0, 0x7F, 0xFF], matrix);
		this.graphics.drawCircle(this.radius, -this.radius, this.radius);
		this.graphics.endFill();


		"
		);

		var shadow = new Sprite();
		shadow.graphics.lineStyle(3, Color.BLACK, .2, true, flash.display.LineScaleMode.NONE);
		shadow.graphics.moveTo(-this.radius*.75,this.radius);
		shadow.graphics.lineTo(this.radius, this.radius*.75);
		shadow.graphics.lineStyle(0,0,0);
		shadow.graphics.beginFill(Color.BLACK, .25);
		shadow.graphics.drawCircle(this.radius, this.radius, this.radius*.75);
		shadow.graphics.endFill();
		addChild(shadow);
		shadow.filters = [new flash.filters.BlurFilter (2, 2, flash.filters.BitmapFilterQuality.HIGH)];
//		this.filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5, 4, 4, 0.5, flash.filters.BitmapFilterQuality.HIGH, false, false, false )];

	}
	//}}}

	public override function onResize(e:ResizeEvent) {
		var s = Size.fromRect(box).shift(1);
		radius = Math.min(s.width, s.height);
		dirty = true;
	}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Circle);
	}
	//}}}
}
