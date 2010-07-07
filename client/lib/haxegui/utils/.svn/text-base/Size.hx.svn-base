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


package haxegui.utils;

import flash.geom.Point;
import flash.geom.Rectangle;


//{{{ ScaleMode
enum ScaleMode {
	IGNORE_ASPECT;
	KEEP_ASPECT;
}
//}}}


//{{{ Size
/**
* R^2 Dimensional class, uses integers.<br/>
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class Size {

	public var width : Int;
	public var height : Int;

	//{{{ Constructor
	public function new(?w:Float, ?h:Float) {
		this.width = Std.int(w);
		this.height = Std.int(h);
	}
	//}}}

	//{{{ toString
	public function toString() : String {
		return "["+Std.string(width)+"x"+Std.string(height)+"]";
	}
	//}}}


	//{{{ clone
	public function clone() : Size {
		return new Size(width,height);
	}
	//}}}


	//{{{ isNull
	public static function isNull(s) : Bool {
		return s == null;
	}
	//}}}


	//{{{ isValid
	public static function isValid(s) : Bool {
		return s.valid();
	}
	//}}}


	//{{{ empty
	public function empty() : Bool {
		return equal(this, new Size());
	}
	//}}}




	//{{{ valid
	public function valid() : Bool {
		if (isNull(this) || width < 0 || height < 0) return false;
		return true;
	}
	//}}}


	//{{{ setAtLeastZero
	public function setAtLeastZero() : Size {
		if(empty() || valid()) return this;
		width = Std.int(Math.max(0, width));
		height = Std.int(Math.max(0, height));
		return this;
	}
	//}}}


	//{{{ equal
	public static function equal(s1, s2) : Bool {
		if(isNull(s1) || isNull(s2) ) {
			if(s1 == s2)
				return true;
			return false;
		}
		if(s1.width == s2.width && s1.height == s2.height)
			return true;
		return false;
	}
	//}}}


	//{{{ add
	public function add(s:Size) : Size {
		if(s.empty()) return this;
		width += s.width;
		height += s.height;
		return this;
	}
	//}}}


	//{{{ subtract
	public function subtract(s:Size) : Size {
		width -= s.width;
		height -= s.height;
		return this;
	}
	//}}}


	//{{{ scale
	/**
	* Scalar Multiplication
	*/
	public function scale(x:Float, y:Float) : Size {
		width = Std.int(width*x);
		height = Std.int(height*y);
		return this;
	}
	//}}}


	//{{{ scaleTo
	/** @todo KEEP_ASPECT **/
	public function scaleTo(w:Float, h:Float, scaleMode:ScaleMode) : Size {
		switch(scaleMode) {
		case ScaleMode.IGNORE_ASPECT:
			width = Std.int(w);
			height = Std.int(h);
		case ScaleMode.KEEP_ASPECT:
			var r = width / height;
			//width = w;
			//height = h;
		}
		return this;
	}
	//}}}


	//{{{ shift
	/**
	* Bit-shift both components of input size
	* <pre class="code haxe">
	* // returns 50x50
	* new Size(100,100).shift(1);
	* </pre>
	* @return Shifted size
	**/
	public function shift(s:Int) : Size {
		this.width >> = s;
		this.height >> = s;
		return this;
	}
	//}}}


	//{{{ fromRect
	public static function fromRect(r:Rectangle) : Size {
		return new Size(r.width,r.height);
	}
	//}}}


	//{{{ fromPoint
	public static function fromPoint(p:Point) : Size {
		return new Size(p.x, p.y);
	}
	//}}}


	//{{{ square
	public static function square(l:Int) : Size {
		return new Size(l,l);
	}
	//}}}


	//{{{ toRect
	public function toRect() : Rectangle {
		return new Rectangle(0,0,width,height);
	}
	//}}}


	//{{{ toPoint
	public function toPoint() : Point {
		return new Point(width,height);
	}
	//}}}
}
//}}}
