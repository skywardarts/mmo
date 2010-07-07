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

import flash.events.Event;


class TreeEvent extends Event {

	public function new(type : String, ?bubbles : Bool, ?cancelable : Bool) : Void {
		super(type, bubbles, cancelable);
	}

	public override function toString():String {
		return "["+"TreeEvent"+" type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+"]";
	}

	override public function clone():Event {
		return new TreeEvent(this.type, this.bubbles, this.cancelable);
	}

	// public var relatedObject : flash.display.InteractiveObject;

	public static var ITEM_CLOSE 	: String = "item_close";
	public static var ITEM_OPEN 	: String = "item_open";
	public static var ITEM_OPENING : String = "item_openning";
	public static var ITEM_CLOSING : String = "item_closing";
}
