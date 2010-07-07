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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.Window;
import haxegui.containers.Container;
import haxegui.containers.Grid;
import haxegui.containers.Divider;
import haxegui.containers.ScrollPane;
import haxegui.controls.Button;
import haxegui.controls.CheckBox;
import haxegui.controls.Component;
import haxegui.controls.Image;
import haxegui.controls.Image;
import haxegui.controls.Input;
import haxegui.controls.Label;
import haxegui.controls.MenuBar;
import haxegui.controls.Stepper;
import haxegui.controls.Tree;
import haxegui.controls.UiList;
import haxegui.events.MenuEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.FocusManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
import haxegui.windowClasses.StatusBar;
import haxegui.XmlParser;
//}}}


using haxegui.utils.Color;


/**
*
* Appearance is a modal dialog, for changing the common look&feel
*
*
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.2
*/
class Appearance extends Window {

	//{{{ Members
	public static var colorTheme : ColorTheme = {
		ACTIVE_TITLEBAR : DefaultStyle.ACTIVE_TITLEBAR,
		BACKGROUND 		: DefaultStyle.BACKGROUND,
		DROPSHADOW 		: DefaultStyle.DROPSHADOW,
		FOCUS	 		: DefaultStyle.FOCUS,
		INPUT_BACK 		: DefaultStyle.INPUT_BACK,
		INPUT_TEXT 		: DefaultStyle.INPUT_TEXT,
		LABEL_TEXT		: DefaultStyle.LABEL_TEXT,
		PROGRESS_BAR 	: DefaultStyle.PROGRESS_BAR,
		TOOLTIP			: DefaultStyle.TOOLTIP
	}

	public static var fonts = [
	"FFF_Forward",
	"FFF_Manager_Bold",
	"FFF_Harmony",
	"FFF_Freedom_Trial",
	"FFF_Reaction_Trial",
	"Amiga_Forever_Pro2",
	"Silkscreen",
	"04b25",
	"Pixel_Classic"
	];

	static var xml = Xml.parse('
	<haxegui:Layout name="Appearance">
	<haxegui:controls:MenuBar x="10" y="20">
	<haxegui:controls:Menu name="Appearance"/>
	</haxegui:controls:MenuBar>
	<haxegui:controls:TabNavigator x="10" y="42" left="10" right="0">
	<haxegui:controls:Tab/>
	<haxegui:controls:Tab/>
	<haxegui:controls:Tab/>
	</haxegui:controls:TabNavigator>
	<haxegui:containers:Container x="10" y="62" top="62" bottom="50" fitV="false">
	<haxegui:containers:VDivider handlePosition="240">
	<haxegui:containers:Container fitH="false" fitV="false">
	<!-- Will be filled later -->
	</haxegui:containers:Container>
	<haxegui:containers:Container>
	<haxegui:containers:ScrollPane>
	<haxegui:Window x="20" y="20" width="240" height="300"/>
	<haxegui:Window x="40" y="40" width="240" height="300">
	<haxegui:containers:Container>
	<haxegui:controls:Button x="20" y="20"/>
	<haxegui:controls:Button x="120" y="20"/>
	<haxegui:controls:ProgressBar x="20" y="40"/>
	</haxegui:containers:Container>
	</haxegui:Window>
	</haxegui:containers:ScrollPane>
	</haxegui:containers:Container>
	</haxegui:containers:VDivider>
	</haxegui:containers:Container>
	<haxegui:containers:Container bottom="0" height="50" fitV="false">
	<haxegui:controls:Button right="10" bottom="10"/>
	<haxegui:controls:Button right="120" bottom="10"/>
	</haxegui:containers:Container>
	</haxegui:Layout>
	').firstElement();

	public var container : Container;
	public var vdivider	 : VDivider;
	public var grid		 : Grid;

	public var preview : Sprite;

	//{{{ Constructor
	public function new (?parent:DisplayObjectContainer, ?x:Float, ?y:Float) {
		super (parent, "Appearance", x, y);
	}
	//}}}

	//{{{ Functions
	//{{{ init
	public override function init(?opts:Dynamic) {
		super.init(opts);
		box = new Size(720, 480).toRect();
		// minSize = new Size(250, 400);


		XmlParser.apply(Appearance.xml, this);


		container = this.getElementsByClass(Container).next();
		vdivider = container.getElementsByClass(VDivider).next();
		container = vdivider.getElementsByClass(Container).next();

		preview = untyped container.nextSibling().firstChild().content;

		//
		grid = new Grid(container, 0, 0);
		grid.init({
			rows: Reflect.fields(colorTheme).length+1,
			cols: 2
			// left: 10,
			// top: 10,
			// bottom: 10,
			// right: 10
		});

		//
		var label = new Label(grid);
		label.init({text: "Default Font:"});
		// label.move(20,104);

		//
		var combo = new haxegui.controls.ComboBox(grid);
		combo.init();
		// combo.move(120,100);
		combo.input.tf.text = "FFF_Harmony";
		//cat library.xml  | grep 'font id=' | awk '{ print (substr($2,4)",") }'

		combo.dataSource = new DataSource();
		combo.dataSource.data = fonts;


		var onFontSelected = function(e) {
			combo.input.tf.text = e.target.getChildAt(0).tf.text;
			DefaultStyle.FONT = e.target.getChildAt(0).tf.text;
		}
		combo.addEventListener(MenuEvent.MENU_SHOW, onFontSelected);

		var onFontMenu = function(e) { combo.menu.addEventListener(MouseEvent.MOUSE_DOWN, onFontSelected); }

		combo.addEventListener(MenuEvent.MENU_SHOW, onFontMenu);


		var capitalize = function(word) { return Std.string(word.charAt(0).toUpperCase()) + word.substr(1,word.length-1); }

		for(i in 0...Reflect.fields(colorTheme).length) {
			label = new Label(grid);

			//
			var str = Reflect.fields(colorTheme)[i].toLowerCase();
			var words = Lambda.list(str.split("_"));
			str = words.map(capitalize).join(" ") + ":";
			label.init({text: str });


			var btn = new Swatch(grid);
			btn.init({width: 40, label: null, _color: Reflect.field(colorTheme, Reflect.fields(colorTheme)[i]) });
			btn.minSize = new Size(40,20);
			btn.maxSize = new Size(200,2<<15);

			btn.setAction("mouseClick",
			"
			var spr = this.firstChild();

			var c = new haxegui.ColorPicker();
			c.currentColor = this._color;
			c.init();

			c.cancel.setAction('mouseClick', 'this.getParentWindow().destroy();');
			c.ok.addEventListener(flash.events.MouseEvent.MOUSE_UP,
			function(e) {
				this._color = c.currentColor;
				this.redraw();
				DefaultStyle."+Reflect.fields(colorTheme)[i]+" = c.currentColor;
				c.destroy();
				this.getParentWindow().updatePreview();
			});
			");
		}
	}
	//}}}

	//{{{ updatePreview
	public function updatePreview() {
		updateColorRecursive(preview, DefaultStyle.BACKGROUND);
	}
	//}}}

	//{{{ updateColorRecursive
	private function updateColorRecursive(o:DisplayObjectContainer, color:UInt) {
		if(Std.is(o, flash.text.TextField)) return;
		if(Std.is(o, flash.display.Bitmap)) return;
		for(i in 0...o.numChildren) {
			var child = o.getChildAt(i);
			if(Std.is(child, flash.text.TextField)) return;
			if(Std.is(child, flash.display.Bitmap)) return;
			(cast child).color = color;
			(cast child).redraw();
			updateColorRecursive(cast child, color);
		}
	}
	//}}}
	//}}}
}