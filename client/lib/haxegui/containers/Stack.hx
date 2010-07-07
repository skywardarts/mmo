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


//{{{ Import
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.containers.IContainer;
import haxegui.controls.Component;
import haxegui.events.ResizeEvent;
import haxegui.managers.MouseManager;
import haxegui.managers.ScriptManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


/**
* Stack container for layering components.<br/>
* Used in combination with  a [TabNavigator] for example.
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
**/
class Stack extends Component, implements IContainer {

	public var selectedIndex : Int;

	//{{{ Constructor
	public function new (?parent : flash.display.DisplayObjectContainer, ?name:String, ?x : Float, ?y: Float) {
		super (parent, name, x, y);

		color = DefaultStyle.BACKGROUND;
		buttonMode = false;
		mouseEnabled = false;
		tabEnabled = false;
	}
	//}}}


	//{{{ init
	override public function init(?opts:Dynamic=null) {
		super.init(opts);

		description = null;

		selectedIndex = Opts.optInt(opts, "selectedIndex", 0);

		if(Std.is(parent, haxegui.Window))
			if(x==0 && y==0)
				move(10,20);

		parent.addEventListener(ResizeEvent.RESIZE, onParentResize);
		parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ onParentResize
	/** @todo check stack resizing **/
	public function onParentResize(e:ResizeEvent) {
		// dirty = true;

		for(i in this) {
			if(Std.is(i, Component)) {
				if(!Math.isNaN((cast i).left)) {
				i.x = (cast i).left;
				}
				else
				if(!Math.isNaN((cast i).right)) {
				i.x = box.width - (cast i).box.width - (cast i).right;
				}

				if(!Math.isNaN((cast i).left) && !Math.isNaN((cast i).right)) {
				i.x = (cast i).left;
				(cast i).box.width = box.width - (cast i).right - i.x;
				(cast i).dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
				}


				if(!Math.isNaN((cast i).top)) {
				i.y = (cast i).top;
				}
				else
				if(!Math.isNaN((cast i).bottom)) {
				i.y = box.height - (cast i).box.height - (cast i).bottom;
				}

				if(!Math.isNaN((cast i).top) && !Math.isNaN((cast i).bottom)) {
				i.y = (cast i).top;
				(cast i).box.height = box.height - (cast i).bottom - i.y;
				(cast i).dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
				}
			}
		}

		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Stack);
	}
	//}}}
}
