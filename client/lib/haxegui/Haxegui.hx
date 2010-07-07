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

//{{{ imports
import haxe.Timer;
import haxegui.controls.Component;
import haxegui.managers.CursorManager;
import haxegui.managers.MouseManager;
import haxegui.managers.StyleManager;
//}}}


//{{{ Haxegui
/**
* Haxegui main "bootloader"<br/>
* Call the static [init] function prior to any other haxegui code.
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class Haxegui {
	//{{{ members
	/** List of class to initialize **/
	private static var initializers : List<{c:Class<Dynamic>, f:Void->Void}>;

	/** the absolute root url **/
	public static var baseURL : String = "";

	/** List of dirty components **/
	public static var dirtyList : List<Component> = new List();

	/** Timer to watch dirty components **/
	public static var dirtyTimer : Timer;

	/** Timer interval **/
	public static var dirtyInterval( default, setInterval ) : Int;

	/** The xml loader **/
	public static var loader : haxe.xml.Fast =  new haxe.xml.Fast(Xml.parse(haxe.Resource.getString("Loader")).firstElement());

	/** Grid spacing in pixels **/
	public static var gridSpacing : Int = 15;

	/** Whether to snap to grid on move operations **/
	public static var gridSnapping : Bool = false;

	/** True to show slots on screen **/
	public static var slots : Bool = false;
	//}}}

	//{{{ init
	/**
	 * Initialize the haxegui system
	 * It calls the initializing function for all [Component]s in the the [initializers] list,
	 * starts the dirty timer, and sets up the mouse & cursor managers.
	 **/
	public static function init() {
		for(o in initializers) {
			#if debug
			trace("Initializing " + Type.getClassName(o.c));
			#end
			if(o.f != null)
				o.f();
		}

		// Setup mouse and cursor
		MouseManager.getInstance().init();
		CursorManager.getInstance().init();

		// load the default style
		trace("loading style");
		StyleManager.loadStyles(Xml.parse(haxe.Resource.getString("default_style")));
		StyleManager.setStyle("default");
		trace("complete");


		dirtyInterval = 300;
	}
	//}}}

	//{{{ setInterval
	public static function setInterval(v:Int) : Int {
		dirtyInterval = v;
		dirtyTimer = new haxe.Timer(dirtyInterval);
		dirtyTimer.run = onInterval;
		return dirtyInterval;
	}
	//}}}


	//{{{ onInterval
	/**
	* Redraws dirty components
	*/
	private static function onInterval() {
		if(dirtyList.isEmpty()) return;
		for(c in dirtyList) {
			if(c.dirty) {
				c.redraw({});
				c.dirty = false;
			}
			dirtyList.remove(c);
		}
	}
	//}}}

	//{{{ register
	/**
	* Component registration. Used during the boot process to register
	* all components.
	*
	* @param Component class
	* @param Initialization function called when Haxegui is initialized
	*/
	public static function register(c:Class<Dynamic>, f:Void->Void=null) : Void {
		if(initializers == null)
			initializers = new List();
		initializers.add({c:c, f:f});
	}
	//}}}

	//{{{ setDirty
	/**
	* Mark a component for redrawing
	*
	* @param c The dirty [Component]
	**/
	public static inline function setDirty(c : Component) : Void {
		dirtyList.add(c);
	}
	//}}}

	//{{{ toggleSnapping
	/** Toggle [gridSnapping] on and off. **/
	public static function toggleSnapping() : Bool {
		return gridSnapping = !gridSnapping;
	}
	//}}}

}
//}}}
