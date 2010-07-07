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

import haxegui.controls.Component;
import haxegui.controls.UiList;

class DataEvent extends Event {

	public function new(type : String,
	?bubbles 	: Bool,
	?cancelable : Bool,
	?startIndex	: Int,
	?endIndex	: Int
	//,?range		: IntIter
	) : Void {
		super(type,bubbles,cancelable);
		this.startIndex = startIndex;
		this.endIndex = endIndex;
		this.range = new IntIter(startIndex, endIndex);
	}


	public override function toString():String {
		return "["+"DataEvent"+" type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" startIndex="+startIndex+" endIndex="+endIndex+"]";
	}


	override public function clone():Event {
		return new DataEvent(this.type, this.bubbles, this.cancelable, this.startIndex, this.endIndex);
	}

	public var startIndex	: Int;
	public var endIndex		: Int;
	public var range 		: IntIter;

	// public static var ITEM_ADDED	 : String = "itemAdded";
	public static var CHANGE	 	 : String = "change";
}
