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

package haxegui;


//{{{ Imports
import feffects.Tween;
import flash.Error;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import haxe.Timer;
import haxegui.Window;
import haxegui.containers.Container;
import haxegui.controls.Component;
import haxegui.controls.Label;
import haxegui.controls.Stepper;
import haxegui.controls.UiList;
import haxegui.events.DragEvent;
import haxegui.events.MenuEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
import haxegui.windowClasses.StatusBar;
//}}}


using haxegui.utils.Color;


/**
*
* Some textual and chart performance statistics.<br/>
*
*/
class Stats extends Window {

	//{{{ Members
	var list : UiList;
	var list2 : UiList;

	var gridSpacing : UInt;
	var graph : Component;
	var grid : Sprite;
	var ploter : Sprite;
	var container : Container;


	var data  : Array<Array<Int>>;
	var data2 : Array<Array<Int>>;
	var data3 : Array<Array<Int>>;
	var data4 : Array<Array<Int>>;


	public var timer : Timer;
	public var interval : Int;
	var last : Float;
	var delta : Float;


	var frameCounter : Int;
	var fps    : Float;
	var avgFPS : Array<Float>;
	var maxFPS : Float;
	var minFPS : Float;
	//}}}


	//{{{ init
	public override function init(?initObj:Dynamic) {


		super.init({name: "Stats", widht: 400, height: 220, type: WindowType.MODAL, sizeable:false, color: 0x2A7ACD});


		box = new Size(400, 220).toRect();
		avgFPS = [Math.NaN];
		delta = 0;
		frameCounter = 0;
		gridSpacing = 20;
		interval = 750;
		maxFPS = Math.NEGATIVE_INFINITY;
		minFPS = Math.POSITIVE_INFINITY;


		data = data2 = data3 = data4 = [[240, 180], [240, 180]];


		//
		container = new Container (this, "container", 10, 20);
		container.init({color: 0x2A7ACD});

		//{{{ Lists
		list = new UiList(container, "List1");
		var ds = new DataSource();
		ds.data = ["FPS", "minFPS", "maxFPS", "avgFPS", "objs", "dirty", "Mem", "Uptime"];
		list.dataSource = ds;
		list.init({color: 0x2A7ACD, width: 70, height: 160});

		list2 = new UiList(container, "List2");
		var ds2 = new DataSource();
		ds2.data = [];
		for(i in 0...ds2.data.length)
		ds2.data.push(Std.string(Math.NaN));

		list2.dataSource = ds2;

		list2.init({color: 0x2A7ACD, width: 70, height: 180});
		list2.move(70,0);
		//}}}


		//{{{ Graph
		graph = new Component(container);
		graph.init();
		graph.moveTo(141, 0);
		graph.scrollRect = new Size(250,180).toRect();

		grid = new Component(graph);

		grid.graphics.lineStyle(0,0,0);
		grid.graphics.beginFill( Color.WHITE.darken(10) );
		grid.graphics.drawRect(0,0,240+gridSpacing*4,180);
		grid.graphics.endFill();

		for(i in 0...Std.int(240/(gridSpacing-4))) {
			grid.graphics.lineStyle(1, Color.WHITE.darken(50));
			grid.graphics.moveTo(gridSpacing*i,0);
			grid.graphics.lineTo(gridSpacing*i,180);
		}

		for(i in 0...Std.int(180/gridSpacing)) {
			grid.graphics.lineStyle(1,0xCCCCCC);
			grid.graphics.moveTo(0,gridSpacing*i);
			grid.graphics.lineTo(250+4*gridSpacing,gridSpacing*i);
		}

		ploter = new Sprite();
		graph.addChild(ploter);
		//}}}


		//{{{ StatusBar
		var statusbar = new StatusBar(this, "StatusBar", 10);
		statusbar.init();

		var label = new Label(statusbar, "Label", 260, 2);
		label.init({text: "Update Interval: "});

		//{{{ Stepper
		var stepper = new Stepper(statusbar, "Stepper", 346, 0);
		stepper.init({color: 0x2A7ACD, min: 20, step: 25, page: 100, value: interval});
		//stepper.adjustment.value = interval;
		stepper.input.tf.text = Std.string(interval);

		var self = this;

		stepper.adjustment.addEventListener(Event.CHANGE,
		function(e:Event) {
			self.interval = Std.int(Math.max(20, e.target.getValue()));
			self.reset();
		});
		//}}}
		//}}}


		reset();


		addEventListener (Event.ENTER_FRAME, onStatsEnterFrame);

		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));

	}
	//}}}


	//{{{ reset
	public function reset() {
		frameCounter = 0;
		delta = 0;
		maxFPS = Math.NEGATIVE_INFINITY;
		minFPS = Math.POSITIVE_INFINITY;
		avgFPS = [Math.NaN];

		ploter.graphics.clear();
		ploter.x = 0;

		data  = [[240, 180], [240, 180]];
		data2 = [[240, 180], [240, 180]];
		data3 = [[240, 180], [240, 180]];
		if(timer!=null) timer.stop();
		timer = new haxe.Timer(interval);
		timer.run = update;
	}
	//}}}


	//{{{ update
	/**
	*
	*
	*/
	public function update() {
		//{{{ FPS
		var delta = haxe.Timer.stamp() - last;

		fps = frameCounter/delta ;


		if(fps > maxFPS) maxFPS = fps;
		if(fps < minFPS) minFPS = fps;


		if(Math.isNaN(avgFPS[0])) avgFPS.pop();
		avgFPS.push(fps);

		var avg : Float = 0;
		for(i in avgFPS)
		avg += i;
		avg /= avgFPS.length;
		if(avgFPS.length > 25 ) avgFPS.shift();
		//}}}

		// //{{{ List
		// list2.data =
		// [   "",
		// Std.string(fps).substr(0,5),
		// Std.string(minFPS).substr(0,5),
		// Std.string(maxFPS).substr(0,5),
		// Std.string(avg).substr(0,5),
		// Std.string(count(flash.Lib.current)),
		// Std.string(Lambda.count(Haxegui.dirtyList)),
		// Std.string(flash.system.System.totalMemory/Math.pow(10,6)).substr(0,5),
		// DateTools.format(new Date(0,0,0,0,0,Std.int(haxe.Timer.stamp())), "%H:%M:%S"),
		// ""
		// ];

		// for(item in list2.getElementsByClass(ListItem))
		// item.label.tf.text = list2.data[list2.getChildIndex(cast item)];



		var item = cast list.getChildAt(2);
		item.redraw();
		item.graphics.beginFill (0xFF9300);
		item.graphics.drawRect (0, 0, Std.int(minFPS), 20);
		item.graphics.endFill ();

		item = cast list.getChildAt(4);
		item.redraw();
		item.graphics.beginFill (0x9ADF00);
		item.graphics.drawRect (0, 0, Std.int(avg), 20);
		item.graphics.endFill ();

		item = cast list.getChildAt(7);
		item.redraw();
		item.graphics.beginFill (0xFF00A8);
		item.graphics.drawRect (0, 0, Std.int(flash.system.System.totalMemory/Math.pow(10,6)), 20);
		item.graphics.endFill ();
		//}}}


		//{{{ Graph
		/**@todo whats with all the fibonaci? */
		data[data.length]   = [240-Std.int(ploter.x), 180 - Std.int(minFPS)];
		data2[data2.length] = [240-Std.int(ploter.x), 180 - Std.int(flash.system.System.totalMemory/Math.pow(10,6))];
		data3[data3.length] = [240-Std.int(ploter.x), 180 - Std.int(avg)];
		data4[data4.length] = [240-Std.int(ploter.x), 180 - Std.int(180*Lambda.count(Haxegui.dirtyList)/count(flash.Lib.current))];

		ploter.graphics.lineStyle(2,0xFF9300);
		ploter.graphics.moveTo( data[data.length-2][0]+gridSpacing, data[data.length-2][1] );
		ploter.graphics.lineTo( data[data.length-1][0]+gridSpacing, data[data.length-1][1] );

		ploter.graphics.lineStyle(2,0xFF00A8);
		ploter.graphics.moveTo( data2[data2.length-2][0]+gridSpacing, data2[data2.length-2][1] );
		ploter.graphics.lineTo( data2[data2.length-1][0]+gridSpacing, data2[data2.length-1][1] );

		ploter.graphics.lineStyle(2,0x9ADF00);
		ploter.graphics.moveTo( data3[data3.length-2][0]+gridSpacing, data3[data3.length-2][1] );
		ploter.graphics.lineTo( data3[data3.length-1][0]+gridSpacing, data3[data3.length-1][1] );

		ploter.graphics.lineStyle(2,0x3333ff);
		ploter.graphics.moveTo( data4[data4.length-2][0]+gridSpacing, data4[data4.length-2][1] );
		ploter.graphics.lineTo( data4[data4.length-1][0]+gridSpacing, data4[data4.length-1][1] );


		var p = new feffects.Tween(ploter.x, ploter.x-delta*gridSpacing, interval, ploter, "x", feffects.easing.Linear.easeNone );
		p.start();

		//}}}
		/*
		grid.x -= gridSpacing*delta;
		var g = new feffects.Tween(0, -gridSpacing, interval, grid, "x", feffects.easing.Linear.easeNone );
		//        var g = new feffects.Tween(0, -delta*gridSpacing, Std.int(delta*interval), grid, "x", feffects.easing.Linear.easeNone );
		g.start();
		*/
		//~ if(grid.x<-gridSpacing) grid.x=0;


		frameCounter = 0;
		last = haxe.Timer.stamp();

	}
	//}}}


	//{{{ onStatsEnterFrame
	private function onStatsEnterFrame(e:Event) {
		frameCounter++;
	}
	//}}}


	//{{{ count
	private function count(o:DisplayObjectContainer) : Int {
		if(o==null) return 0;
		var c = o.numChildren;
		for(i in 0...o.numChildren)
		if(!Std.is(o.getChildAt(i), flash.text.TextField) &&
		!Std.is(o.getChildAt(i), flash.display.Bitmap) &&
		!Std.is(o.getChildAt(i), flash.display.Shape) )
		c += count(cast o.getChildAt(i));
		return c;
	}
	//}}}


	//{{{ destroy
	public override function destroy() {
		timer.stop();
		removeEventListener(Event.ENTER_FRAME, onStatsEnterFrame);
		super.destroy();
	}
	//}}}
}
