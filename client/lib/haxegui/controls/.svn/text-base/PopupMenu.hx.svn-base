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
import feffects.Tween;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.DataSource;
import haxegui.controls.AbstractButton;
import haxegui.controls.Component;
import haxegui.controls.Label;
import haxegui.controls.UiList;
import haxegui.events.MenuEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
import haxegui.events.ResizeEvent;
import haxegui.controls.Seperator;
import haxegui.controls.MenuBar;
//}}}

/**
* Popup Menu<br/>
*
*
*/
class PopupMenu extends Component, implements IDataSource {

	//{{{ Members
	public var items : List<ListItem>;

	public var dataSource(default, setDataSource) : DataSource;
	//}}}


	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic=null) {
		box = new Size(100,20).toRect();
		color = DefaultStyle.INPUT_BACK;
		// if(data==null) data = [""];
		items = new List<ListItem>();

		super.init(opts);


		mouseEnabled = false;
		tabEnabled = false;


		// position
		x = Opts.optFloat(opts,"x",0) + 10;
		y = Opts.optFloat(opts,"y",0) + 20;

		// add the drop-shadow filter
		filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.8,4, 4,0.65,flash.filters.BitmapFilterQuality.HIGH,false,false,false)];


		if(stage!=null)
		stage.addEventListener(MouseEvent.MOUSE_DOWN, shutDown, false, 0, true);


		dispatchEvent (new MenuEvent(MenuEvent.MENU_SHOW, false, false));
		dispatchEvent (new MenuEvent(MenuEvent.CHANGE, false, false));

		// for(i in this) (cast i).redraw();
		if(dataSource==null) return;
		dataSource.addEventListener(Event.CHANGE, onData, false, 0, true);
		dataSource.dispatchEvent(new Event(Event.CHANGE));
	}
	//}}}


	//{{{ shutDown
	public function shutDown(e:MouseEvent) {
		//~ dispatchEvent (new MenuEvent(MenuEvent.MENU_HIDE))
		if(!Std.is(e.target, flash.text.TextField))
		destroy();
	}
	//}}}


	// //{{{ addChild
	// override function addChild(child : flash.display.DisplayObject) : flash.display.DisplayObject {
	// 	var child = super.addChild(child);
	// 	if(Std.is(child, ListItem))
	// 	items.push(cast child);
	// 	return child;
	// }
	// //}}}


	//{{{ setDataSource
	public function setDataSource(d:DataSource) : DataSource {
		dataSource = d;
		dataSource.addEventListener(Event.CHANGE, onData, false, 0, true);
		return dataSource;
	}
	//}}}



	//{{{ onAdded
	public override function onAdded(e:Event) {
		dispatchEvent (new MenuEvent(MenuEvent.MENU_SHOW));
	}
	//}}}


	//{{{ onKeyDown
	override public function onKeyDown (e:KeyboardEvent) {
	}
	//}}}


	//{{{ numItems
	public function numItems() {
		return items.length;
	}
	//}}}


	//{{{ onChanged
	public function onChanged() {
	}
	//}}}


	//{{{ destroy
	public override function destroy() {
		dispatchEvent(new MenuEvent(MenuEvent.MENU_HIDE));
		super.destroy();
	}
	//}}}


	//{{{ onData
	public function onData(?e:Event) {
	if(dataSource==null) return;
		if(Std.is(dataSource.data, Array)) {
			var data = cast(dataSource.data, Array<Dynamic>);
			for (i in 0...data.length) {
				if(data[i]=="") {
					var s = new MenuSeperator(this, 0, 20+20*i+1);
					s.init({
						color: this.color,
						width: this.box.width,
						height: 20
					});
				}
				else {
					var item = new ListItem(this, 0, 20+20*i+1);
					item.init({
						color: this.color,
						label: data[i]
					});

					var txt = data[i];
					var r = ~/_(.)/;
					txt = r.replace(txt, "<U>$1</U>");

					item.label.tf.htmlText = txt;
					item.label.mouseEnabled = true;
					item.label.tf.mouseEnabled = true;

					box.width = Math.max( box.width, item.label.tf.width + 8 );
				}
			}
		}
		else
		if(Std.is(dataSource.data, List)) {
			var j=0;
			var data = cast(dataSource.data, List<Dynamic>);
			var items : Iterator<Dynamic> = data.iterator();
			for(i in items) {
				if(i=="") {
					var s = new MenuSeperator(this, 0, 20+20*j+1);
					s.init({
						color: this.color,
						width: this.box.width,
						height: 20
					});
				}
				else {
					var item = new ListItem(this, 0, 20+20*j+1);
					item.init({
						color: this.color,
						label: i
					});

					var txt = i;
					var r = ~/_(.)/;
					txt = r.replace(txt, "<U>$1</U>");

					item.label.tf.htmlText = txt;
					item.label.mouseEnabled = true;
					item.label.tf.mouseEnabled = true;


					box.width = Math.max( box.width, item.label.tf.width + 8 );
				}
				j++;
			}
		}
		else
		if(Std.is(dataSource.data, Xml)) {
//			trace(StringTools.htmlEscape(dataSource.data));
			var self = this;
			var makeMenu = null;
			makeMenu = function(o:DisplayObjectContainer, x:Xml) : Int {
				var j=0;
				for(i in x.elements()) {
					if(i.nodeName=="separator" || i.get("type")=="separator") {
						var s = new MenuSeperator(o, 0, 20+20*j+1);
						s.init({
							color: self.color,
							width: self.box.width,
							height: 20
						});
					}
					else {
						var item = new ListItem(o, 0, 20+20*j+1);
						item.init({
							disabled: i.get("disabled"),
							color: self.color,
							label: i.get("label")
						});

						var txt = i.get("label");
						var r = ~/_(.)/;
						txt = r.replace(txt, "<U>$1</U>");

						item.label.tf.htmlText = txt;
						item.label.mouseEnabled = true;
						item.label.tf.mouseEnabled = true;

						self.box.width = Math.max( self.box.width, item.label.tf.width + 8 );
						if(i.elements().hasNext()) {
							var a = new haxegui.toys.Arrow(item);
							a.init({x: 2, y: 10, right:4, width:6, height: 6, color: DefaultStyle.BACKGROUND});
							//var c = makeMenu(o, i);
							//j+=c;
							var p = new PopupMenu(self);
							p.init({
								color: item.color,
								x: self.box.width - 10,
								y: item.y - item.box.height - 17,
								visible: false
							});
							p.filters = [];
							var c = makeMenu(p, i);
							item.addEventListener(MouseEvent.MOUSE_OVER, function(e) {
							p.visible=true;
							});
							item.addEventListener(MouseEvent.MOUSE_OUT, function(e) {
							if(!p.visible) return;
							p.visible = false;
							});
						}
						self.box.width = Math.max( self.box.width, item.label.tf.width + 8 );
					}
					j++;
				}
				return j;
			}
			makeMenu(cast this, dataSource.data.firstElement());

/*
				var txt = i.get("label");
				var r = ~/_(.)/;
				txt = r.replace(txt, "<U>$1</U>");

				item.label.tf.htmlText = txt;
				item.label.mouseEnabled = true;
				item.label.tf.mouseEnabled = true;
*/

			}


		box.height = Math.max( box.height, 20*items.length );
		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));

		// for(i in this)
			// (cast i).dirty=true;

	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(PopupMenu);
	}
	//}}}
	//}}}
}

