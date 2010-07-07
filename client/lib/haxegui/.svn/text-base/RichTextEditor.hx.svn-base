// Copyright (c) 2409 The haxegui developers
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
import flash.Error;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import haxe.Timer;
import haxegui.Window;
import haxegui.controls.Button;
import haxegui.controls.ComboBox;
import haxegui.controls.Component;
import haxegui.controls.IText;
import haxegui.controls.Input;
import haxegui.controls.Label;
import haxegui.controls.Slider;
import haxegui.controls.Stepper;
import haxegui.controls.ToolBar;
import haxegui.events.DragEvent;
import haxegui.events.MenuEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Size;
import haxegui.windowClasses.StatusBar;
//}}}


//{{{ RichTextEditor
/**
*
* Rich Text Editor with controls for selecting font-face, font-size, alignment and color.<br/>
*
* @todo Cleanup, probably less script more code...
*
*
* @author <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class RichTextEditor extends Window, implements IText {
	//{{{ Members
	//{{{ Public
	public var tf : TextField;
	public var text(getText, setText) : String;
	//}}}


	//{{{ Private
	var _color : UInt;
	var _html : Bool;
	//}}}
	//}}}


	//{{{ Functions
	//{{{ init
	public override function init(?opts:Dynamic=null) {
		_color = Color.BLACK;
		_html = true;


		super.init();


		box = new Size(512, 380).toRect();


		// toolbar with comboboxes and buttons
		var toolbar = new ToolBar(this, "Toolbar", 10, 20);
		toolbar.init();


		//{{{ FontBox
		// font face selection combobox
		var fontbox = new ComboBox(toolbar, "FontBox", 14, 10);
		fontbox.init({text: "Arial", width: 100});
		var ds = new DataSource();
		ds.data = ["Arial", "Arial Black", "Bitstream Vera Sans", "Courier", "Georgia", "Comic Sans MS", "Impact", "Times New Roman", "Trebuchet MS", "Verdana"];
		fontbox.dataSource = ds;


		var self = this;
		var onFontChanged = function(e) {
			var font = fontbox.input.getText();
			var text = self.tf.selectedText;
			self.tf.replaceSelectedText( "[replace]" );

			var htmlText  = new TextField();
			htmlText.text = self.tf.htmlText;

			var start = htmlText.text.indexOf("[replace]", 0);
			var end = start + "[replace]".length;

			htmlText.replaceText(start, end, "<FONT FACE='"+font+"'>"+ text + "</FONT>" );

			self.tf.htmlText = htmlText.text;
			self.tf.dispatchEvent(new Event(Event.CHANGE));
		}
		fontbox.addEventListener(Event.CHANGE, onFontChanged);
		//}}}


		//{{{ SizeBox
		// font size selection combobox
		var sizebox = new ComboBox(toolbar, "SizeBox", 124, 10);
		sizebox.init({text: "10", width: 50});
		var ds = new DataSource();
		ds.data = [7,8,12,14,16,18,20,22,24,32,48,72,96];
		sizebox.dataSource = ds;

		var onMenuShow = function(e) {
			trace(e);
			trace(e.target);
			e.target.color = Color.random();
			e.target.redraw();
		}

		var onSizeChanged = function(e) {
			var size = sizebox.input.getText();

			var text = self.tf.selectedText;
			self.tf.replaceSelectedText( "[replace]" );

			var htmlText  = new flash.text.TextField();
			htmlText.text = self.tf.htmlText;

			var start = htmlText.text.indexOf("[replace]", 0);
			var end = start + "[replace]".length;

			htmlText.replaceText(start, end, "<FONT SIZE='"+ size +"'>"+ text + "</FONT>" );

			self.tf.htmlText = htmlText.text;
			self.tf.dispatchEvent(new Event(Event.CHANGE));
		}

		sizebox.addEventListener(Event.CHANGE, onSizeChanged);
		//}}}


		//{{{ Bold
		var btn = new Button(toolbar, "Bold", 180, 8);
		btn.init({width: 24, height: 24, label: null, icon: "format-text-bold.png" });
		btn.setAction("mouseClick",
		"
		var tf = this.getParentWindow().getChildByName(\"Container1\").getChildByName(\"tf\");
		var text = tf.selectedText;
		tf.replaceSelectedText( \"[replace]\" );

		var htmlText  = new flash.text.TextField();
		htmlText.text = tf.htmlText;

		var start = htmlText.text.indexOf(\"[replace]\", 0);
		var end = start + \"[replace]\".length;

		htmlText.replaceText(start, end, \"<B>\" + text + \"</B>\" );

		tf.htmlText = htmlText.text;
		"
		);
		//}}}


		//{{{ Italic
		btn = new Button(toolbar, "Italic", 204, 8);
		btn.init({width: 24, height: 24, label: null, icon: "format-text-italic.png" });
		btn.setAction("mouseClick",
		"
		var tf = this.getParentWindow().getChildByName(\"Container1\").getChildByName(\"tf\");
		var text = tf.selectedText;
		tf.replaceSelectedText( \"[replace]\" );

		var htmlText  = new flash.text.TextField();
		htmlText.text = tf.htmlText;

		var start = htmlText.text.indexOf(\"[replace]\", 0);
		var end = start + \"[replace]\".length;

		htmlText.replaceText(start, end, \"<I>\" + text + \"</I>\" );

		tf.htmlText = htmlText.text;
		"
		);
		//}}}


		//{{{ Underline
		btn = new Button(toolbar, "UnderLine", 228, 8);
		btn.init({width: 24, height: 24, label: null, icon: "format-text-underline.png" });
		btn.setAction("mouseClick",
		"
		var tf = this.getParentWindow().getChildByName(\"Container1\").getChildByName(\"tf\");
		var text = tf.selectedText;
		tf.replaceSelectedText( \"[replace]\" );

		var htmlText  = new flash.text.TextField();
		htmlText.text = tf.htmlText;

		var start = htmlText.text.indexOf(\"[replace]\", 0);
		var end = start + \"[replace]\".length;

		htmlText.replaceText(start, end, \"<U>\" + text + \"</U>\" );

		tf.htmlText = htmlText.text;
		"
		);
		//}}}


		//{{{ Align
		btn = new Button(toolbar, "AlignLeft", 252, 8);
		btn.init({width: 24, height: 24, label: null, icon: "format-justify-left.png" });

		btn = new Button(toolbar, "AlignCenter", 276, 8);
		btn.init({width: 24, height: 24, label: null, icon: "format-justify-center.png" });

		btn = new Button(toolbar, "AlignRight", 300, 8);
		btn.init({width: 24, height: 24, label: null, icon: "format-justify-right.png" });

		btn = new Button(toolbar, "AlignFill", 324, 8);
		btn.init({width: 24, height: 24, label: null, icon: "format-justify-fill.png" });
		//}}}


		//{{{ Color
		var swatch = new Swatch(toolbar, 400, 8);
		swatch.init({_color: Color.BLACK, width: 32, height: 24, label: null });

		//{{{ mouseClick
		swatch.setAction("mouseClick",
		"
		var win = this.getParentWindow();
		var tf = win.getChildByName('Container1').getChildByName('tf');

		// Color picking
		var c = new haxegui.ColorPicker();
		c.currentColor = win._color;
		this._color = win._color;
		c.init();
		var container = c.getChildByName('Container');
		var grid = container.getChildByName('Grid');
		var ok = grid.getChildByName('Ok');
		var cancel = grid.getChildByName('Cancel');

		cancel.setAction('mouseClick', 'this.getParentWindow().destroy();');
		//{{{ onColoreChoosen
		function onColoreChoosen(e) {
			win._color = c.currentColor;
			c.destroy();
			this._color = win._color;
			this.redraw();
			var hex = StringTools.hex(win._color);

			var text = tf.selectedText;
			tf.replaceSelectedText( '[replace]' );

			var htmlText  = new flash.text.TextField();
			htmlText.text = tf.htmlText;

			var start = htmlText.text.indexOf('[replace]', 0);
			var end = start + '[replace]'.length;

			htmlText.replaceText(start, end, \"<FONT COLOR='#\"+hex+\"' >\" + text + \"</FONT>\" );

			tf.htmlText = htmlText.text;
			tf.dispatchEvent(new flash.events.Event(flash.events.Event.CHANGE));
		};
		ok.addEventListener(flash.events.MouseEvent.MOUSE_UP, onColoreChoosen, false, 0, true);
		//}}}
		"
		);
		//}}}
		//}}}


		//{{{ Html
		btn = new Button(toolbar, "Html", 432, 8);
		btn.setAction("mouseClick",
		"
		var html = this.getParentWindow()._html;
		var tf = this.getParentWindow().getChildByName('Container1').getChildByName('tf');
		if(html)
		tf.text = tf.htmlText;
		else
		tf.htmlText = tf.text;

		tf.setSelection(0,tf.htmlText.length);
		tf.scrollV = 0;

		this.removeChild(this.getChildByName('icon'));

		var icn = new haxegui.controls.Icon(this, 'icon', 4, 4);
		if(html)
		icn.src = 'text-html.png';
		else
		icn.src = 'text-x-generic.png';
		icn.init();

		this.getParentWindow()._html = !this.getParentWindow()._html;
		"
		);
		btn.init({width: 24, height: 24, label: null, icon: "text-html.png" });
		btn.icon.name = "icon";
		//}}}


		//
		var container = new haxegui.containers.Container (this, "Container1", 10, 60);
		container.init({width: 502, height: 310});

		//{{{ TextField
		tf = new TextField();
		tf.name = "tf";
		tf.x = tf.y = 10;
		tf.width = this.box.width - 40;
		tf.height = this.box.height - 124;
		tf.type = flash.text.TextFieldType.INPUT;
		tf.background = true;
		tf.backgroundColor = DefaultStyle.INPUT_BACK;
		tf.textColor = DefaultStyle.INPUT_TEXT;
		tf.border = true;
		tf.borderColor = DefaultStyle.BACKGROUND - 0x141414;
		tf.autoSize = flash.text.TextFieldAutoSize.NONE;
		tf.multiline = true;
		tf.wordWrap = true;
		tf.alwaysShowSelection = true;

		tf.htmlText = "<p>Lorem ipsum dolor sit amet.</p><p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo. Quisque sit amet est et sapien ullamcorper pharetra. Vestibulum erat wisi, condimentum sed, commodo vitae, ornare sit amet, wisi. Aenean fermentum, elit eget tincidunt condimentum, eros ipsum rutrum orci, sagittis tempus lacus enim ac dui. Donec non enim in turpis pulvinar facilisis. Ut felis. Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus</p>";
		//}}}

		container.addChild(tf);

		// outer dropshadow
		tf.filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5,4, 4,0.75,flash.filters.BitmapFilterQuality.HIGH,false,false,false)];

		// inner dropshadow
		container.filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5,4, 4,0.75,flash.filters.BitmapFilterQuality.HIGH,true,false,false)];

		// statusbar
		statusbar = new StatusBar(this, "StatusBar", 10, box.height-20);
		statusbar.init({width: box.width});

		//
		var info = new Label(statusbar, 4, 4);
		info.init();


		tf.addEventListener(TextEvent.TEXT_INPUT, updateInfo);
		tf.addEventListener(Event.CHANGE, updateInfo);
		tf.addEventListener(MouseEvent.MOUSE_DOWN, updateInfo);
		tf.addEventListener(MouseEvent.MOUSE_UP, updateInfo);
		tf.addEventListener(KeyboardEvent.KEY_DOWN, updateInfo);


		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ updateInfo
	public function updateInfo(e:Dynamic) {var info = cast statusbar.getChildAt(0);

		var info = cast statusbar.getChildAt(0);

		var l = 0;
		var c = 0;
		if(Std.is(e, MouseEvent)) {
			l = tf.getLineIndexAtPoint(e.localX, e.localY);
			c = tf.getCharIndexAtPoint(e.localX, e.localY);
		}
		if(Std.is(e, KeyboardEvent)) {
			l = tf.getLineIndexOfChar( tf.caretIndex );
		}

		var o = {
			line: l,
			col: c,
			numLines: tf.numLines,
			pos: tf.caretIndex,
			sel: tf.selectedText.length
		};
		var txt = Std.string(o);
		txt = txt.substr(1, txt.length-2);
		txt = txt.split(",").join("\t ");
		info.tf.text = txt;

	}
	//}}}


	//{{{ onRollOver
	public override function onRollOver(e:MouseEvent)  : Void {
		CursorManager.setCursor(Cursor.HAND);
		CursorManager.setCursor(Cursor.HAND);
	}
	//}}}


	//{{{ onRollOut
	public override function onRollOut(e:MouseEvent) {} //}}}if(e.target.hitTestObject( CursorManager.getInstance()._mc ))


	//{{{ onMouseUpImage
	public function onMouseUpImage(e:MouseEvent)  : Void {if(e.target.hitTestObject( CursorManager.getInstance()._mc ))

		if(e.target.hitTestObject( CursorManager.getInstance()._mc ))
		CursorManager.setCursor(Cursor.HAND);
	}
	//}}}


	//{{{ onResize
	public override function onResize(e:ResizeEvent) {super.onResize(e);

		super.onResize(e);
		if(tf!=null) {
			tf.width = this.box.width - 30;
			tf.height = this.box.height - 124;
		}
		//(cast statusbar.getChildAt(0)).box.width = this.box.width - 20;
		//(cast statusbar.getChildAt(0)).tf.width = this.box.width - 20;
	}
	//}}}

	public function getText() : String {
		return tf.text;
	}

	public function setText(s:String) : String {
		tf.text = s;
		return tf.text;
	}

	//}}}
}
//}}}