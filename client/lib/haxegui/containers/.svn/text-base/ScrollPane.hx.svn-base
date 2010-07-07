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

package haxegui.containers;


//{{{ Imports
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.controls.Component;
import haxegui.controls.ScrollBar;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


//{{{ ScrollPolicy
enum ScrollPolicy {
	ALWAYS_SHOW;
	AUTOMATIC;
	NEVER_SHOW;
}
//}}}


//{{{ ScrollPane
/**
* ScrollPane masks his children, and allows to expose the hidden parts using ScrollBars.<br/>
*
* @todo Policy from Xml
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
**/
class ScrollPane extends Component, implements IContainer {


	public var content : Sprite;

	public var vert : ScrollBar;
	public var horz : ScrollBar;

	public var vertPolicy : ScrollPolicy;
	public var horzPolicy : ScrollPolicy;

	//{{{ Functions

	//{{{ addChild
	/** Children are added to the [content] member **/
	public override function addChild(o : DisplayObject) : DisplayObject {
		if(content!=null && vert!=null && horz!=null)
		return content.addChild(o);
		return super.addChild(o);
	}
	//}}}


	//{{{ init
	override public function init(?opts:Dynamic) {
		color = DefaultStyle.BACKGROUND;
		box = new Size(140, 100).toRect();


		super.init(opts);


		description = null;

		fitH = Opts.optBool(opts,"fitH", true);
		fitV = Opts.optBool(opts,"fitV", true);


		content = new Sprite();
		content.name = "content";
		content.scrollRect = new Rectangle(0,0, flash.Lib.current.stage.stageWidth, flash.Lib.current.stage.stageHeight);
		content.cacheAsBitmap = true;

		addChild(content);


		if(Opts.optBool(opts, "vert", true)) {
			vert = new ScrollBar(this, "vscrollbar", this.box.width - 20, 0);
			vert.init({target: content, color: this.color});
		}


		if(Opts.optBool(opts, "horz", true)) {
			horz = new ScrollBar(this, "hscrollbar");
			horz.init({target: content, horizontal: true, color: this.color});
		}


		// #if debug
		// setAction("redraw", " this.graphics.clear(); this.graphics.lineStyle(2, Color.RED); this.graphics.drawRect(0,0,this.box.width, this.box.height); this.graphics.lineStyle(2, Color.GREEN); this.graphics.drawRect(0,0,this.box.width,this.box.height);" );
		// #end

		parent.addEventListener(ResizeEvent.RESIZE, onParentResize);
		parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ onMouseWheel
	/** @todo fix mouse wheeling **/
	public override function onMouseWheel(e:MouseEvent) {
		if(vert==null) return;
		var handleMotionTween = new feffects.Tween( 0, 1, 1000, feffects.easing.Expo.easeOut );
		/*
		vert.handle.updatePositionTween( handleMotionTween,
		new flash.geom.Point(0, e.delta * (vert.horizontal ? 1 : -1)* vert.adjustment.page),
		null );
		*/
		super.onMouseWheel(e);
	}
	//}}}


	//{{{ onParentResize
	/**
	*
	*/
	public function onParentResize(e:ResizeEvent) {

		//
		if(!Std.is(parent, Divider)) {
			if(fitH) box.width = (cast parent).box.width - x - ((vert!=null && vert.visible) ? 20 : 0);
			if(fitV) box.height = (cast parent).box.height - y - ((horz!=null && horz.visible) ? 20 : 0);
		}

		if(Std.is(parent, haxegui.Window) && (cast parent).statusbar!=null)
		box.height -= 20;


		var r = box.clone();
		r.x = content.scrollRect.x;
		r.y = content.scrollRect.y;
		content.scrollRect = r.clone();

		content.dispatchEvent(e);
		dispatchEvent(e);
	}
	//}}}



	public override function onResize(e:ResizeEvent) {
		dirty = true;
		var r = box.clone();
		r.x = content.scrollRect.x;
		r.y = content.scrollRect.y;
		// r.width += r.x;
		// r.height += r.y;
		content.scrollRect = r.clone();
		content.dispatchEvent(e);

		/** @todo use a scroll policy */
		horz.visible = horz.handle.visible;
		vert.visible = vert.handle.visible;
	}



	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(ScrollPane);
	}
	//}}}
	//}}}
}
//}}}
