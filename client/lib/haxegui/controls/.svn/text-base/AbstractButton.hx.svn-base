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

package haxegui.controls;


//{{{ Imports
import flash.display.DisplayObjectContainer;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextFormat;
import haxegui.controls.Component;
import haxegui.controls.IRepeater;
import haxegui.events.MoveEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Opts;
//}}}


/**
*
* A chromeless button, containing default actions for mouse events.<br/>
*
* @version 0.1
* @author Omer Goshen Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*
*/
class AbstractButton extends Component, implements IRepeater {

	//{{{ Members
	/** Sets whether mouse events in buttons use hand cursors **/
	public static var useHandCursors(default,__setHandCursors) : Bool;
	/** The cursor to use when the mouse is over buttons **/
	public static var defaultCursorOver : Cursor;
	/** The cursor to use when a button is pressed **/
	public static var defaultCursorPress : Cursor;
	/** The cursor to use when the mouse is over this button **/
	public var cursorOver : Cursor;
	/** The cursor to use when this button is pressed **/
	public var cursorPress : Cursor;
	/** Whether the button will repeat actions when held, default false **/
	public var autoRepeat : Bool;
	/** number of [interval] actions per second on auto repeat **/
	public var repeatsPerSecond : Float;
	/** Seconds before auto repeat starts **/
	public var repeatWaitTime : Float;
	//}}}


	//{{{ Constructor
	/**
	* Sets the default button behaviour.
	* @param parent  object
	* @param name of new instance
	* @param x offset
	* @param y offset
	*/
	public function new (?parent:DisplayObjectContainer, ?name:String, ?x:Float, ?y:Float) {
		super (parent, name, x, y);
		buttonMode = true;
		cursorOver = defaultCursorOver;
		cursorPress = defaultCursorPress;
		focusRect = true;
		mouseChildren = true;
		mouseEnabled = true;
		tabEnabled = true;
		useHandCursors = true;
	}
	//}}}


	//{{{ __setHandCursors
	/** Setter for using hand cursors **/
	static function __setHandCursors(v:Bool) : Bool	{
		if(v == useHandCursors)
		return v;
		if(v) {
			defaultCursorOver = Cursor.HAND;
			defaultCursorPress = Cursor.HAND2;
		} else {
			defaultCursorOver = Cursor.ARROW;
			defaultCursorPress = Cursor.ARROW;
		}
		return v;
	}
	//}}}


	//{{{ init
	override public function init(?opts:Dynamic) {
		color = DefaultStyle.BACKGROUND;


		super.init(opts);


		autoRepeat = Opts.optBool(opts,"autoRepeat", true);
		repeatWaitTime = Opts.optFloat(opts,"repeatWaitTime", .75);
		repeatsPerSecond = Opts.optFloat(opts,"repeatsPerSecond", 25);
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(AbstractButton);
	}
	//}}}
}

