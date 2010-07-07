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
import haxegui.controls.IAdjustable;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}

class Knob extends Component, implements IAdjustable {

	//{{{ Members
	public var radius		 : Float;
	public var background	 : Circle;
	public var pot	 		 : Sprite;
	public var marker		 : Line;

	/** Adjustment object **/
	public var adjustment	 : Adjustment;

	/** slot **/
	public var slot			 : Socket;
	//}}}


	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic=null) {
		// if(box.isEmpty())
		box = new Size(60,60).toRect();
		adjustment = new Adjustment({ value: .0, min: Math.NEGATIVE_INFINITY, max: Math.POSITIVE_INFINITY, step: 10., page: 35.});
		// if(radius==null)
		// radius = Point.distance(new Point(x,y), Size.fromRect(box).shift(1).toPoint());
		//color = Color.random();
		//color = Color.tint(Color.BLACK, .5);


		super.init(opts);

		radius = Opts.optFloat(opts, "radius", radius);
		box = new Size(2*radius,2*radius).toRect();


		pot = new Sprite();
		pot.name = "pot";
		this.addChild(pot);

		setAction("redraw",
		"
		this.graphics.clear();

		var colors = [];
		for(i in 0...360) {
			if(i<=90)
			colors[i] = Color.tint(this.color, i/90) ;
			if(i>90 && i<=180)
			colors[i] = Color.tint(this.color, 1-(i-90)/90) ;
			if(i>180 && i<=270)
			colors[i] = Color.tint(this.color, (i-180)/90) ;
			if(i>270 && i<=360)
			colors[i] = Color.tint(this.color, 1-(i-270)/90) ;
		}
		var innerRadius = .75*this.radius;

		var alphas = [1, 1];
		var ratios = [0, 0xFF];
		var matrix = new flash.geom.Matrix ();

		matrix.createGradientBox (this.box.width, this.box.height, .5*Math.PI, 0, 0);


		for(i in 0...720) {
			var color = colors[i>>1];
			var angle = .5 * i * Math.PI / 180;
			this.pot.graphics.lineStyle(1, color, 1, false, flash.display.LineScaleMode.NONE, flash.display.CapsStyle.NONE);
			this.pot.graphics.moveTo(0,0);
			this.pot.graphics.lineTo(Math.cos(angle) * innerRadius, Math.sin(angle) * innerRadius);
		}

		this.pot.graphics.lineStyle(1, Color.WHITE, .5);
		this.pot.graphics.drawCircle(0,0, innerRadius);

		this.pot.filters = [new flash.filters.BevelFilter(4,45, Color.WHITE, .5, Color.BLACK, .5, 4, 4, .5),
							new flash.filters.DropShadowFilter (.33*this.radius, 45, Color.BLACK, 1, 5, 5, .7, flash.filters.BitmapFilterQuality.HIGH, false, false, false )];

		this.graphics.lineStyle(0, 0, 0, false, flash.display.LineScaleMode.NONE, flash.display.CapsStyle.NONE);
		this.graphics.beginFill(Color.tint(this.color, .8));
		this.graphics.drawCircle(0,0,this.radius);
		this.graphics.endFill();

		this.graphics.lineStyle(3, Color.darken(this.color, 16), 1, false, flash.display.LineScaleMode.NONE, flash.display.CapsStyle.NONE);
		this.graphics.drawCircle(0,0,innerRadius);

		this.graphics.lineStyle(1, Color.BLACK, .5, false, flash.display.LineScaleMode.NONE, flash.display.CapsStyle.NONE);
		for(i in 0...5) {
			var angle = i/2.5*Math.PI - Math.PI/10;
			this.graphics.moveTo(Math.cos(angle) * this.radius, Math.sin(angle) * this.radius);
			this.graphics.lineTo(Math.cos(angle) * innerRadius, Math.sin(angle) * innerRadius);

		}

		this.pot.rotation = 45;
		");

		var innerRadius = .75*this.radius;

		marker = new Line(this);
		marker.init({thickness: 2, color: Color.BLACK});
		marker.end = new Point(Math.sin(-145)*(innerRadius-4), Math.cos(-145)*(innerRadius-4));
		marker.filters = null;


		slot = new haxegui.toys.Socket(this);
		slot.init();
		slot.moveTo(-radius,radius);
		slot.color = Color.tint(slot.color, .5);

		adjustment.addEventListener (Event.CHANGE, onChanged, false, 0, true);


		cacheAsBitmap = true;

		// this.filters = [new flash.filters.DropShadowFilter (2, 45, DefaultStyle.DROPSHADOW, 0.75, 4, 4, 0.75, flash.filters.BitmapFilterQuality.HIGH, true, false, false )];

	}
	//}}}


	//{{{ onMouseWheel
	override public function onMouseWheel(e:MouseEvent) {
		adjustment.setValue(adjustment.getValue()+e.delta*(e.ctrlKey ? adjustment.object.page : adjustment.object.step));
		super.onMouseWheel(e);
	}
	//}}}


	//{{{ onMouseDown
	override public function onMouseDown(e:MouseEvent) {
		if(e.target==slot) return;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		super.onMouseDown(e);
	}
	//}}}


	//{{{ onMouseUp
	override public function onMouseUp(e:MouseEvent) {
		if(e.target==slot) return;
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		super.onMouseUp(e);
	}
	//}}}


	//{{{ onChanged
	public function onChanged(e:Event) {
		marker.rotation = adjustment.getValue();
	}
	//}}}


	//{{{ onMouseMove
	public function onMouseMove(e:MouseEvent) {
		var p = this.localToGlobal(new Point(0,0));
		var dist = e.stageX - p.x;
		adjustment.setValue(dist);
		//~ adjustment.adjust(adjustment.object);
		marker.rotation = dist;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Knob);
	}
	//}}}
	//}}}
}
