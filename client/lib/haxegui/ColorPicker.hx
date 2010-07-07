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
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
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
import haxegui.Window;
import haxegui.containers.Container;
import haxegui.containers.Grid;
import haxegui.controls.Button;
import haxegui.controls.Component;
import haxegui.controls.Image;
import haxegui.controls.Input;
import haxegui.controls.MenuBar;
import haxegui.controls.Slider;
import haxegui.controls.Stepper;
import haxegui.events.DragEvent;
import haxegui.events.MenuEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
import haxegui.toys.Arrow;
import haxegui.toys.Circle;
import haxegui.utils.Color;
import haxegui.utils.Size;
//}}}


using haxegui.utils.Color;


//{{{ ColorPicker
/**
*
* ColorPicker class
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*
*/
class ColorPicker extends Window {

	//{{{ Members
	/** the current color in the swatch, 24bit rgb no alpha **/
	public var currentColor : UInt;

	/** the current alpha value, float 0-1 **/
	public var currentAlpha : Float;

	/** input shows color in flash 0xhex format **/
	var input : Input;

	/** the swatch, shows the [currentColor] **/
	var swatch : Swatch;

	/** main container **/
	var container : Container;

	/** grid for sliders and steppers **/
	var grid : Grid;

	/** the image for the spectrum whose [BitmapData] is picked from **/
	var spectrum  : Image;

	/** a marker to point the [currentColor] on the [spectrum] **/
	var marker : Component;

	public var ok : Button;
	public var cancel : Button;

	//}}}

