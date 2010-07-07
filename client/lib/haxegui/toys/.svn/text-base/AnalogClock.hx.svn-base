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
import flash.geom.Point;
import flash.geom.Rectangle;

import haxegui.controls.Component;
import haxegui.controls.AbstractButton;

import haxegui.utils.Size;
import haxegui.utils.Color;

import haxegui.toys.Circle;

import haxegui.managers.StyleManager;
//}}}


using haxegui.utils.Color;


//{{{ AnalogClock
/**
* Analog Clock widget.<br/>
*/
class AnalogClock extends AbstractButton {

	var face	: Circle;
	var overlay : Component;
	var hours 	: Line;
	var minutes : Line;
	var seconds : Line;

	var timer : haxe.Timer;


	//{{{ init
	override public function init(?opts:Dynamic) {
		box = new Size(128, 128).toRect();
		color = Color.random().tint(.5);

		mouseChildren = false;

		super.init(opts);

		var r = -Math.min( .5*box.width, .5*box.height );

		face = new Circle(this);
		face.init({radius: r, color: Color.WHITE, alpha: .75});
		face.pivot = new Point(-r,-r);

		hours = new Line(this);
		hours.init({thickness: 4, rotation: Date.now().getHours()*30 + Date.now().getMinutes()*.5, color: Color.BLACK});
		hours.end = new Point(0,.45*r);
		hours.center();

		minutes = new Line(this);
		minutes.init({thickness: 2, rotation: Date.now().getMinutes()*6, color: Color.BLACK});
		minutes.end = new Point(0,.65*r);
		minutes.center();

		seconds = new Line(this);
		seconds.init({thickness: 1, rotation: Date.now().getMinutes()*6, color: Color.RED});
		seconds.end = new Point(0,.85*r);
		seconds.center();

		overlay = new Component(this);
		overlay.init();

		timer = new haxe.Timer(1000);
		timer.run = tick;

		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.8, 8, 8, 0.65, flash.filters.BitmapFilterQuality.HIGH, false, false, false ),
				new flash.filters.BevelFilter (2, 60, Color.WHITE, .85, Color.BLACK, .65, 1, 1, 1)
				];
	}
	//}}}


	//{{{
	public override function redraw(?opt:Dynamic=null) {

		overlay.graphics.clear();
		overlay.graphics.lineStyle(1, Color.darken(this.color, 40), 1, true, flash.display.LineScaleMode.NONE, flash.display.CapsStyle.ROUND, flash.display.JointStyle.ROUND);

		var r = Math.min( Std.int(this.box.width)>>1, Std.int(this.box.height)>>1 );

		overlay.graphics.beginFill(this.color);
		overlay.graphics.drawCircle(r,r,r);
		overlay.graphics.drawCircle(r,r,.90*r);
		overlay.graphics.endFill();

		// var colors = [this.color, Color.darken(this.color, 60)];
		// var alphas = [.5, .5];
		// var ratios = [0, 0xFF];
		// var matrix = new flash.geom.Matrix ();

		// matrix.createGradientBox (r, r, .5*Math.PI, 0, 0);

		// this.graphics.beginGradientFill (flash.display.GradientType.LINEAR, colors,	alphas,	ratios,	matrix);
		// this.graphics.drawCircle(r,r,r);
		// this.graphics.endFill();

		overlay.graphics.lineStyle(4, Color.darken(this.color, 40), 1, true, flash.display.LineScaleMode.NORMAL, flash.display.CapsStyle.ROUND, flash.display.JointStyle.ROUND);

		for (h in 0...12) {
			var hourAngle = h*30;
			var radHourAngle = hourAngle*Math.PI/180;
			var xCoord1 = Math.cos(radHourAngle)*(.85*r)+r;
			var yCoord1 = Math.sin(radHourAngle)*(.85*r)+r;
			var xCoord2 = Math.cos(radHourAngle)*(.75*r)+r;
			var yCoord2 = Math.sin(radHourAngle)*(.75*r)+r;
			overlay.graphics.moveTo(xCoord1, yCoord1);
			overlay.graphics.lineTo(xCoord2, yCoord2);
		}

		overlay.graphics.lineStyle(2, Color.darken(this.color, 40), 1, true, flash.display.LineScaleMode.NORMAL, flash.display.CapsStyle.ROUND, flash.display.JointStyle.ROUND);

		for (m in 0...60) {
			var minuteAngle = m*6;
			var radMinuteAngle = minuteAngle*Math.PI/180;
			var xCoord1 = Math.cos(radMinuteAngle)*(.85*r)+r;
			var yCoord1 = Math.sin(radMinuteAngle)*(.85*r)+r;
			var xCoord2 = Math.cos(radMinuteAngle)*(.80*r)+r;
			var yCoord2 = Math.sin(radMinuteAngle)*(.80*r)+r;
			overlay.graphics.moveTo(xCoord1, yCoord1);
			overlay.graphics.lineTo(xCoord2, yCoord2);
		}
	}
	//}}}


	//{{{ onMouseDown
	public override function onMouseDown(e:flash.events.MouseEvent) {
		this.startDrag();
		super.onMouseDown(e);
	}
	//}}}


	//{{{ onMouseUp
	public override function onMouseUp(e:flash.events.MouseEvent) {
		this.stopDrag();
		super.onMouseUp(e);
	}
	//}}}


	//{{{ onResize
	public override function onResize(e:haxegui.events.ResizeEvent) {
		face.radius = Math.min(.5*box.width, .5*box.height);
		face.redraw();

		hours.redraw();
		hours.center();

		minutes.redraw();
		minutes.center();

		seconds.redraw();
		seconds.center();
	}
	//}}}


	//{{{ tick
	public function tick() {
		hours.rotation += 1/(3600) + 1/120;
		minutes.rotation += 1/60;
		seconds.rotation++;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(AnalogClock);
	}
	//}}}
}
//}}}