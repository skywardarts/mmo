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
import haxegui.controls.Component;
import haxegui.controls.Image;
import haxegui.controls.Label;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.MouseManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}

/**
* Automation of events on components<br/>
*
*
*/
class Automator extends EventDispatcher
{

	public static var stage = flash.Lib.current.stage;


	//{{{ mouseToPoint
	public static function mouseToPoint(p:Point) : MouseEvent {
		return MouseManager.getInstance().moveToPoint(p);
	}
	//}}}


	//{{{ mouseClick
	public static function mouseClick(c:Component) {
		var p = CursorManager.getInstance().getPoint();
		c.dispatchEvent(new MouseEvent(MouseEvent.CLICK, false, true, p.x, p.y));
	}
	//}}}


	//{{{ mouseDown
	public static function mouseDown(c:Component) {
		var p = CursorManager.getInstance().getPoint();
		c.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, false, true, p.x, p.y));
	}
	//}}}


	//{{{ mouseUp
	public static function mouseUp(c:Component) {
		var p = CursorManager.getInstance().getPoint();
		c.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, false, true, p.x, p.y));
	}
	//}}}


	//{{{ actionClick
	public static function actionClick(c:Component) {
		return "Clicking "+c.name;
	}
	//}}}
}
