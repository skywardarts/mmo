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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxegui.Window;
import haxegui.containers.Container;
import haxegui.containers.Grid;
import haxegui.controls.ComboBox;
import haxegui.controls.Component;
import haxegui.controls.IAdjustable;
import haxegui.controls.Input;
import haxegui.controls.Label;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.toys.Patch;
import haxegui.toys.Socket;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


using haxegui.utils.Color;
using haxegui.controls.Component;


/**
* Signal\Slot Node.<br/>
*
* @todo fix the static [DataSource]
*
* @author <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class Node extends Window {

	//{{{ Members
	public var combos : Array<ComboBox>;
	public var inputs : Array<Input>;
	public var sockets : Array<Socket>;
	public var adjustments : Array<Adjustment>;

	var container : Container;
	var grid	  : Grid;

	var _current : Dynamic ;

	var holders : Array<Component>;


	static var dataSource = new DataSource("Node Data Source");
	//}}}


	//{{{ Functions
	//{{{ init
	public override function init(opts:Dynamic=null) {
		super.init(opts);

		color = Color.random().tint(.5);
		box = new Size(240,80).toRect();

		dataSource.data = ["Expression", "AND", "OR", "XOR", "NOR", "NAND", "XNOR"];


		// moveTo(.5*(this.stage.stageWidth-box.width), .5*(this.stage.stageHeight-box.height));


		//{{{ Container
		container = new Container(this, 10, 21);
		container.init({color: Color.WHITE});
		container.setAction("redraw", "");
		container.graphics.clear();


		grid = new Grid(container);
		grid.init({color: Color.WHITE});


		combos = [];
		inputs = [];
		sockets = [];
		holders = [];
		adjustments = [];

		for(i in 0...2) {
			adjustments.push(new Adjustment({ value: 0, min: Math.NEGATIVE_INFINITY, max: Math.POSITIVE_INFINITY, step: 5, page: 10}));


			var j = combos.push(new ComboBox(grid));
			combos[j-1].init({color: this.color, text: "", width: 90});
			// combos[j-1].dataSource = new DataSource();
			// combos[j-1].dataSource.data = ["Expression", "AND", "OR", "XOR", "NOR", "NAND", "XNOR"];
			combos[j-1].dataSource = dataSource;


			var j = inputs.push(new Input(grid));
			inputs[j-1].init({text: "", width: 90});
			inputs[j-1].tf.multiline = false;
			inputs[j-1].tf.autoSize = flash.text.TextFieldAutoSize.NONE;
			inputs[j-1].tf.width = 80;


			j = sockets.push(new Socket(inputs[j-1]));
			sockets[j-1].init({x: 100, y: 10});

			sockets[i].removeEventListener(MouseEvent.MOUSE_DOWN, sockets[i].onMouseDown);
			sockets[j-1].removeEventListener(MouseEvent.MOUSE_DOWN, sockets[i].onMouseDown);
		}
		//}}}

/*
		//{{{ titlebar
		titlebar.color = this.color;
		titlebar.dirty = true;
		titlebar.minimizeButton.destroy();
		titlebar.maximizeButton.destroy();
		titlebar.closeButton.destroy();
		titlebar.setAction("redraw",
		"
		this.graphics.clear();
		var grad = flash.display.GradientType.LINEAR;
		var colors = [ Color.tint(this.color, .85), this.color ];
		var alphas = [ 1, 1 ];
		var ratios = [ 0, 0xFF ];
		var matrix = new flash.geom.Matrix();
		matrix.createGradientBox(this.parent.box.width, 20, .5*Math.PI, 0, 0);
		this.graphics.lineStyle(1, Color.darken(this.color, 50), 1, true, flash.display.LineScaleMode.NONE);
		this.graphics.beginGradientFill( grad, colors, alphas, ratios, matrix );
		this.graphics.drawRoundRectComplex (2, 0, this.parent.box.width + 8, 20, 0, 20, 0, 0);
		this.graphics.endFill ();
		");
		//}}}


		//{{{ frame
		frame.removeEventListener(MouseEvent.MOUSE_MOVE, frame.onMouseMove);
		frame.color = this.color;
		frame.setAction("redraw",
		"
		this.graphics.clear ();

		this.graphics.lineStyle (1,
		Color.darken(this.color, 50),1, true,
		flash.display.LineScaleMode.NONE,
		flash.display.CapsStyle.NONE,
		flash.display.JointStyle.ROUND);

		this.graphics.beginFill (Color.WHITE);
		this.graphics.drawRoundRectComplex (2, 20, this.parent.box.width + 8, this.parent.box.height - 12, 0, 0, 20, 0);
		this.graphics.endFill ();

		this.graphics.beginFill (Color.tint(this.color, .5));
		this.graphics.moveTo(this.parent.box.width+10, this.parent.box.height-10);
		this.graphics.lineTo(this.parent.box.width+10, this.parent.box.height+8);
		this.graphics.lineTo(this.parent.box.width-10, this.parent.box.height+8);
		this.graphics.lineTo(this.parent.box.width+10, this.parent.box.height-10);
		this.graphics.endFill ();
		");
		//}}}
*/

	}
	//}}}


	//{{{ onMouseMove
	public function onMouseMove(e:MouseEvent) {
		var patchLayer = cast flash.Lib.current.getChildByName('patchLayer');
		patchLayer.getChildAt(patchLayer.numChildren-1).end = new Point(e.stageX, e.stageY);
		patchLayer.getChildAt(patchLayer.numChildren-1).redraw();
	}
	//}}}


	//{{{ onMouseUp
	public override function onMouseUp(e:MouseEvent) {
		if(_current==null) return;

		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);


		var oa = stage.getObjectsUnderPoint(new Point(e.stageX, e.stageY));
		oa.reverse();


		var c = false;
		var self = this;


		for(o in oa)
		if(Std.is(o, Socket)) {
			var p = cast(o.parent, IAdjustable);
			if(Std.is(p, IAdjustable)) {
				trace(_current+"\t"+p);
				_current.addEventListener(Event.CHANGE, function(e) {
					var ao = p.adjustment;
					ao.setValue(Std.parseFloat(self._current.tf.text));
				}, false, 0, false);
				//~ }, false, 0, true);
				c = true;
			}
			else
			if(Std.is((cast o).getParentWindow(), Node)) {
				_current.addEventListener(Event.CHANGE, function(e) {
					var i = (cast o).prevSibling();
					//i.tf.text = self._current.tf.text;
				}, false, 0, false);
			}
		}

		super.onMouseUp(e);
	}
	//}}}


	//{{{ onMouseDown
	public override function onMouseDown(e:MouseEvent) {
		if(Std.is(e.target, Socket)) {
			e.preventDefault();
			var patchLayer = cast flash.Lib.current.getChildByName('patchLayer');
			var patch = new haxegui.toys.Curvy(patchLayer);
			patch.init({thickness: 9, color: Color.random()});
			patch.start = new Point(e.stageX, e.stageY);
			patch.setAction("mouseDoubleClick", "this.destroy();");

			_current = e.target.prevSibling();

			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			return;
		}

		super.onMouseDown(e);
	}
	//}}}


	//{{{ destroy
	public override function destroy() {
		super.destroy();
	}
	//}}}
	//}}}
}
