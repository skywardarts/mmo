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
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import haxegui.controls.AbstractButton;
import haxegui.controls.IAdjustable;
import haxegui.controls.Image;
import haxegui.managers.StyleManager;
import haxegui.toys.Socket;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


//{{{ Button
/**
* A chromed button, with optional label and icon.<br/>
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.26
*/
class Button extends AbstractButton, implements IAdjustable {
	//{{{ Members
	/**
	* Optional label for the button
	*
	* The are several ways to create a button with a label:
	* <ul>
	* <li>Using xml:
	* <pre class="code xml">
	* <haxegui:controls:Button label="button"/></li>
	* </pre>
	* <li>Passing a label to init():
	* <pre class="code haxe">
	* var btn = new Button();
	* btn.init({label: "button"});
	* </pre>
	* </li>
	* <li>Manual creation:
	* <pre class="code haxe">
	* var btn = new Button().init();
	* btn.label = new Label(btn);
	* label.init({innerData: "button"});
	* </pre>
	* </li>
	*</ul>
	* @see Label
	*/
	public var label : Label;


	/**
	* Optional icon for the button
	*
	* The are several ways to create a button with an icon:
	* <ul>
	* <li>Using xml:
	* <pre class="code xml"><haxegui:controls:Button icon="STOCK_NEW"/></pre>
	* </li>
	* <li>Passing an icon to init():
	* <code><pre class="code haxe">
	* var btn = new Button();
	* btn.init({icon: Icon.STOCK_NEW});</pre></code>
	* </li>
	* <li>Manual creation:
	* <pre class="code haxe">var btn = new Button().init();
	* btn.icon = new Icon(btn);
	* icon.init({src: Icon.STOCK_NEW});</pre>
	* </li>
	* </ul>
	*/
	public var icon  : Icon;


	/**
	* when true button will stay pressed when clicked and raise back on the next click.<br/>
	* use the [selected] property to tell if it is pressed or not.
	* @see selected
	**/
	public var toggle : Bool;


	/**
	* true when is pressed.<br/>
	* Notice that when using hscript, [selected] is not available in direct access, use the getter and setter.
	* @see selected
	**/
	public var selected( __getSelected, __setSelected ) : Bool;


	/** slot **/
	public var slot : Socket;


	/** @todo send binary adjustments**/
	public var adjustment : Adjustment;
	//}}}

	//{{{ Functions
	//{{{ init
	override public function init(opts:Dynamic=null) {
		box = new Size(90,30).toRect();
		color = DefaultStyle.BACKGROUND;
		minSize = new Size(24,24);
		mouseChildren = false;


		toggle = Opts.optBool(opts, "toggle", false);
		selected = Opts.optBool(opts, "selected", false);


		super.init(opts);


		// tooltip
		description = Opts.optString(opts, "tooltip", name);


		// Default to a no-label simple button
		if(Opts.optString(opts, "label", null)!=null) {
			label = new Label(this);
			label.init({
			text : Opts.optString(opts, "label", name),
			color: disabled ? Color.darken(DefaultStyle.BACKGROUND,30) : DefaultStyle.LABEL_TEXT
			});
			label.center();
			minSize.width = Std.int(Math.max( minSize.width, label.tf.width ));
		}


		// Default to a no-icon simple button
		if(Opts.optString(opts, "icon", null)!=null) {
			icon = new Icon(this);
			var src = Opts.optString(opts, "icon", null);

			// check for STOCK_ type icon
			if(Reflect.field(Icon, src)!=null)
			src = Reflect.field(Icon, src);

			icon.init({src: src});
			icon.move(4,4);


			if(disabled) {
				var mat = [
				0.3,0.6,0.082,0,0,
				0.3,0.6,0.082,0,0,
				0.3,0.6,0.082,0,0,
				0,  0,0,1,0 ];

				icon.filters = [new flash.filters.ColorMatrixFilter(mat)];
				icon.alpha = .5;
			}
			else {
				icon.filters = [];
				icon.alpha = 1;
			}
		}
	}
	//}}}


