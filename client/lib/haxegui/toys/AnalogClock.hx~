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


//{{{ HoursHand
class HoursHand extends Line {

	public override function init(?opts:Dynamic) {
		super.init(opts);
		var r = -.45*Math.min( .5*(cast parent).box.width, .5*(cast parent).box.height );
		end = new Point(0,r);
		rotation = Date.now().getHours()*30 + Date.now().getMinutes()*.5;
		center();
	}


	static function __init__() {
		haxegui.Haxegui.register(HoursHand);
	}
}
//}}}


//{{{ MinutesHand
class MinutesHand extends Line {

	public override function init(?opts:Dynamic) {
		super.init(opts);
		thickness = 3;
		var r = -.65*Math.min( .5*(cast parent).box.width, .5*(cast parent).box.height );
		end = new Point(r,r);
		rotation = Date.now().getMinutes()*6;
		center();
	}

	static function __init__() {
		haxegui.Haxegui.register(MinutesHand);
	}
}
//}}}


//{{{ SecondsHand
class SecondsHand extends Line {

	public override function init(?opts:Dynamic) {
		super.init(opts);
		thickness = 1;
		var r = -.85*Math.min( .5*(cast parent).box.width, .5*(cast parent).box.height );
		end = new Point(0,r);
		rotation = Date.now().getMinutes()*6;
		center();
	}


	static function __init__() {
		haxegui.Haxegui.register(SecondsHand);
	}
}
//}}}



//{{{ AnalogClock
/**
* Analog Clock widget.<br/>
*/
class AnalogClock extends AbstractButton
{

	var face : Circle;
	var hours : HoursHand;
	var minutes : MinutesHand;
	var seconds : Component;

	var timer : haxe.Timer;

	override public function init(?opts:Dynamic) {
		box = new Size(128, 128).toRect();
		color = Color.tint(Color.random(), .5);

		mouseChildren = false;

		super.init(opts);

		hours = new HoursHand(this);
		hours.init();

		minutes = new MinutesHand(this);
		minutes.init();

		seconds = new SecondsHand(this);
		seconds.init();

		timer = new haxe.Timer(1000);
		timer.run = tick;

		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.8, 8, 8, 0.65, flash.filters.BitmapFilterQuality.HIGH, false, false, false )];

	}

	public override function redraw(?opt:Dynamic=null) {

		this.graphics.clear();
		this.graphics.lineStyle(2, Color.darken(this.color, 40), 1, true,
								flash.display.LineScaleMode.NORMAL,
								flash.display.CapsStyle.ROUND,
								flash.display.JointStyle.ROUND);
		this.graphics.beginFill(this.color);
		var r = Math.min( Std.int(this.box.width)>>1, Std.int(this.box.height)>>1 );
		this.graphics.drawCircle(r,r,r);
		this.graphics.drawCircle(r,r,.90*r);
		this.graphics.endFill();

		var colors = [this.color, Color.darken(this.color, 60)];
		var alphas = [.5, .5];
		var ratios = [0, 0xFF];
		var matrix = new flash.geom.Matrix ();

		matrix.createGradientBox (r, r, .5*Math.PI, 0, 0);


		this.graphics.beginGradientFill (flash.display.GradientType.LINEAR,
				colors,	alphas,	ratios,	matrix);

		this.graphics.drawCircle(r,r,r);
		this.graphics.endFill();

		this.graphics.lineStyle(4, Color.darken(this.color, 40), 1, true,
								flash.display.LineScaleMode.NORMAL,
								flash.display.CapsStyle.ROUND,
								flash.display.JointStyle.ROUND);
		for (h in 0...12) {
		var hourAngle = h*30;
		var radHourAngle = hourAngle*Math.PI/180;
		var xCoord1 = Math.cos(radHourAngle)*(.90*r)+r;
		var yCoord1 = Math.sin(radHourAngle)*(.90*r)+r;
		var xCoord2 = Math.cos(radHourAngle)*(.80*r)+r;
		var yCoord2 = Math.sin(radHourAngle)*(.80*r)+r;
		this.graphics.moveTo(xCoord1, yCoord1);
		this.graphics.lineTo(xCoord2, yCoord2);
		}

		this.graphics.lineStyle(2, Color.darken(this.color, 40), 1, true,
								flash.display.LineScaleMode.NORMAL,
								flash.display.CapsStyle.ROUND,
								flash.display.JointStyle.ROUND);
		for (m in 0...60) {
		var minuteAngle = m*6;
		var radMinuteAngle = minuteAngle*Math.PI/180;
		var xCoord1 = Math.cos(radMinuteAngle)*(.90*r)+r;
		var yCoord1 = Math.sin(radMinuteAngle)*(.90*r)+r;
		var xCoord2 = Math.cos(radMinuteAngle)*(.85*r)+r;
		var yCoord2 = Math.sin(radMinuteAngle)*(.85*r)+r;
		this.graphics.moveTo(xCoord1, yCoord1);
		this.graphics.lineTo(xCoord2, yCoord2);
		}
	}

	public override function onMouseDown(e:flash.events.MouseEvent) {
		this.startDrag();
		super.onMouseDown(e);
	}

	public override function onMouseUp(e:flash.events.MouseEvent) {
		this.stopDrag();
		super.onMouseUp(e);
	}


	public override function onResize(e:haxegui.events.ResizeEvent) {
		hours.redraw();
		hours.center();

		minutes.redraw();
		minutes.center();

		seconds.redraw();
		seconds.center();
	}

	public function tick() {
		hours.rotation += 1/(3600) + 1/120;
		minutes.rotation += 1/60;
		seconds.rotation++;
	}
	static function __init__() {
		haxegui.Haxegui.register(AnalogClock);
	}

}
//}}}