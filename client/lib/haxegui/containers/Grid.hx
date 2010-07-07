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

package haxegui.containers;

//{{{ Imports
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.containers.IContainer;
import haxegui.controls.Component;
import haxegui.controls.ScrollBar;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.MouseManager;
import haxegui.managers.ScriptManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Size;
import haxegui.utils.Opts;
//}}}


using haxegui.controls.Component;


/**
* Grid container.<br/>
*/
class Grid extends Component, implements IContainer {

	public var rows(default, setRows) : Int;
	public var cols(default, setCols) : Int;
	public var fit : Bool;

	public var cellSpacing : Float;
	public var cellPadding : Float;


	//{{{ Constructor
	public function new (?parent : flash.display.DisplayObjectContainer, ?name:String, ?x : Float, ?y: Float) {
		super (parent, name, x, y);
		this.color = DefaultStyle.BACKGROUND;
		this.buttonMode = false;
		// this.mouseEnabled = false;
	}
	//}}}


	//{{{ Functions
	//{{{ addChild
	/**
	* Adds children to the grid, arranging in them in cells.
	* @todo cleanup
	*/
	public override function addChild(o : DisplayObject) : DisplayObject {
		var o = super.addChild(o).asComponent();
		var self = this;

		var i = (self.getChildIndex(o)) % self.cols;
		var j = Std.int(self.getChildIndex(o)/self.cols);

		// o.moveTo(i*self.box.width/self.cols, j*self.box.height/self.rows);
		o.place(i*self.box.width/self.cols, j*self.box.height/self.rows);

		// if(Std.is(o, Component))
		addEventListener(ResizeEvent.RESIZE,
		function(e) {
			if(!self.contains(o)) return;

			if(Std.is(o, haxegui.controls.Label))
			o.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));

			if(self.fit) {
				var s = Size.fromRect(self.box);
				s.scale(1/self.cols, 1/self.rows);
				if(Std.is(self, HBox))
				s.height = Std.int(self.box.height);


				o.asComponent().box = s.toRect();
				o.asComponent().onResize(e);
				// o.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
			}
			var i = (self.getChildIndex(o)) % self.cols;
			var j = Std.int(self.getChildIndex(o)/self.cols);

			//o.asComponent().moveTo(i*(self.box.width/self.cols+self.cellSpacing), j*(self.box.height/self.rows+self.cellSpacing));
			o.place(i*(self.box.width/self.cols+self.cellSpacing), j*(self.box.height/self.rows+self.cellSpacing));
			// o.x = i*(self.box.width/self.cols+self.cellSpacing);
			// o.y = j*(self.box.height/self.rows+self.cellSpacing);

			o.dispatchEvent(new MoveEvent(MoveEvent.MOVE));
		});

		return o;
	}
	//}}}

	// public override function removeChild(o:DisplayObject) : DisplayObject{
	// 	cols--;
	// 	return super.removeChild(o);
	// }


	//{{{ init
	override public function init(opts : Dynamic=null) {
		box = new Size(200,200).toRect();
		rows = 2;
		cols = 2;
		fit = true;
		cellPadding = 0;
		cellSpacing = 8;

		super.init(opts);


		rows = Opts.optInt(opts, "rows", rows);
		cols = Opts.optInt(opts, "cols", cols);
		cellSpacing = Opts.optFloat(opts, "cellSpacing", cellSpacing);
		fitH = Opts.optBool(opts,"fitH", true);
		fitV = Opts.optBool(opts,"fitV", true);


		description = null;


		if(Std.is(parent, haxegui.Window))
		if(x==0 && y==0)
		move(10,20);
/*
		setAction("redraw", "this.graphics.clear();
		this.graphics.lineStyle(2, Color.RED);
		this.graphics.drawRect(0, 0, this.box.width, this.box.height);

		this.graphics.lineStyle(2, Color.GREEN);
		for(i in 1...this.rows) {
			this.graphics.moveTo(0, i*(this.box.height/this.rows+this.cellSpacing));
			this.graphics.lineTo(this.box.width, i*(this.box.height/this.rows+this.cellSpacing));
		}

		this.graphics.lineStyle(2, Color.BLUE);
		for(i in 1...this.cols) {
			this.graphics.moveTo(i*(this.box.width/this.cols+this.cellSpacing), 0);
			this.graphics.lineTo(i*(this.box.width/this.cols+this.cellSpacing), this.box.height);
		}
		");
*/
		parent.addEventListener(ResizeEvent.RESIZE, onParentResize);
		parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ onParentResize
	private function onParentResize(e:ResizeEvent) {
		var size = new Size();

		if(Std.is(parent, Component))
		size = new Size((cast parent).box.width - x, (cast parent).box.height - y);
		else
		size = new Size(parent.width, parent.height);

		size.subtract(new Size((cols-1)*cellSpacing, (rows-1)*cellSpacing));
		size.setAtLeastZero();

		box = size.toRect();

		// if(fitH) box.width = (cast parent).box.width - x;
		// if(fitV) box.height = (cast parent).box.height - y;

		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ onResize
	public override function onResize(e:ResizeEvent) {
		for(i in this)
		i.asComponent().dirty = true;

		dirty = true;

		super.onResize(e);
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Container);
	}
	//}}}
	//}}}

	//{{{ Setters
	public function setRows(n:Int) : Int {
		rows = n;
		return rows;
	}

	public function setCols(n:Int) : Int {
		cols = n;
		return cols;
	}
	//}}}
}


//{{{ HBox
/**
* A Special kind of grid that has only 1 row.<br/>
* When adding children to the HBox, its column count automatically increments.
*/
class HBox extends Grid {

	override public function init(opts:Dynamic=null) {
		super.init(opts);

		rows = 1;
		cols = 0;
		fit = Opts.optBool(opts, "fit", false);

		parent.removeEventListener(ResizeEvent.RESIZE, onParentResize);
	}


	//{{{ onParentResize
	// override function onParentResize(e:ResizeEvent) {}
	private override function onParentResize(e:ResizeEvent) {
		// trace(e);

		if(fitH) box.width = (cast parent).box.width - x;
		if(fitV) box.height = (cast parent).box.height - y;


		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}

	//{{{ onResize
	public override function onResize(e:ResizeEvent) {
		for(i in this)
		i.asComponent().dirty = true;

		dirty = true;

		super.onResize(e);
	}
	//}}}


	override public function addChild(o:DisplayObject) {
		var o = super.addChild(o);
		cols++;
		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
		return o;
	}


	public override function setRows(n:Int) : Int {
		return 1;
	}
}
//}}}
