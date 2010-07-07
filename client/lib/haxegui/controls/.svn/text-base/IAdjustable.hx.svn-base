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

///{{{ Imports
import flash.events.Event;
import flash.events.EventDispatcher;
import haxegui.events.AdjustmentEvent;
//}}}


//{{{ AdjustmentObject
/**
* A typed object to hold a value, its mininum and maximum, and the default increasement sizes.
*/
typedef AdjustmentObject<Dynamic> = {
	var value : Null<Dynamic>;
	var min   : Null<Dynamic>;
	var max   : Null<Dynamic>;
	var step  : Null<Dynamic>;
	var page  : Null<Dynamic>;
}
//}}}


//{{{ Adjustment
/**
* Adjustment class allows reuse \ sharing of values for "range widgets".<br/>
* It clamps to min&max, and dispatches an event when one of the values has changed.
*
* Notice when using hscript use must use the getters and setters:
* <pre class="code xml">
* <haxegui:controls:Slider value="0">
* <events>
* 	<script type="text/hscript" action="onLoaded">
* 		this.adjustment.setValue(50);
* 	</script>
* </events>
* </haxegui:controls:Slider>
* </pre>
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.2
*/
class Adjustment extends EventDispatcher {

	public var object(default, adjust) : AdjustmentObject<Dynamic>;

	//{{{ constructor
	public function new(?a:AdjustmentObject<Dynamic>) {
		super();

		object = newAdjustmentObject(null);

		if(a!=null)
		object = a;
	}
	//}}}

	//{{{ adjust
	public function adjust(?a:AdjustmentObject<Dynamic>) : AdjustmentObject<Dynamic> {
		object = a;

		object.value = Math.min( object.value, object.max );
		object.value = Math.max( object.value, object.min );

		dispatchEvent(new Event(Event.CHANGE));
		return object;
	}
	//}}}


	//{{{ setValue
	public function setValue(v:Float) : Float {
		object.value = v;
		adjust(object);
		return v;
	}
	//}}}


	//{{{ getValue
	public function getValue() : Float {return object.value;
		return object.value;
	}
	//}}}


	//{{{ getStep
	public function getStep() : Float {return object.step;
		return object.step;
	}
	//}}}


	//{{{ valueAsString
	public function valueAsString() : String {return Std.string(getValue());
		return Std.string(getValue());
	}
	//}}}


	//{{{ newAdjustmentObject
	public static function newAdjustmentObject(type:Class<Dynamic>) : AdjustmentObject<Dynamic> {
		return { value:type, min:type, max:type, step:type, page:type};
	}
	//}}}
}
//}}}


//{{{ IAdjustable
/**
* Interface for adjustable widgets.
*
*/
interface IAdjustable {
	public var adjustment : Adjustment;
}
//}}}

