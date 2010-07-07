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

class Line extends haxegui.controls.AbstractButton
{
	public var start : Point;
	public var end	 : Point;
	
	public var thickness : Float;
	
	override public function init(?opts:Dynamic=null) {
		color = Color.random();
		thickness = 6;

		thickness = Opts.optFloat(opts, "thickness", thickness);

		super.init(opts);
		
		//~ mouseEnabled = false;

		start = new Point();
		end = new Point(parent.mouseX, parent.mouseY);

		setAction("redraw",
		"	
		this.graphics.clear();
		this.graphics.lineStyle(this.thickness, this.color);
		this.graphics.moveTo( this.start.x, this.start.y );
		this.graphics.lineTo( this.end.x, this.end.y);
		"
		);

		this.filters = [new flash.filters.DropShadowFilter (8, 45, DefaultStyle.DROPSHADOW, 0.8, 4, 4, 0.65, flash.filters.BitmapFilterQuality.HIGH, false, false, false )];
				
				
		//this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		//this.stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);

		//~ this.startInterval(25);

	}


	function onMove(e) {
		//end = new Point(e.stageX-this.x, e.stageY-this.y);
		redraw();
	}

	
	function onRelease(e:MouseEvent) {
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		//~ haxe.Timer.delay( stopInterval, 5000 );
		//~ var t = new feffects.Tween( k, 0, 2500, this, "k", feffects.easing.Elastic.easeOut );
		//~ t.start();
	}

	override public function onMouseDoubleClick(e:MouseEvent) : Void {
		this.destroy();
	}

	static function __init__() {
		haxegui.Haxegui.register(Line);
	}
}
