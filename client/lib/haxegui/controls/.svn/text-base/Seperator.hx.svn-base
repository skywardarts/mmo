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


//{{{ Seperator
/**
 * Draggable seperator<br/>
 */
class Seperator extends Component, implements IAggregate {

	//{{{ init
	override public function init(opts:Dynamic=null) {
		super.init(opts);

		// setAction("mouseDown", "this.startDrag(false, new flash.geom.Rectangle(0, 0, parent.box.width, 0));");
		// setAction("mouseUp", "this.stopDrag();");
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Seperator);

	}
	//}}}
}
//}}}


//{{{ ToolBarSeperator
class ToolBarSeperator extends Seperator {
	//{{{ init
	override public function init(opts:Dynamic=null) {
		super.init(opts);

		box.height = (cast parent).box.height-4;
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(ToolBarSeperator);

	}
	//}}}
}
//}}}


//{{{ MenuSeperator
class MenuSeperator extends Seperator {

	//{{{ init
	override public function init(opts:Dynamic=null) {
		super.init(opts);

		box.width = (cast parent).box.width;
		
		this.setAction("redraw",
		"
		this.graphics.clear();
		this.graphics.beginFill(this.color);
		this.graphics.drawRect(0,0,this.box.width,this.box.height);
		this.graphics.endFill();
				
		this.graphics.lineStyle(1, Color.darken(this.color, 20));
		this.graphics.moveTo(1, this.box.height>>1);
		this.graphics.lineTo(this.box.width-1, this.box.height>>1);
		");
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(MenuSeperator);

	}
	//}}}
}
//}}}
