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

package haxegui.managers;


//{{{ Imports
import feffects.Tween;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.controls.Component;
import haxegui.controls.Label;
import haxegui.managers.StyleManager;
import haxegui.toys.Balloon;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


//{{{ Tooltip
/**
*
* A Ballon with a label.<br/>
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class Tooltip extends Component {

	//{{{ Members
	public var target	 : Component;

	public var balloon   : Balloon;

	public var label 	 : Label;

	public var fadeTween : Tween;

	public var fixed 	 : Bool;
	//}}}


	//{{{ Constructor
	public function new (target:Component) {
		fixed = false;


		super (flash.Lib.current, "Tooltip",  flash.Lib.current.stage.mouseX - 15, flash.Lib.current.stage.mouseY - 30);


		if(color==Color.MAGENTA) color = DefaultStyle.TOOLTIP;

		balloon = new Balloon(this);
		balloon.init({color: this.color, roundness: 8});
		balloon.mouseEnabled = false;
		balloon.description = null;

		mouseChildren = false;
		mouseEnabled = false;
		description = null;
		buttonMode = false;
		visible = false;
		alpha = 0;


		label = new Label(this, 4, 4);
		label.init({ text: target.description == null ? target.name : target.description });
		label.mouseEnabled = false;
		label.tf.selectable = false;
		label.tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
		label.tf.multiline = false;

		box = new Size(label.tf.width+8, label.tf.height+8).toRect();
		balloon.box = box.clone();


		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.8, 4, 4, 0.65, flash.filters.BitmapFilterQuality.HIGH, false, false, false )];

		if(!fixed)
		if (this.parent != null)
		if (this.parent.contains (this))
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);


		dirty = false;
		var self = this;
		fadeTween = new feffects.Tween(0, .8, 350, this, "alpha", feffects.easing.Expo.easeOut);
		haxe.Timer.delay( function(){ self.dirty=true; self.visible=true; self.fadeTween.start(); }, 750 );
	}
	//}}}


	//{{{ onMove
	public function onMove(e:MouseEvent) {
		this.x = e.stageX - 15;
		this.y = e.stageY - 30;

		if (this.parent != null)
		if (this.parent.contains (this))
		this.parent.setChildIndex(this, this.parent.numChildren-1);
	}
	//}}}


	//{{{ destroy
	public override function destroy() {
		if(stage!=null && stage.hasEventListener(MouseEvent.MOUSE_MOVE))
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);

		super.destroy();
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Tooltip);
	}
	//}}}
}
//}}}


//{{{ TooltipManager
/**
*
* TooltipManager Class
*
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class TooltipManager extends EventDispatcher {

	//{{{ Members
	private static var _instance : TooltipManager = null;

	var tt : Tooltip;
	//}}}


	//{{{ getInstance
	public static function getInstance() : TooltipManager {
		if (TooltipManager._instance == null)
		TooltipManager._instance = new TooltipManager ();
		return TooltipManager._instance;
	}
	//}}}


	//{{{ create
	public function create(target:Component) {
		if(tt!=null)
		tt.destroy();
		tt = new Tooltip(target);
		tt.init();
	}
	//}}}


	//{{{ destroy
	public function destroy() {
		if(tt==null) return;
		tt.destroy();
	}
	//}}}
}
//}}}
