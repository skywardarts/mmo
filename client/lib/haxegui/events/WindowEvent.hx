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

package haxegui.events;

class WindowEvent extends flash.events.Event {
	//{{{ members
	/** Last known X position of window **/
	public var oldX : Float;
	/** Last known Y position of window **/
	public var oldY : Float;
	/** Fired when the minimize button is clicked, cancelable **/
	public static inline var MINIMIZE : String = "minimize";
	/** Fired when the window is minimized **/
	public static inline var MINIMIZED : String = "minimized";
	/** Fired when the window close button is clicked, cancelable **/
	public static inline var CLOSE : String = "close";
	/** Fired when the window is closed **/
	public static inline var DESTROYED : String = "destroyed";
	/** Fired when the window is rolled **/
	public static inline var ROLLED : String = "rooled";
	///}}}

	public function new(type : String, ?bubbles : Bool, ?cancelable : Bool, ?oldX : Float, ?oldY : Float) : Void {
		super(type, bubbles, cancelable);
	}

	public override function toString():String {
		return "["+"WindowEvent"+" type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" oldX="+oldX+" oldY="+oldY+"]";
	}
}
