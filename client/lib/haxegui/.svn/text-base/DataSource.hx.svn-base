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
import flash.events.EventDispatcher;
import flash.events.Event;
import haxegui.events.DataEvent;
//}}}


//{{{ DataDescriptor
typedef DataDescriptor = {
	var hasRoot  : Bool;
	var isSorted : Bool;
	var isEmpty  : Bool;
}
//}}}


/**
* DataSource class
*
*
* @author <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.2
*/
class DataSource extends EventDispatcher {

	//{{{ Members
	/** The static datasource id counter **/
	private static var nextId : Int = 0;

	/** The real data holder, [List], [Array] or [Xml] **/
	public var data( default, __setData ): Dynamic;

	/** Descriptor **/
	public var descriptor : DataDescriptor;

	public var id(default, null) : Int;

	public var name : String;
	//}}}


	//{{{ Constructor
	public function new(?name:String=null) {
		super();
		this.id = DataSource.nextId++;

		if(name!=null)
		this.name = name;
		else
		this.name = Type.getClassName(Type.getClass(this)).split(".").pop() + id;

		dispatchEvent(new DataEvent(DataEvent.CHANGE));
	}
	//}}}

	// public function init(?opts:Dynamic=null) {
	// 	if(data==null) data=[];
	// 	for(i in 0...10)
	// 	data.push(i);
	// dispatchEvent(new Event(Event.CHANGE));
	// }


	//{{{ Functions
	//{{{ toString
	override public function toString() : String {
		return name + "[" + Type.getClassName(Type.getClass(this)) + "]";
	}
	//}}}


	//{{{ __setData
	public function __setData(v:Dynamic) {
		data = v;

		var l = data.length;

		dispatchEvent(new DataEvent(DataEvent.CHANGE, false, true, 0, l));
	}
	//}}}

	//{{{ addItem
	public function addItem(i:Dynamic) {
		var e = new DataEvent(DataEvent.CHANGE, false, true);
		var j = 0;

		if(Std.is(data, Array))
		j = data.push(i);
		else
		if(Std.is(data, List)) {
			data.add(i);
			j = data.length;
		}
		else
		if(Std.is(data, Xml))
		{}

		e.startIndex = e.endIndex = j;

		// if(descriptor.isEmpty) descriptor.isEmpty = false;

		dispatchEvent(e);
	}
	//}}}

	//{{{ addItemAt
	public function addItemAt(i:Dynamic, p:Int) {
		if(Std.is(data, Array))
		data.insert(p, i);
		else
		if(Std.is(data, List)) {
		}
		else
		if(Std.is(data, Xml))
		{}
	}
	//}}}


	//{{{
	public function removeItemAt(i:Dynamic) {}
	//}}}


	//{{{ removeAll
	public function removeAll() {
		if(Std.is(data, Array))
		data = new Array<Dynamic>();
		else
		if(Std.is(data, List))
		data.clear();
		else
		if(Std.is(data, Xml))
		{}

		descriptor.isEmpty = true;
		// dispatchEvent(new DataEvent(DataEvent.CHANGE, false, true, 0, 0));
	}
	//}}}

	//{{{ transform
	public function transform(f:Dynamic->Dynamic) : Dynamic {
		Lambda.foreach(data, f);

		dispatchEvent(new DataEvent(DataEvent.CHANGE, false, true));

		return data;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(DataSource);
	}
	//}}}
	//}}}
}
