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

import haxegui.controls.Component;

class DragEvent extends flash.events.MouseEvent {

	public function new(
	type 		: String,
	?bubbles 	: Bool,
	?cancelable : Bool,
	// ?dragInitiator : Component, ?dragSource : mx.core.DragSource, ?action : String,
	?ctrlKey	: Bool,
	?altKey 	: Bool,
	?shiftKey	: Bool) : Void {
		super(type, bubbles, cancelable, 0, 0, null, ctrlKey, altKey, shiftKey);
	}

	var action : String;
	var dragInitiator : Component;
	//var dragSource : mx.core.DragSource;
	var draggedItem : Dynamic;
	public static inline var DRAG_COMPLETE  : String = "stopDrag";
	public static inline var DRAG_OVER 		: String = "dragOver";
	public static inline var DRAG_START 	: String = "startDrag";
	public static var DRAG_DROP : String;
	public static var DRAG_ENTER : String;
	public static var DRAG_EXIT : String;
}
