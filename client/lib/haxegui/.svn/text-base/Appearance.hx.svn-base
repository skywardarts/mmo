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
		<haxegui:containers:Container x="10" y="62" top="62" bottom="10">
			<haxegui:containers:HDivider>
				<haxegui:containers:Container>
				<!-- Will be filled later -->
				</haxegui:containers:Container>
				<haxegui:containers:Container>
					<haxegui:containers:ScrollPane>
						<haxegui:Window x="20" y="20" mouseEnabled="false" scaleX=".75" scaleY=".75"/>
						<haxegui:Window x="40" y="40" mouseEnabled="false" scaleX=".75" scaleY=".75">
						<haxegui:containers:Container>
							<haxegui:controls:Button x="20" y="20"/>
							<haxegui:controls:Button x="120" y="20"/>
						</haxegui:containers:Container>
						</haxegui:Window>
					</haxegui:containers:ScrollPane>
				</haxegui:containers:Container>
			</haxegui:containers:HDivider>
		</haxegui:containers:Container>
	</haxegui:Layout>
	').firstElement();

	public var container : Container;
	public var hdivider	 : HDivider;
	public var grid		 : Grid;


	//{{{ Constructor
	public function new (?parent:DisplayObjectContainer, ?x:Float, ?y:Float) {
		super (parent, "Appearance", x, y);
	}
	//}}}


	//{{{ init
	public override function init(?opts:Dynamic) {
		super.init(opts);
		box = new Size(320, 480).toRect();
		minSize = new Size(250, 400);


		XmlParser.apply(Appearance.xml, this);


		container = this.getElementsByClass(Container).next();
		hdivider = container.getElementsByClass(HDivider).next();
		container = hdivider.getElementsByClass(Container).next();

		makeNoticeLabel();


		//
		grid = new Grid(container, 20, 40);
		grid.init({rows: Reflect.fields(colorTheme).length+1, cols: 2});

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
			btn.minSize = new Size(40,30);
			btn.maxSize = new Size(200,2<<15);

			btn.setAction("mouseClick",
			"
			var spr = this.firstChild();

			var c = new haxegui.ColorPicker();
			c.currentColor = this._color;
			c.init();
			var container = c.getChildByName('Container');
			var ok = container.getChildByName('Ok');
			var cancel = container.getChildByName('Cancel');

			cancel.setAction('mouseClick', 'this.getParentWindow().destroy();');
			ok.addEventListener(flash.events.MouseEvent.MOUSE_UP,
			function(e) {
				spr.graphics.beginFill(c.currentColor);
				DefaultStyle."+Reflect.fields(colorTheme)[i]+" = c.currentColor;
				c.destroy();
			});
			");
		}
	}
	//}}}

	//{{{ makeNoticeLabel
	private function makeNoticeLabel() {
		// background
		var rect = new haxegui.toys.Rectangle(container);
		rect.init({width: 300, height: 20});
		rect.color = 0xFFD69A;
		rect.roundness = 12;
		rect.move(8, 8);

		// icon
		var icon = new Icon(rect);
		icon.init({src: "notice.png"});
		icon.move(8,2);

		// label
		var label = new haxegui.controls.Label(rect);
		label.init({text: "Some settings here will only affect new components."});
		label.move(24,2);
	}
	//}}}
}
