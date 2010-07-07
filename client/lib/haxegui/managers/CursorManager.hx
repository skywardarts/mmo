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

//{{{ Imports
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;
import flash.ui.Mouse;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
//}}}

//{{{ Cursor
enum Cursor {
	ARROW;
	CROSSHAIR;
	DRAG;
	HAND2;
	HAND;
	IBEAM;
	NESW;
	NS;
	NWSE;
	SIZE_ALL;
	WE;
}
//}}}


//{{{ CursorManager
/**
*
* Cursor Manager Class (Singleton)
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class CursorManager extends EventDispatcher {
	//{{{ Members
	//{{{ Static
	/** Singelton **/
	private static var _instance : CursorManager = null;
	/** The default arrow cursor image **/
	public inline static var img_arrow = flash.Lib.attach("Arrow");
	/** The hand type cursor image **/
	public inline static var img_hand = flash.Lib.attach("Hand");
	/** The hand press/grab image **/
	public inline static var img_hand2 = flash.Lib.attach("Hand2");
	/** The drag cursor image **/
	public inline static var img_drag = flash.Lib.attach("Drag");
	/** The All Direction resizer image **/
	public inline static var img_sizeall = flash.Lib.attach("SizeAll");
	/** The   resizer image **/
	public inline static var img_nesw = flash.Lib.attach("SizeNESW");
	/** The   resizer image **/
	public inline static var img_ns = flash.Lib.attach("SizeNS");
	/** The   resizer image **/
	public inline static var img_nwse = flash.Lib.attach("SizeNWSE");
	/** The   resizer image **/
	public inline static var img_we = flash.Lib.attach("SizeWE");
	/** The crosshair cursor image **/
	public inline static var img_crosshair = flash.Lib.attach("Crosshair");
	//}}}

	//{{{ Public
	public var listeners:Array<haxegui.logging.ILogger>;
	public var cursor(default,__setCursor) : Cursor;
	public var visible(__getVisible,__setVisible) : Bool;
	public var _mc(default,null) : MovieClip;
	public var lock : Bool;
	//}}}
	//}}}


	//{{{ Constructor
	/** Singleton private constructor **/
	private function new ()	{
		super ();
	}
	//}}}


	//{{{ Functions


	//{{{ Public
	//{{{ getInstance
	/** Singleton access **/
	public static function getInstance ():CursorManager	{
		if (CursorManager._instance == null) {
			CursorManager._instance = new CursorManager ();
		}
		return CursorManager._instance;
	}
	//}}}


	//{{{ toString
	public override function toString () : String {
		return "CursorManager";
	}
	//}}}


	//{{{ init
	public function init() {
		//Mouse.hide();
		cursor = Cursor.ARROW;
	}
	//}}}


	//{{{ setCursor
	public static function setCursor(c:Cursor) : Void {
		if(getInstance().lock) return;
		getInstance().cursor = c;
	}
	//}}}


	//{{{ getCursor
	private inline function getCursor() : MovieClip	{
		return _mc;
	}
	//}}}


	//{{{ inject
	public inline function inject(e:MouseEvent) {
		_mc.x = e.stageX;
		_mc.y = e.stageY;


		// showCursor();
		hideCursor();
		toTop();


		e.updateAfterEvent();
	}
	//}}}


	//{{{ getPoint
	public inline function getPoint() : Point {
		return new Point(_mc.x, _mc.y);
	}
	//}}}


	//{{{ toTop

	public inline function toTop() : Void {
		flash.Lib.current.setChildIndex(_mc, flash.Lib.current.numChildren - 1 );
	}//toTop
	//}}}


	//{{{ hideCursor
	public inline function hideCursor() : Void	{
		_mc.visible = false;
	}
	//}}}


	//{{{ showCursor
	public inline function showCursor() : Void	{
		_mc.visible = true;
	}
	//}}}
	//}}}


	//{{{ Private
	private function __getVisible() : Bool {
		return  _mc.visible;
	}


	//{{{ __setCursor
	/**
	*
	*/
	private function __setCursor(c:Cursor) : Cursor	{
		cursor = c;


		var v = false;
		if(_mc!=null) {
			v = _mc.visible;
			flash.Lib.current.removeChild(_mc);
		}

		switch(c) {
			case Cursor.ARROW:
			_mc = img_arrow;

			case Cursor.HAND:
			_mc = img_hand;

			case Cursor.HAND2:
			_mc = img_hand2;

			case Cursor.DRAG:
			_mc = img_drag;

			case Cursor.SIZE_ALL:
			_mc = img_sizeall;

			case Cursor.NESW:
			_mc = img_nesw;

			case Cursor.NS:
			_mc = img_ns;

			case Cursor.NWSE:
			_mc = img_nwse;

			case Cursor.WE:
			_mc = img_we;

			case Cursor.CROSSHAIR:
			_mc = img_crosshair;
		}

		_mc.name = "Cursor";
		_mc.mouseEnabled = false;
		_mc.focusRect = false;
		_mc.tabEnabled = false;

		_mc.width = _mc.height = 32;

		_mc.visible = v;

		var toColor = new flash.geom.ColorTransform(.8, 1, .9, 1, 0, 0, 0, 1);
		var t = new flash.geom.Transform(_mc);
		t.colorTransform = toColor;

		flash.Lib.current.addChild(_mc);


		return c;
	}
	//}}}


	//{{{ __setVisible
	private function __setVisible(v:Bool) : Bool {
		_mc.visible = v;
		return v;
	}
	//}}}
	//}}}
}
//}}}

