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

import flash.events.EventDispatcher;
import flash.events.Event;

/**
*
* Binding<br/>
*
* @author <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.2
*/
class Binding extends EventDispatcher {

	//{{{ Members
	/** The static binding id counter **/
	private static var nextId : Int = 0;

	public var data( default, default ): Dynamic;

	public var id : Int;
	public var name : String;
	//}}}


	//{{{ Constructor
	public function new(?name:String) {
		super();
		this.id = Binding.nextId++;

		if(name!=null)
			this.name = name;
		else
			this.name = Type.getClassName(Type.getClass(this)).split(".").pop() + id;
	}
	//}}}


	//{{{ toString
	override public function toString() : String {
		return this.name + "[" + Type.getClassName(Type.getClass(this)) + "]";
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Binding);
	}
	//}}]
}
