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

package haxegui.windowClasses;

import flash.geom.Rectangle;
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.utils.Opts;
import haxegui.managers.ScriptManager;
import haxegui.managers.StyleManager;
import haxegui.controls.Component;
import haxegui.controls.AbstractButton;

/**
*
* StatusBar Class
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class StatusBar extends Component {

	//{{{ init
	override public function init(?opts:Dynamic) {
		box = (cast parent).box.clone();
		color = (cast parent).color;
		if(x==0) x=10;

		super.init(opts);

		parent.addEventListener(ResizeEvent.RESIZE, onParentResize);

		this.filters = [new DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5, 4, 4, 0.5,BitmapFilterQuality.HIGH,true,false,false)];

	}
	//}}}


	//{{{ onParentResize
	public function onParentResize(e:ResizeEvent) {
		box = untyped new Rectangle(0,0,parent.box.width-10, parent.box.height+20);
		//this.scrollRect = untyped new Rectangle(0,0,parent.box.width-10, parent.box.height+20);
		scrollRect = box;

		for(i in this) {
			if(Std.is(i, Component)) {
				if(!Math.isNaN((cast i).left)) {
				i.x = (cast i).left;
				}
				else
				if(!Math.isNaN((cast i).right)) {
				i.x = box.width - (cast i).box.width - (cast i).right;
				}

				if(!Math.isNaN((cast i).left) && !Math.isNaN((cast i).right)) {
				i.x = (cast i).left;
				(cast i).box.width = box.width - (cast i).right - i.x;
				(cast i).dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
				}


				if(!Math.isNaN((cast i).top)) {
				i.y = (cast i).top;
				}
				else
				if(!Math.isNaN((cast i).bottom)) {
				i.y = box.height - (cast i).box.height - (cast i).bottom;
				}

				if(!Math.isNaN((cast i).top) && !Math.isNaN((cast i).bottom)) {
				i.y = (cast i).top;
				(cast i).box.height = box.height - (cast i).bottom - i.y;
				(cast i).dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
				}
			}
		}

		dirty = true;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(WindowFrame);
	}
	//}}}
}