	//{{{ __setDisabled
	private override function __setDisabled(b:Bool) : Bool {

		disabled = super.__setDisabled(b);

		if(icon==null) return disabled;

		if(disabled) {
			var mat = [
			0.3,0.6,0.082,0,0,
			0.3,0.6,0.082,0,0,
			0.3,0.6,0.082,0,0,
			0,  0,0,1,0 ];

			icon.filters = [new flash.filters.ColorMatrixFilter(mat)];
			icon.alpha = .5;
		}
		else {
			icon.filters = [];
			icon.alpha = 1;
		}

		if(this.label!=null && this.label.tf!=null) {
		var fmt = DefaultStyle.getTextFormat (8, DefaultStyle.LABEL_TEXT, flash.text.TextFormatAlign.LEFT);
		if (this.disabled) fmt.color = Color.darken(this.color, 24);
		this.label.tf.setTextFormat (fmt);
		}

		redraw();
		dirty = false;
		this.graphics.clear();


		return disabled;
	}
	//}}}


	//{{{ onAdded
	/**
	* This methods makes sure buttons added to a [ToolBar] get a flat look.
	*/
	public override function onAdded(e:Event) {
		// Flat-look for toolbar buttons
		for(a in ancestors())
		if(Std.is(a, haxegui.controls.ToolBar)) {
			redraw();
			dirty = false;
			this.graphics.clear();
			setAction("mouseOut",  "if(!this.disabled) event.target.updateColorTween( new feffects.Tween(event.buttonDown ? -50 : 50, 0, 100, feffects.easing.Expo.easeOut ) );	this.graphics.clear();");
			setAction("mouseUp",   "if(!this.disabled) event.target.updateColorTween( new feffects.Tween(event.buttonDown ? -50 : 50, 0, 100, feffects.easing.Expo.easeOut ) );	this.graphics.clear();");
			setAction("mouseOver", "if(!this.disabled) this.redraw();");
		}
	}
	//}}}


	//{{{ __getSelected
	/** Getter for toggle button state **/
	public function __getSelected() : Bool {
		return selected;
	}
	//}}}


	//{{{ __setSelected
	/** Setter for toggle button state **/
	public function __setSelected(v:Bool) {
		selected = v;
		redraw();
		return selected;
	}
	//}}}


	//{{{ onMouseClick
	/** Click handler, ignores disabled, push\pulls toggles, and clicks normal buttons **/
	public override function onMouseClick(e:flash.events.MouseEvent) {
		if(disabled) return;
		if(toggle)
		selected = !selected;
		super.onMouseClick(e);
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Button);
	}
	//}}}
	//}}}
}
//}}}


//{{{ PushButton
/**
* Alias for a [Button] with toggle=true
**/
class PushButton extends Button {
	//{{{ init
	override public function init(opts:Dynamic=null) {
		if(opts==null) opts = {};
		Reflect.setField(opts, "toggle", true);
		super.init(opts);
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(PushButton);
	}
	//}}}

}
//}}}


//{{{ Swatch
/**
* Button with a color sprite, opens a color picked on click<br/>
**/
class Swatch extends Button {

	public var sprite : Sprite;
	public var _color: UInt;

	//{{{ init
	override public function init(opts:Dynamic=null) {
		if(opts==null) opts = {};
		Reflect.setField(opts, "toggle", true);

		_color = Opts.optInt(opts, "_color", color);

		super.init(opts);


		sprite = new Sprite();
		sprite.filters = [new flash.filters.DropShadowFilter (2, 45, DefaultStyle.DROPSHADOW, 0.5, 2, 2, 0.5, flash.filters.BitmapFilterQuality.HIGH, true, false, false )];

		addChild(sprite);
	}
	//}}}

	public override function redraw(?opts:Dynamic) {
		super.redraw(opts);
		if(sprite==null) return;
		sprite.graphics.clear();
		sprite.graphics.lineStyle(1, Color.darken(color, 20), 1, flash.display.LineScaleMode.NONE);
		sprite.graphics.beginFill(_color);
		sprite.graphics.drawRect(4,4,box.width-8, box.height-8);
		sprite.graphics.endFill();
	}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(PushButton);
	}
	//}}}

}
//}}}
