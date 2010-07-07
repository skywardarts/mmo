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
import aPath.Engine;
import aPath.Node;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxegui.Haxegui;
import haxegui.containers.Container;
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.events.MoveEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Size;
//}}}

using haxegui.utils.Color;


/**
* Patch cable to visually connect signals and slots.<br/>
*
*
*
*/
class Patch extends AbstractButton
{
	//{{{ Members
	/** **/
	public var container : Container;

	/** Signal emitting object **/
	public var source : Dynamic;

	/** Signal receiving object **/
	public var target : Dynamic;

	public var bitmap : Bitmap;

	/** the aPath engine **/
	public var engine : Engine;

	public var paths : Array<Array<Node>>;
	//}}}

	//{{{ Functions
	//{{{ init
	/** @see [Component.init] **/
	override public function init(?opts:Dynamic=null) {
		engine = new aPath.Engine();
		paths = [];

		super.init(opts);

		alpha = .5;
		color = Color.tint(Color.BLACK, .5);

		// this is turned back on onMouseUp
		mouseEnabled = false;

		// add the drop-shadow filters
		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5, 6, 6, 0.5, flash.filters.BitmapFilterQuality.LOW, false, false, false )];

		dirty = false;

	}
	//}}}


	//{{{ redraw
	public override function redraw(?opts:Dynamic=null) {
		if(paths==null || paths.length==0) return;
		var fix = new Point(Haxegui.gridSpacing, Haxegui.gridSpacing);

		this.graphics.clear();

		var path = paths[paths.length-1];
		var node = engine.startNode;

		this.graphics.lineStyle(0,0,0);
		this.graphics.beginFill(this.color);
		this.graphics.drawCircle(node.x*Haxegui.gridSpacing+fix.x, node.y*Haxegui.gridSpacing+fix.y, 5);
		var p = stage.localToGlobal(new Point(container.mouseX-source.slot.x, container.mouseY-source.slot.y));
		this.graphics.drawCircle(p.x, p.y, 5);
		this.graphics.endFill();
		node = path[path.length-1].parent.parent;
		this.graphics.lineStyle(4, this.color, 1);

		if(node==null) return;

		this.graphics.moveTo(p.x, p.y);
		this.graphics.lineTo( node.x*Haxegui.gridSpacing+fix.x, node.y*Haxegui.gridSpacing+fix.y);

		while(node.parent!=null) {
			this.graphics.moveTo( node.x*Haxegui.gridSpacing+fix.x, node.y*Haxegui.gridSpacing+fix.y);
			node = node.parent;
			this.graphics.lineTo( node.x*Haxegui.gridSpacing+fix.x, node.y*Haxegui.gridSpacing+fix.y);
		}
	}
	//}}}


	//{{{ setupMap
	public function setupMap(w:Int, h:Int, s:Int) {

		engine.generateMap(w,h);

		var o = null;
		var dt = haxe.Timer.stamp();
		for(i in 0...w)
		for(j in 0...h) {

			var samplePoints = [
			new flash.geom.Point((i*s)+s>>1, (j*s)+s>>1)
			//~ new flash.geom.Point( hs-1,-hs),
			//~ new flash.geom.Point(-hs+1, hs-1),
			//~ new flash.geom.Point( hs-1, hs-1)
			];

			for(k in samplePoints) {
				var o = container.getObjectsUnderPoint(new flash.geom.Point(k.x, k.y)).pop();
				if(o==null) continue;
				if(o!=container && (Std.is(o, Component) && !(cast o).disabled)) {

					// mark unwalkables
					/*
					container.graphics.beginFill(Color.CYAN, .5);
					container.graphics.drawRect(i*Haxegui.gridSpacing, j*Haxegui.gridSpacing,  Haxegui.gridSpacing,  Haxegui.gridSpacing);
					container.graphics.endFill();
					*/
					engine.map[i][j].close = true;
					//engine.map[i][j].type = Type.BREAK_NODE;

				}

			}
		}

		//~ trace('Mapping took: ~'+Std.string(haxe.Timer.stamp()-dt).substr(0,7)+'ms, Grid size: '+Lambda.count(engine.map)*Lambda.count(engine.map[0]));

	}
	//}}}


	//{{{ setStartPoint
	/** Starting point for pathfinding **/
	public function setStartPoint()  {
		var s = Size.fromRect(container.box);
		s.scale(1/Haxegui.gridSpacing, 1/Haxegui.gridSpacing);

		var ix = Std.int(source.x/Haxegui.gridSpacing);
		var iy = Std.int(source.y/Haxegui.gridSpacing);

		if(ix>s.width-2 || ix<0 || iy>s.height || iy<0) return;
		var node = engine.map[ix][iy];

		engine.setStartNode(node);
	}
	//}}}


	//{{{ setEndPoint
	public function setEndPoint(e:MouseEvent) {
		//~ if(e.target==null || e.target==source) return;

		var s = Size.fromRect(container.box);
		s.scale(1/Haxegui.gridSpacing, 1/Haxegui.gridSpacing);

		var mp = new Point(e.stageX, e.stageY);
		var o = stage.getObjectsUnderPoint(mp).pop();
		if(Std.is(o, Socket)) {
			color = Color.random();
			redraw();
			return;
		}

		var p = container.globalToLocal(mp);
		p.subtract(new Point(source.x, source.y));

		var ix = Std.int(p.x/Haxegui.gridSpacing);
		var iy = Std.int(p.y/Haxegui.gridSpacing);

		//if(ix>w-2 || ix<0 || iy>h || iy<0) return;
		ix = Std.int(Math.max(0, Math.min(s.width-2, ix)));
		iy = Std.int(Math.max(0, Math.min(s.height-2, iy)));


		var node = engine.map[ix][iy];
		if(node==null) return;

		if(engine.endNode==engine.map[ix][iy]) return;

		// set as endNode in the aPath engine
		engine.setEndNode(engine.map[ix][iy]);

		color = Color.BLACK.tint(.5);

		try {
			paths.push(engine.getPath());
		}
		catch(e:Dynamic) {
			if(!Std.is(o, haxegui.controls.IAdjustable) && !Std.is(o, haxegui.containers.IContainer)) {
				redraw();
				return;
			}
			setupMap(s.width, s.height, Haxegui.gridSpacing);
		}
		redraw();
		e.updateAfterEvent();
	}
	//}}}


	//{{{ onMouseUp
	override public function onMouseUp(e:MouseEvent) {

		if(!Std.is(e.target, Socket)) { destroy(); return; }


		//~ stopInterval();
		mouseEnabled = true;
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, setEndPoint);
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);

		var self = this;
		target = e.target.parent;

		trace(target);

		if(Std.is(self.target.getParentWindow(), haxegui.Node))
		target = e.target;


		var onSourceChange = function(e) {
			var ao = self.source.adjustment.object;
			if((Std.is(self.source, haxegui.toys.SevenSegment) || Std.is(self.source, haxegui.controls.Stepper))&& Std.is(self.target, haxegui.toys.Knob)) ao.value = -145 + ao.value*36;

			if(Std.is(self.target.getParentWindow(), haxegui.Node)) {
				var text = self.target.prevSibling().input.tf.text;
				text = Std.string(ao.value) ;

				try {
					var out = self.target.nextSibling();

					var parser = new hscript.Parser();
					var program = parser.parseString(text);
					var interp = new hscript.Interp();

					interp.variables.set( "x", ao.value );
					haxegui.utils.ScriptStandardLibrary.set(interp);

					text = interp.execute(program);
					if(text!=null)
					out.setText(text);
				}
				catch(e:Dynamic) {
					trace(e);
				}
				return;
			}

			self.target.adjustment.adjust(ao);
		}
		source.adjustment.addEventListener(Event.CHANGE, onSourceChange);

		super.onMouseUp(e);
	}
	//}}}


	//{{{ onMouseDoubleClick
	override public function onMouseDoubleClick(e:MouseEvent) : Void {
		flash.system.System.gc();
		this.destroy();
	}

	//}}}


	//{{{ destroy
	override public function destroy() {
		root.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, setEndPoint);
		root.stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
		super.destroy();
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Patch);
	}
	//}}}
	//}}}
}
