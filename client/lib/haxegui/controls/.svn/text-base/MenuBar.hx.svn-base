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
import haxegui.controls.UiList;
import haxegui.controls.PopupMenu;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import haxegui.DataSource;
import haxegui.XmlParser;
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.controls.Image;
import haxegui.controls.Label;
import haxegui.events.MenuEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.FocusManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


using haxegui.controls.Component;
using haxegui.utils.Color;

//{{{
class Spacer extends Component {
	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Spacer);
	}
	//}}}
}
//}}}

//{{{ Menu
/**
* Menu Class
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.2
*/
class Menu extends AbstractButton, implements IDataSource, implements IAggregate {

	//{{{ Members
	public var label 		: Label;
	public var icon  		: Icon;
	public var menu  		: PopupMenu;
	
	/** Keyboard shortcut keycode **/
	public var key : Int;

	public var dataSource(default, setDataSource) : DataSource;

	static var layoutXml = Xml.parse('
	<haxegui:Layout name="Menu">
		<haxegui:controls:Label x="4" y="3" text="{parent.name}" mouseEnabled="false"/>
	</haxegui:Layout>
	').firstElement();
	//}}}


	//{{{ Functions
	//{{{ init
	/**
	* @throws String when not parented to a [MenuBar]
	*/
	override public function init(opts:Dynamic=null) {
		//if(!Std.is(parent, MenuBar)) throw parent+" not a MenuBar";
		box = new Size(40,24).toRect();
		// menu = new PopupMenu();

		super.init(opts);

		XmlParser.apply(Menu.layoutXml, this);

		// label = new Label(this);
		// label.init({text: name});
		// label.move(4,4);
		// label.mouseEnabled = false;

		label = cast firstChild();

		var r = ~/_(.)/;
		if(r.match(name)) {
		key = r.matched(0).charCodeAt(1);
		name = r.replace(name, "<U>$1</U>");
		label.tf.htmlText = name;
		}

		
		box.width = label.width;
		// dirty = false;
	}
	//}}}


	//{{{ onMouseClick
	public override function onMouseClick(e:MouseEvent) {
		var p = parent.localToGlobal(new flash.geom.Point(x, y));

		if(menu!=null)
		menu.destroy();
		menu = new PopupMenu(flash.Lib.current);
		menu.dataSource = this.dataSource;
		menu.init ();

		menu.toFront();

		menu.x = p.x + 4;
		menu.y = p.y;

		//var self = this;
		//var r = new Rectangle();
		//r.width = menu.box.width;
		//menu.scrollRect = r;

		// var t = new feffects.Tween(0, menu.data.length*24, 250, r, "height", feffects.easing.Linear.easeOut);
		// t.setTweenHandlers(
		// function(v){
		// 	self.menu.scrollRect = r.clone();
		// }
		// );
		// t.start();
		this.color = DefaultStyle.FOCUS;
		redraw();

		var self = this;
		var onMenuHide = function(e) {
			self.color = (cast self.parent).color;
			self.redraw();
		}
		menu.addEventListener(MenuEvent.MENU_HIDE, onMenuHide, false, 0, true);
		// for(i in menu)
			// (cast i).setAction("mouseDown", "var a = new haxegui.Alert(); a.init(); a.label.setText(this.label.getText());");

		super.onMouseClick(e);
	}
	//}}}


	//{{{ setDataSource
	public function setDataSource(d:DataSource) : DataSource {
		dataSource = d;
		// dataSource.addEventListener(Event.CHANGE, onData, false, 0, true);
		return dataSource;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Menu);
	}
	//}}}
	//}}}
}
//}}}


//{{{ MenuBar
/**
* MenuBar Class
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class MenuBar extends Component, implements IRubberBand {
	//{{{ Members
	public var items 	: Array<Menu>;

	//public var numMenus(default, null) : Int;

	private var _menu	: Int;
	//}}} Members


	//{{{ Functions
	//{{{ init
	override public function init(opts : Dynamic=null) {
		// assuming parent is a window
		box = new Size(parent.asComponent().box.width - 10, 24).toRect();

		color = (cast parent).color;
		items = [];


		super.init(opts);


		redraw({box: this.box});

		buttonMode = false;
		tabEnabled = false;
		focusRect = false;
		mouseEnabled = false;


		// inner-drop-shadow filter
		this.filters = [new DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5,4, 4,0.75,BitmapFilterQuality.LOW,true,false,false)];

		parent.addEventListener(ResizeEvent.RESIZE, onParentResize);

	}
	//}}}


	//{{{ addChild
	override function addChild(child : flash.display.DisplayObject) : flash.display.DisplayObject {
		var child = super.addChild(child);
		if(Std.is(child, Menu))
		items.push(cast child);
		// child.x = 40*getChildIndex(child);
		var w = .0;
		for(i in this) w += (getChildIndex(child)==0?0:4) + (Std.is(i, Component)?(cast i).box.width:i.width);
		child.x = w;
		return child;
	}
	//}}}


	//{{{ onParentResize
	public function onParentResize(e:ResizeEvent) {
		box.width = parent.asComponent().box.width - 10;

		var b = box.clone();
		b.height = box.height;
		b.x = b.y = 0;
		this.scrollRect = b;

		dirty = true;

		//e.updateAfterEvent();
	}
	//}}}


	//{{{ onKeyDown
	override public function onKeyDown (e:KeyboardEvent) {}
	//}}}


	//{{{ openMenuByName
	/**
	*
	*/
	function openMenuByName (name:String) {
		openMenuAt (this.getChildIndex (this.getChildByName (name)));
	}
	//}}}


	//{{{ openMenuAt
	/**
	*
	*/
	function openMenuAt (i:UInt) {
		var menu = this.getChildAt (i);
		//~ var popup = PopupMenu.getInstance();
		//~ popup.init ({parent:this.parent, x:menu.x, y:menu.y + 20});
		//register new popups for close
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(MenuBar);
	}
	//}}}
	//}}}
}
//}}}
