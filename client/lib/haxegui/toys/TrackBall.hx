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

import flash.geom.Point;
import flash.geom.Rectangle;

import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.events.FocusEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.Opts;

import haxegui.Component;


class TrackBall extends Component
{
	public var pivot : Point;
	public var v : Point;

	override public function init(?opts:Dynamic)
	{
		box = new flash.geom.Rectangle(0,0,100,100);
		color = cast Math.random() * 0xFFFFFF;
		pivot = new Point(50,50);
		v = new Point();
		
		super.init(opts);

		text = null;
		
		//roundness = Opts.optFloat(opts, "roundness", roundness);
		

		//~ var shadow = new flash.filters.DropShadowFilter (8, 45, DefaultStyle.DROPSHADOW, 0.8, 4, 4, 0.65, flash.filters.BitmapFilterQuality.HIGH, false, false, false );
		//~ this.filters = [shadow];
			
	
		setAction("redraw",
		"
		this.graphics.clear();
		this.graphics.beginFill(Color.darken(DefaultStyle.BACKGROUND, 20));
		this.graphics.drawRect(0,0,this.box.width,this.box.height);
		this.graphics.endFill();
		
		var colors = [Color.tint(this.color, .1), this.color];
		var alphas =[1, 1];
		var ratios =[0, 0xFF];
		var matrix = new flash.geom.Matrix ();
		matrix.createGradientBox (this.box.width, this.box.height, .5*Math.PI, this.v.x - this.pivot.x, this.v.y - this.pivot.y);

		this.graphics.beginGradientFill (flash.display.GradientType.RADIAL, colors, alphas, ratios, matrix);
		this.graphics.drawCircle(this.pivot.x, this.pivot.y, .5*Math.min(this.box.width, this.box.height));
		this.graphics.endFill();
		
		this.v.normalize(1);
		
		this.graphics.lineStyle(1, 0xFF0000, 1);
		this.graphics.moveTo(this.pivot.x, this.pivot.y);
		this.graphics.lineTo(
		this.box.width*Math.cos(this.v.x) - this.box.height*Math.sin(this.v.y),		
		this.box.width*Math.sin(this.v.x) + this.box.height*Math.cos(this.v.y)
		);
		
		
		
		");

		
		parent.addEventListener(ResizeEvent.RESIZE, onParentResize);
		
	}

	public override function onMouseDown(e:MouseEvent) {
		this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		super.onMouseDown(e);
	}

	public override function onMouseUp(e:MouseEvent) {
		this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		super.onMouseUp(e);
	}
	

	public function onMouseMove(e:MouseEvent) {
		v = new flash.geom.Point( e.localX, e.localY );
		//v.normalize(Math.min(this.box.width,this.box.height));
		this.redraw();
	}
	
	static function __init__() {
		haxegui.Haxegui.register(TrackBall);
	}
	

	public function onParentResize(e:ResizeEvent) {
		
		if(Std.is(parent, Component))
		{
			box = untyped parent.box.clone();
			box.width -= x;
			box.height -= y;
		}
	}
		
}
