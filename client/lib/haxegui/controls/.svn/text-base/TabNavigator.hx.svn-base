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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.controls.IAdjustable;
import haxegui.controls.Label;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
import haxegui.XmlParser;
//}}}


//{{{ Tab
/**
* Tab Class<br/>
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*
*/
class Tab extends AbstractButton, implements IAggregate {

	public var label  : Label;
	public var active : Bool;

	static var xml = Xml.parse('
	<haxegui:Layout name="Tab">
	<haxegui:controls:Label text="{parent.name}"/>
	</haxegui:Layout>
	').firstElement();


	//{{{ init
	override public function init(opts:Dynamic=null) {
		if(!Std.is(parent, TabNavigator)) throw parent+" not a TabNavigator";

		box = new Size(40, 24).toRect();
		color = DefaultStyle.BACKGROUND;
		active = false;

		super.init(opts);

		xml.set("name", name);


		XmlParser.apply(Tab.xml, this);


		active = Opts.optBool(opts, "active", active);

		label = getElementsByClass(Label).next();
		label.mouseEnabled = false;


		parent.addEventListener(ResizeEvent.RESIZE, onParentResize, false, 0, true);
	}
	//}}}


	//{{{ onMouseClick
	/** Mouse click **/
	public override function onMouseClick(e:MouseEvent) {
		var tabnav = cast(parent, TabNavigator);
		tabnav.activeTab = tabnav.getChildIndex(this);
		//parent.dispatchEvent(new Event(Event.CHANGE));
		super.onMouseClick(e);
	}
	//}}}


	//{{{ onParentResize
	public function onParentResize(e:ResizeEvent) {
		moveTo(x, (cast parent).box.height-box.height);
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Tab);
	}
	//}}}
}
//}}}


//{{{ TabPosition
/** @todo implement **/
enum TabPosition {
	TOP;
	BOTTOM;
	LEFT;
	RIGHT;
}
//}}}


//{{{ TabNavigator
/**
* Tab Navigator bar for switching visible content.<br/>
* Add child [Tab]s to the bar, and connect it to a [Stack] container like this:
* <pre class="code haxe">
* // add a tabnav with 2 tabs
* var tabnav = new TabNavigator();
* tabnav.init();
*
* var tab = new Tab(tabnav);
* tab.init();
*
* // 40 is the default tab width, and is passed as horizotal offset
* tab = new Tab(tabnav, 40);
* tab.init();
*
* // prepare a stack container
* var stack = getChildByName("Stack");
* var onTabChanged = function(e:Event) { stack.getChildAt(tabnav.activeTab).toFront(); }
*
* // connect to the stack container
* tabnav.addEventListener(Event.CHANGE, onTabChanged, false, 0, true);
* </pre>
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class TabNavigator extends Component, implements IAdjustable {

	//{{{ Members
	/** Tab position **/
	public var tabPosition : TabPosition;

	/** A list of references for easy access to tabs **/
	public var tabs : List<Tab>;

	/** The index of the selected tab **/
	public var activeTab(default, __setActive) : Int;

	/** **/
	public var adjustment : Adjustment;
	//}}}

	//{{{ addChild
	/** Override for addchild, if its a [Tab] its added to the [tabs] list **/
	public override function addChild(o : DisplayObject) : DisplayObject {
		//if(Std.is(o, Tab)) for(i in 0...numChildren) if(Std.is(getChildAt(i), Tab)) getChildAt(i).active = false;
		//if(Std.is(o, Tab)) tabs.add(cast(o, Tab));
		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
		return super.addChild(o);
	}
	//}}}


	//{{{ init
	override public function init(opts : Dynamic=null) {
		box = new Size(200, 24).toRect();
		color = DefaultStyle.BACKGROUND;
		description = null;
		tabPosition = TabPosition.TOP;


		super.init(opts);


		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, .5, 4, 4, .5, flash.filters.BitmapFilterQuality.HIGH,true,false,false)];

		addEventListener(Event.CHANGE, onChanged, false, 0, true);
		parent.addEventListener(ResizeEvent.RESIZE, onParentResize, false, 0, true);
	} //}}}


	//{{{ __setActive
	/** Setter for the active tab **/
	public function __setActive(v:Int) : Int {
		activeTab = v;
		dispatchEvent(new Event(Event.CHANGE));
		return activeTab;
	} //}}}


	//{{{ onChanged
	/** Callback for a tab change, updates all child Tabs **/
	public function onChanged(e:Event) {
		// #if debug
		// trace(this+" tab changed: "+activeTab);
		// #end
		for(tab in getElementsByClass(Tab)) {
			tab.active = ( getChildIndex(cast tab) == activeTab );
			tab.redraw();
		}
	}
	//}}}


	//{{{ onParentResize
	public function onParentResize(e:ResizeEvent) {
		// if(Std.is(parent, Component)) {
		// 	box.width = (cast parent).box.width - x;
		// }

		// if(Std.is(parent.parent, haxegui.containers.ScrollPane)) {
		// 	box.width = untyped parent.parent.box.width;
		// }
		scrollRect = box;

		dirty = true;
		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	} //}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(TabNavigator);
	}
	//}}}
}
//}}}
