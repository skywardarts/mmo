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

package haxegui.toys;

//{{{ Imports
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxegui.controls.Component;
import haxegui.controls.IAdjustable;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


/**
 * A LCD 7-Segment like digit box widget.<br/>
 *
 */
class SevenSegment extends Component, implements IAdjustable
{
	//{{{ Members
	public var digitColor : UInt;
	public var digit(default, setDigit) : UInt;

	public var slot : Socket;

	/** Adjustment object **/
	public var adjustment : Adjustment;

	//     a
	//    ---
	// f | g | b
	//    ---
	// e | d | c
	//    ---
	//
	// abcdefg
	// 1111110 = 0x7e (zero)
	// 0110000 = 0x30 (one)
	// and so forth...
	/** Array for 8bit hex values corresponding digit **/
	static var pattern : Array<UInt> = [
		0x0, //none
		0x7e,//zero
		0x30,//one
		0x6d,//two
		0xf9,//three
		0x33,//four
		0x5b,//five
		0x5f,//six
		0x70,//seven
		0x7f,//eight
		0x7b //nine
	];
	//}}}


	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic=null) {
		box = new Size(70,100).toRect();
		color = Color.rgb(0,60,0);
		digitColor = Color.GREEN;
		digit = 0;
		adjustment = new Adjustment({ value: digit, min: 0, max: 9, step: 1, page: 2});

		super.init(opts);

		digit = Opts.optInt(opts, "digit", digit);
		//~ color = Opts.optInt(opts, "color", color);
		digitColor = Opts.optInt(opts, "digitColor", digitColor);

		setAction("redraw",
		"
		this.graphics.clear();

		var a = this.box.height/7;

		var bit = toys.SevenSegment.pattern[this.digit+1];

		this.graphics.lineStyle(1, Color.darken(this.color, 20));

		this.graphics.beginFill(Color.darken(this.color, 10));
		this.graphics.drawRoundRect(0,0,this.box.width, this.box.height, a, a);
		this.graphics.endFill();



		// horizontal
		//a
		this.graphics.beginFill( (bit&0x40==0) ? this.color : this.digitColor );
		this.graphics.drawRoundRect(a,0,this.box.width-2*a, a, a, a);
		this.graphics.endFill();
		//g
		this.graphics.beginFill( (bit&0x01==0) ? this.color : this.digitColor );
		this.graphics.drawRoundRect(a,3*a,this.box.width-2*a, a, a, a);
		this.graphics.endFill();
		//d
		this.graphics.beginFill( (bit&0x08==0) ? this.color : this.digitColor );
		this.graphics.drawRoundRect(a,6*a,this.box.width-2*a, a, a, a);
		this.graphics.endFill();

		// vertical
		//f
		this.graphics.beginFill( (bit&0x02==0) ? this.color : this.digitColor );
		this.graphics.drawRoundRect(0, 0, a, 3.5*a, a, a);
		this.graphics.endFill();
		//b
		this.graphics.beginFill( (bit&0x20==0) ? this.color : this.digitColor );
		this.graphics.drawRoundRect(this.box.width-a, 0, a, 3.5*a, a, a);
		this.graphics.endFill();
		//e
		this.graphics.beginFill( (bit&0x04==0) ? this.color : this.digitColor );
		this.graphics.drawRoundRect(0,3.5*a,a, this.box.height-3.5*a, a, a);
		this.graphics.endFill();
		//c
		this.graphics.beginFill( (bit&0x10==0) ? this.color : this.digitColor );
		this.graphics.drawRoundRect(this.box.width-a,3.5*a,a, this.box.height-3.5*a, a, a);
		this.graphics.endFill();


		"
		);

		this.filters = [new flash.filters.DropShadowFilter (4, 45, DefaultStyle.DROPSHADOW, 0.25, 4, 4, 0.5, flash.filters.BitmapFilterQuality.HIGH, false, false, false )];

		setAction("interval", "if(this.digit>=9) this.adjustment.setValue(0) else this.adjustment.setValue(this.digit+1);");
		setAction("mouseWheel", "if(this.digit>=9 && event.delta>0) this.adjustment.setValue(0) else if(this.digit<=0 && event.delta<0) this.adjustment.setValue(9) else this.adjustment.setValue(this.digit+event.delta);");
		//~ startInterval(2);


		slot = new haxegui.toys.Socket(this);
		slot.init({radius: 6});
		slot.moveTo(Std.int(this.box.width)>>1-20, -20);
		// slot.moveTo(Std.int(this.box.width)>>1-6, this.box.height+10);

		adjustment.addEventListener (Event.CHANGE, onChanged, false, 0, true);

	}
	//}}}


	//{{{ setDigit
	public function setDigit(d:UInt) : UInt {
		digit = d;
		redraw();
		return d;
	}
	//}}}


	//{{{ onChanged
	public function onChanged(e:Event) {
		setDigit(Std.int(adjustment.getValue()));
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(SevenSegment);
	}
	//}}}
	//}}}
}