	static var xml = Xml.parse('
	<haxegui:Layout name="ColorPicker">
		<haxegui:containers:Container name="Container">
			<haxegui:controls:Image x="10" y="10" top="10" left="10" bottom="10" width="150" height="220" name="Spectrum" src="assets/spectrum.png"/>

			<haxegui:containers:Container name="Container" left="180" top="10" bottom="10" right="20" fitH="false" fitV="false">
				<haxegui:containers:Grid rows="6" cols="1">

					<haxegui:containers:Container>
					<haxegui:controls:Swatch _color="{this.getParentWindow().currentColor}" left="0" right="130" top="0" bottom="0"/>
						<haxegui:controls:Input text="{StringTools.hex(this.getParentWindow().currentColor,6)}" y="4" width="120" right="0"/>
					</haxegui:containers:Container>

					<haxegui:containers:Container right="40">
						<haxegui:controls:Slider left="0" right="50"/>
						<haxegui:controls:Stepper y="6" width="40" right="0"/>
					</haxegui:containers:Container>

					<haxegui:containers:Container>
						<haxegui:controls:Slider left="0" right="50"/>
						<haxegui:controls:Stepper y="6" width="40" right="0"/>
					</haxegui:containers:Container>

					<haxegui:containers:Container>
						<haxegui:controls:Slider left="0" right="50"/>
						<haxegui:controls:Stepper y="6" width="40" right="0"/>
					</haxegui:containers:Container>

					<haxegui:containers:Container>
						<haxegui:controls:Slider left="0" right="50"/>
						<haxegui:controls:Stepper y="6" width="40" right="0"/>
					</haxegui:containers:Container>

					<haxegui:containers:Container name="Container6">
						<haxegui:controls:Button right="100" name="Ok" label="Ok"/>
						<haxegui:controls:Button right="0" name="Cancel" label="Cancel"/>
					</haxegui:containers:Container>

				</haxegui:containers:Grid>
			</haxegui:containers:Container>
		</haxegui:containers:Container>
	</haxegui:Layout>
	').firstElement();

	//{{{ Functions
	//{{{ init
	public override function init(?opts:Dynamic) {
		type = WindowType.DIALOG;

		super.init(opts);


		box = new Rectangle (0, 0, 500, 260);
		minSize = new Size(400, 260);
		maxSize = new Size(1000, 1000);


		currentAlpha = 1;
		var rgb = currentColor.toRGB();


		xml.set("name", name);

		XmlParser.apply(ColorPicker.xml, this);


		var win = cast flash.Lib.current.getChildByName(name);

		//
		container = win.getChildByName("Container");
		container.filters = [new DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.5,4, 4,0.75,BitmapFilterQuality.HIGH,true,false,false)];

		// dangerous!!
		var c = untyped container.firstChild().nextSibling();
		grid = untyped c.firstChild();
		c = untyped grid.firstChild();
		swatch = untyped c.firstChild();
		input = untyped c.firstChild().nextSibling();

		c = untyped grid.getChildByName("Container6");
		ok = untyped c.firstChild();
		cancel = untyped c.firstChild().nextSibling();

		//
		spectrum = cast container.firstChild();
		spectrum.minSize = new Size(150,220);
		// spectrum.maxSize = spectrum.minSize;


			var arrow = new Arrow(container, "topArrow");
			arrow.init({width: 7, height: 7, color: Color.BLACK});
			arrow.moveTo(75, 5);
			arrow.rotation = 90;

			arrow = new Arrow(container, "bottomArrow");
			arrow.init({width: 7, height: 7, color: Color.BLACK});
			arrow.moveTo(75, 220+14);
			arrow.rotation = -90;

			var arrow = new Arrow(container, "leftArrow");
			arrow.init({width: 7, height: 7, color: Color.BLACK});
			arrow.moveTo(5,110);
			arrow.rotation = 0;

			var arrow = new Arrow(container, "rightArrow");
			arrow.init({width: 7, height: 7, color: Color.BLACK});
			arrow.moveTo(150+17,110);
			arrow.rotation = 180;


		// var self = this;
		// var spec = spectrum;
		// spectrum.addEventListener(Event.COMPLETE,
		// function(e) {
		// 	spec.graphics.lineStyle(4, self.color.darken(10));
		// 	spec.graphics.beginFill(Color.WHITE);
		// 	spec.graphics.drawRect(0,0,spec.width,spec.height);
		// 	spec.graphics.endFill();
		// 	spec.scrollRect = new Size(spec.width, spec.height).toRect();
		// 	spec.setChildIndex(spec.bitmap, 0);

		// 	var arrow = new Arrow(self.container, "topArrow", .5*spec.width, 5);
		// 	arrow.init({rotation: 90, width: 7, height: 7, color: Color.BLACK});

		// 	arrow = new Arrow(self.container, "bottomArrow", .5*spec.width, spec.height+14);
		// 	arrow.init({rotation: -90, width: 7, height: 7, color: Color.BLACK});

		// 	var arrow = new Arrow(self.container, "leftArrow", 5, .5*spec.height);
		// 	arrow.init({rotation: 0, width: 7, height: 7, color: Color.BLACK});

		// 	var arrow = new Arrow(self.container, "rightArrow", spec.width+17, .5*spec.height);
		// 	arrow.init({rotation: 180, width: 7, height: 7, color: Color.BLACK});
		// }
		// );

		spectrum.filters = [new DropShadowFilter (4, -235, DefaultStyle.DROPSHADOW, .5, 4, 4, .75, BitmapFilterQuality.HIGH,true,false,false)];

		spectrum.addEventListener(MouseEvent.MOUSE_DOWN, onMouseMoveImage, false, 0, true);
		spectrum.addEventListener(MouseEvent.MOUSE_UP, onMouseUpImage, false, 0, true);
		spectrum.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveImage, false, 0, true);
		marker = new Component(spectrum, "marker");
		marker.init();
		marker.filters = [new DropShadowFilter (2, 45, DefaultStyle.DROPSHADOW, 0.5,2, 2,0.5,BitmapFilterQuality.LOW,false,false,false)];
		marker.mouseEnabled = false;//
/*
		//
		grid = new Grid(container, "Grid", 200, 20);
		grid.init({height: 200, rows: 6, cols: 2});

		//
		swatch =  new Swatch(grid);
		swatch.init({color: this.color, _color: currentColor});

		//
		input = new Input(grid, "Input");
		input.init({height: 30});
		input.tf.text = currentColor.toHex();
		input.tf.y += 4;

		//
		for(i in 1...5)	{

			var isAlpha = i==4;

			//
			var slider = new Slider(grid, "Slider"+i);
			slider.init({
				width: 196,
				min: 0,
				max: isAlpha ? 1 : 0xFF,
				step: isAlpha ? .1 : 1,
				showToolTip: false,
				color: this.color
			});
			switch(i) {
				case 1: slider.handle.x = rgb.r;
				case 2: slider.handle.x = rgb.g;
				case 3: slider.handle.x = rgb.b;
				case 4: slider.handle.x = currentAlpha*172;
			}

			//
			var stepper = new Stepper(grid, "Stepper"+i);
			stepper.init({
				value: isAlpha ? 1 : 0,
				step: isAlpha ? .01 : 1,
				page: isAlpha? .1 : 5,
				max: isAlpha ? 1 : 0xFF,
				color: this.color,
				repeatsPerSecond: 10
			});

			//
			var me = this;
			var sliderToStepper = function(e) {
				if(isAlpha)
				stepper.adjustment.object.value = e.target.getValue()/slider.box.width;
				else
				stepper.adjustment.object.value = Std.int(255*e.target.getValue()/slider.box.width);

				stepper.adjustment.adjust(stepper.adjustment.object);
				me.updateColor();
			}

			slider.adjustment.addEventListener(Event.CHANGE, sliderToStepper);

			var stepperToSlider = function(e) {
				slider.adjustment.removeEventListener(Event.CHANGE, sliderToStepper);
				slider.adjustment.setValue(slider.box.width*e.target.getValue()/255);
				slider.adjustment.addEventListener(Event.CHANGE, sliderToStepper);
				// me.updateColor();
			}

			stepper.adjustment.addEventListener(Event.CHANGE, stepperToSlider);

			slider.adjustment.addEventListener(Event.CHANGE, function(e:Event) { me.updateColor(); });
			stepper.adjustment.addEventListener(Event.CHANGE, function(e:Event) { me.updateColor(); });
		}

		this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
*/

		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));


	}
	//}}}


	//{{{ onResize
	public override function onResize (e:ResizeEvent) {
		super.onResize(e);

		// if(container==null) return;
		// container.box = box.clone();
		// container.dirty = true;
	}
	//}}}


	//{{{ onMouseUpImage
	public  function onMouseUpImage(e:MouseEvent) {
		if(e.target.hitTestObject( CursorManager.getInstance()._mc ))
		CursorManager.setCursor(Cursor.HAND);
	}

	//}}}

	//{{{ onMouseMoveImage
	public function onMouseMoveImage(e:MouseEvent) {

		if(!Std.is(e.target, Image) || !e.buttonDown ) return;

		var arrow = container.getChildByName("topArrow");
		arrow.x = e.localX + 10;

		arrow = container.getChildByName("bottomArrow");
		arrow.x = e.localX + 10;

		arrow = container.getChildByName("leftArrow");
		arrow.y = e.localY + 10;

		arrow = container.getChildByName("rightArrow");
		arrow.y = e.localY + 10;

		var ix = Std.int(e.localX);
		var iy = Std.int(e.localY);

		marker.graphics.clear();
		marker.graphics.lineStyle(2, Color.WHITE);
		marker.graphics.beginFill(Color.WHITE, .1);
		marker.graphics.drawCircle(e.localX,e.localY,10);
		marker.graphics.endFill();
		marker.graphics.moveTo(e.localX-1, e.localY);
		marker.graphics.lineTo(e.localX+1, e.localY);
		marker.graphics.moveTo(e.localX, e.localY-1);
		marker.graphics.lineTo(e.localX, e.localY+1);

		marker.toFront();

		CursorManager.setCursor(Cursor.CROSSHAIR);
		//~ trace(e.target.getChildAt(0).bitmapData.getPixel(e.localX, e.localY));
		//~ currentColor = (cast spectrum.getChildAt(0)).bitmapData.getPixel(e.localX, e.localY);
		currentColor = spectrum.bitmap.bitmapData.getPixel(ix, iy);


		var cc = currentColor.toRGB();
		// var w = untyped grid.getChildByName("Slider1").box.width;

		// untyped grid.getChildByName("Slider1").handle.x = cc.r/255*w ;
		// untyped grid.getChildByName("Slider2").handle.x = cc.g/255*w ;
		// untyped grid.getChildByName("Slider3").handle.x = cc.b/255*w ;


		// untyped grid.getChildByName("Slider1").adjustment.object.value = cc.r;
		// untyped grid.getChildByName("Slider1").adjustment.adjust(grid.getChildByName("Slider1").adjustment.object);

		// untyped grid.getChildByName("Slider2").adjustment.object.value = cc.g ;
		// untyped grid.getChildByName("Slider2").adjustment.adjust(grid.getChildByName("Slider2").adjustment.object);

		// untyped grid.getChildByName("Slider3").adjustment.object.value = cc.b ;
		// untyped grid.getChildByName("Slider3").adjustment.adjust(grid.getChildByName("Slider3").adjustment.object);

		updateColor();

	}
	//}}}


	//{{{ updateColor
	public function updateColor() {
		// var r =  untyped grid.getChildByName("Slider1").adjustment.getValue();
		// var g =  untyped grid.getChildByName("Slider2").adjustment.getValue();
		// var b =  untyped grid.getChildByName("Slider3").adjustment.getValue();
		// var a =  untyped grid.getChildByName("Stepper4").adjustment.getValue();

		// currentColor = Color.rgb(r, g, b);
		// currentAlpha = a;

		redrawSwatch();

		updateInput();

	}

	//}}}

	//{{{ redrawSwatch
	public function redrawSwatch() {
		swatch._color = currentColor;
		swatch.redraw();
	}
	//}}}

	//{{{ updateInput
	public function updateInput() {
		input.tf.text = currentColor.toHex();
	}

	//}}}

	//{{{ destroy
	public override function destroy() {

		if(spectrum.hasEventListener(MouseEvent.MOUSE_UP))
		spectrum.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpImage);

		if(spectrum.hasEventListener(MouseEvent.MOUSE_MOVE))
		spectrum.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveImage);

		super.destroy();
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(ColorPicker);
	}
	//}}}
	//}}}
}
//}}}
