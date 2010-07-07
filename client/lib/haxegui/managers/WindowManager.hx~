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
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.Window;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
//}}}


/**
* Window Manager
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class WindowManager extends EventDispatcher
{
	//{{{ Members
	public var numWindows : UInt;
	public var windows : Hash<Window>;
	public var listeners:Array<haxegui.logging.ILogger>;

	public static var current : Window;

	private static var _instance : WindowManager = null;
	//}}}


	//{{{ getInstance
	public static function getInstance ():WindowManager {
		if (WindowManager._instance == null)
		{
			WindowManager._instance = new WindowManager ();
		}
		return WindowManager._instance;
	}
	//}}}


	//{{{ Constructor
	public function new () {
		super ();
		listeners = new Array();
		windows = new Hash();
		numWindows = 0;
	}
	//}}}


	//{{{ toString
	public override function toString () : String {
		return "WindowManager";
	}
	//}}}


	//{{{ addWindow
	public static function addWindow(?parent:Dynamic, ?name:String, ?x:Float, ?y:Float) {
		getInstance().numWindows++;

		if(parent==null)
		parent = flash.Lib.current;

		if(name==null)
		name = "Window" + Std.string(haxe.Timer.stamp()*1000).substr(0,2);

		if( getInstance().windows.exists( name ) )
		name += Std.string(haxe.Timer.stamp()*1000).substr(0,2);

		var window =  new Window(parent, name, x, y);

		//~ getInstance().windows.set(name, window);
		//~ WindowManager.getInstance().register(window);

		return window;
	}
	//}}}


	//{{{ toFront
	public static function toFront(wnd:Window) {
		if(wnd.parent == null) return;
		wnd.parent.addChild(wnd);
		current = wnd;
		if(flash.Lib.current.getChildByName("patchLayer")!=null)
		flash.Lib.current.setChildIndex(flash.Lib.current.getChildByName("patchLayer"), flash.Lib.current.numChildren-1);
	}
	//}}}


	//{{{ toBack
	public static function toBack(wnd:Window) {
		if(wnd.parent == null) return;
		wnd.parent.setChildIndex(wnd, 0);
	}
	//}}}


	//{{{ register
	public function register(w:Window) {
		w.addEventListener( ResizeEvent.RESIZE, this.proxy );
		w.addEventListener( MoveEvent.MOVE,  this.proxy );
		w.addEventListener( FocusEvent.FOCUS_IN,  this.proxy );
	}
	//}}}


	//{{{ proxy
	public function proxy(e:Dynamic) {
		//~ for(i in 0...listeners.length) {
		//~ var listener = listeners[i];
		//~ Reflect.callMethod(listener, listener.log, [e]);
		//~ }
		//~ trace(e);
		if(Std.is(e,FocusEvent)) {
			switch(e.type) {
				case FocusEvent.FOCUS_IN:
				var o = e.target;
				while(o!=null && !Std.is(o, Window))
				o = cast o.parent;
				if(o==null) return;
				//if(o.isModal()) return;
				toFront(cast o);
			}
		}
	}
	//}}}
}
