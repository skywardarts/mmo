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
import flash.Error;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
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
import flash.ui.Mouse;
import haxe.Timer;
import haxegui.Window;
import haxegui.controls.Button;
import haxegui.controls.ComboBox;
import haxegui.controls.Component;
import haxegui.controls.Image;
import haxegui.controls.MenuBar;
import haxegui.controls.Slider;
import haxegui.controls.Stepper;
import haxegui.events.DragEvent;
import haxegui.events.MenuEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
//}}}


/**
*
* Advanced color picker.
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class ColorPicker2 extends Window
{
	var colors : Array<UInt>;
	var currentColor : UInt;

	var colorRect : Component;


	public override function init(?initObj:Dynamic) {


		super.init({name:"ColorPicker2", x:x, y:y, width:240, height:480, type: WindowType.MODAL, sizeable:false, color: 0xE6D3CC});


		this.type = WindowType.MODAL;
		if(this.frame.hasEventListener(MouseEvent.MOUSE_MOVE))
			this.frame.removeEventListener(MouseEvent.MOUSE_MOVE, this.frame.onMouseMove);

		colors = [];


		//
		var menubar = new MenuBar (this, "MenuBar", 10,20);
		menubar.init ();

		//
		var container = new haxegui.containers.Container (this, "Container", 10, 44);
		container.init({width: 230, height: 440, color: 0xE6D3CC});

		var shadow:DropShadowFilter = new DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5,4, 4,0.75,BitmapFilterQuality.HIGH,true,false,false);
		container.filters = [shadow];



		var wheel = new Image(container, "wheel", -4, 10);
		wheel.init({src: haxegui.Haxegui.baseURL+"assets/colorwheel.jpg"});
		wheel.scaleX = wheel.scaleY = .5;


		var circle = new Sprite();
		container.addChild(circle);
		circle.graphics.beginFill(0xF);
		circle.graphics.drawCircle(116,126,110);
		//~ circle.graphics.drawCircle(250,250,200);
		circle.graphics.endFill();
		wheel.mask = circle;

		var shadow:DropShadowFilter = new DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.75, 8, 8,0.75,BitmapFilterQuality.HIGH,true,false,false);
		wheel.filters = [shadow];

		wheel.setAction("mouseOver",
		"
			CursorManager.setCursor(Cursor.CROSSHAIR);
		"
		);

		wheel.setAction("mouseOut",
		"
			CursorManager.setCursor(Cursor.ARROW);
		"
		);

		wheel.setAction("mouseClick",
		"
			var win = this.parent.parent;

			function toHex(v)
			{
				return Math.min(0xFFFFFF,( v << 16 | v << 8 | v ));
			}

			var circle = new flash.display.Sprite();
			circle.graphics.lineStyle(4,0xFFFFFF);

			var v = 255 * parent.getChildByName(\"Slider\").handle.x / parent.getChildByName(\"Slider\").handle.box.width;
			circle.graphics.beginFill( toHex(v) , 0.5);

			circle.graphics.drawCircle(this.mouseX,this.mouseY,20);
			circle.graphics.endFill();

			circle.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, function(e){ var i = this.getChildIndex(circle); trace(i); win.colors.splice(i-1, 1); win.colorRect.redraw(); this.removeChild(circle); });
			circle.addEventListener(flash.events.MouseEvent.MOUSE_OVER, function(e){ CursorManager.setCursor(Cursor.HAND); });
			circle.addEventListener(flash.events.MouseEvent.MOUSE_OUT, function(e){ CursorManager.setCursor(Cursor.CROSSHAIR); });

			this.addChild(circle);

			var shadow = new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5,4, 4,0.75,flash.filters.BitmapFilterQuality.HIGH,false,false,false);
			circle.filters = [shadow];


			var color = this.getChildAt(0).bitmapData.getPixel(this.mouseX, this.mouseY);
			parent.parent.colors.push(color);
			this.parent.parent.colorRect.redraw();
		"
		);


		// icon
		var darker = new Image(container, "darker", 4, 260);
		darker.init({src: "assets/icons/darker.png"});
		// slider
		var slider = new Slider(container, "Slider");
		slider.init({width: 170, color: 0xE6D3CC});
		slider.move(30, 260);
		slider.handle.x = 128;

		// icon
		var lighter = new Image(container, "lighter", 204, 260);
		lighter.init({src: "assets/icons/highlight.png"});


		//
		colorRect = new Component(container, "colorRect", 10, 300);
		colorRect.init();


		colorRect.setAction("redraw",
		"
			this.graphics.clear();

			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRoundRect(0,0,210,40, 20, 20);
			this.graphics.endFill();

			var wheel = this.parent.getChildByName(\"wheel\");

			var j = parent.parent.colors.length;
			for(i in 0...j)
			{
				this.graphics.beginFill(parent.parent.colors[i]);
				if(i==0)
				this.graphics.drawRoundRectComplex(i*210/j, 0, 210/j, 40, 10, 0, 10, 0);
				else
				if(i==j-1)
				this.graphics.drawRoundRectComplex(i*210/j, 0, 210/j, 40, 0, 10, 0, 10);
				else
				this.graphics.drawRect(i*210/j, 0, 210/j, 40);

				this.graphics.endFill();
			}


			var colors = [0xFFFFFF, 0xFFFFFF, 0, 0];
			var alphas =[.35, .65, 0, .5];
			var ratios =[0, 0x76, 0x77, 0xFF];
			var matrix = new flash.geom.Matrix ();
			matrix.createGradientBox (210, 40, Math.PI/2, 0, 0);
			this.graphics.beginGradientFill (flash.display.GradientType.LINEAR, colors,alphas, ratios, matrix);
			this.graphics.drawRoundRect(0,0,210,40, 20, 20);
			this.graphics.endFill();

		"
		);
		colorRect.redraw();
		colorRect.filters = [shadow];

		var cmbbox = new ComboBox(container, "Preset", 20, 360);
		cmbbox.init({width: 190 });

		// ok button
		var button = new Button(container, "Ok", 20, 390);
		button.init({label: "Ok", color: 0xE6D3CC});

		// cancel button
		var button = new Button(container, "Cancel", 120, 390);
		button.init({label: "Cancel", color: 0xE6D3CC});



		//~ redraw(null);
		//~ dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}


	public override function destroy() {
		super.destroy();
	}

}
