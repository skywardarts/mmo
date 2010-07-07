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

package haxegui.managers;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.events.FocusEvent;
import flash.geom.Rectangle;

import haxegui.events.MoveEvent;
import haxegui.events.DragEvent;
import haxegui.events.ResizeEvent;

class DragManager extends EventDispatcher
{
	private static var _instance : DragManager = null;
	public var listeners:Array<haxegui.logging.ILogger>;

	public static function getInstance ():DragManager
	{
		if (DragManager._instance == null)
		{
			DragManager._instance = new DragManager ();
		}
		return DragManager._instance;
	}


	public function new() {
		super ();
	}

	public override function toString () : String {
		return "DragManager";
	}


	public function onStartDrag(e:DragEvent) {
		//~ trace(e);
		//~ e.stopImmediatePropagation();

		e.target.startDrag();
	}

	public function onStopDrag(e:DragEvent) {
		//~ trace(e);
		//~ e.stopImmediatePropagation();

		e.target.stopDrag();
		//~ flash.Lib.current.removeEventListener(MouseEvent.MOUSE_MOVE, e.target, e.target.onMouseMove);
		//~ e.target.removeEventListener(MouseEvent.MOUSE_MOVE, e.target, e.target.onMouseMove);
	}

}
