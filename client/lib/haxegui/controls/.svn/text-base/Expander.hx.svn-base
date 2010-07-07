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


//Imports {{{
import feffects.Tween;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import haxegui.XmlParser;
import haxegui.controls.AbstractButton;
import haxegui.controls.Image;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.FocusManager;
import haxegui.managers.StyleManager;
import haxegui.toys.Arrow;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


//{{{ ExpanderStyle
enum ExpanderStyle {
	ARROW;
	ICON;
	BOX;
	ARROW_AND_ICON;
	ARROW_AND_BOX;
}
//}}}


//{{{ ExpanderButton
/**
* ExpanderButton
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
**/
class ExpanderButton extends AbstractButton {
	/** Arrow **/
	public var arrow		 : Arrow;

	/** Expanded state icon **/
	public var expandedIcon  : Icon;

	/** Collapsed state icon **/
	public var collapsedIcon : Icon;

	//{{{ init
	public override function init(?opts:Dynamic=null) {
		super.init(opts);
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(ExpanderButton);
	}
	//}}}
}
//}}}


//{{{ Expander
/**
* Expander class, may be expanded or collapsed by the user to reveal or hide child widgets.<br/>
* <p></p>
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
**/
class Expander extends AbstractButton {

	//{{{ Members
	public var style : ExpanderStyle;

	public var expanded(__getExpanded,__setExpanded) : Bool;

	public var button 		: ExpanderButton;

	public var label  		: Label;

	public var scrollTween  : Tween;

	public var arrowTween   : Tween;
	//}}}


	static var styleXml = Xml.parse('
	<haxegui:Style name="Expander">
		<haxegui:controls:Expander>
			<events>
				<script type="text/hscript" action="mouseClick">
				<![CDATA[
				if(this.disabled) return;
				event.stopImmediatePropagation();
				this.__setExpanded(!this.__getExpanded());
				this.dispatchEvent(new flash.events.Event(flash.events.Event.CHANGE));
				]]>
				</script>
			</events>
		</haxegui:controls:Expander>
	</haxegui:Style>
	').firstElement();

	static var layoutXml = Xml.parse('
	<haxegui:Layout name="Expander">
		<haxegui:controls:Label text="{parent.name}"/>
	</haxegui:Layout>
	').firstElement();

	//{{{ Functions
	//{{{ init
	override public function init(opts:Dynamic=null) {
		box = new Size(100, 24).toRect();
		color =  Color.darken(DefaultStyle.BACKGROUND, 16);
		expanded = true;
		style = ExpanderStyle.ICON;


		super.init(opts);

		layoutXml.set("name", name);

		XmlParser.apply(Expander.styleXml, true);
		XmlParser.apply(Expander.layoutXml, this);


		expanded = Opts.optBool(opts, "expanded", expanded);
		var s = Opts.optString(opts, "style", "icon");
		switch(s.toLowerCase()) {
			case "arrow":
			style = ExpanderStyle.ARROW;
			case "icon":
			style = ExpanderStyle.ICON;
			case "arrow_and_icon":
			style = ExpanderStyle.ARROW_AND_ICON;
		}


		label = getElementsByClass(Label).next();
		label.setText(Opts.optString(opts, "label", label.text));
		label.center();
		label.x = Math.max(24, label.x);
		label.mouseEnabled = false;


		button = new ExpanderButton(this);

		switch(style) {
			case ExpanderStyle.ARROW, ExpanderStyle.ARROW_AND_BOX:
			button.arrow = new Arrow(button, 4, 4);
			button.arrow.init({color: Color.darken(DefaultStyle.BACKGROUND, 16)});

			case ExpanderStyle.ICON:
			button.expandedIcon = new Icon(button);
			button.expandedIcon.init({src: Icon.STOCK_FOLDER_OPEN});

			button.collapsedIcon = new Icon(button);
			button.collapsedIcon.init({src: Icon.STOCK_FOLDER});

			button.expandedIcon.visible = expanded;
			button.collapsedIcon.visible = !expanded;

			case ExpanderStyle.ARROW_AND_ICON:
			button.arrow = new Arrow(button);
			button.arrow.init({color: Color.darken(DefaultStyle.BACKGROUND, 16)});
			button.arrow.move(6,6);

			button.expandedIcon = new Icon(button);
			button.expandedIcon.init({src: Icon.STOCK_FOLDER_OPEN});
			button.expandedIcon.move(24,0);

			button.collapsedIcon = new Icon(button);
			button.collapsedIcon.init({src: Icon.STOCK_FOLDER});
			button.collapsedIcon.move(24,0);

			button.expandedIcon.visible = expanded;
			button.collapsedIcon.visible = !expanded;

			label.move(24,0);
		}
	}
	//}}}


	//{{{ Getters/Setters
	//{{{ __getExpanded
	private function __getExpanded() : Bool {
		return this.expanded;
	}
	//}}}


	//{{{ __setExpanded
	private function __setExpanded(v:Bool) : Bool {
		if(v == this.expanded) return v;

		var self = this;
		var r = new Size(this.stage.stageWidth,expanded?this.stage.stageHeight:0).toRect();

		if(scrollTween!=null)
		scrollTween.stop();

		if(!expanded)
		scrollTween = new Tween(box.height, this.stage.stageHeight, 1500, r, "height", feffects.easing.Linear.easeNone);
		else
		scrollTween = new Tween(this.stage.stageHeight, box.height, 500, r, "height", feffects.easing.Expo.easeOut);

		scrollTween.setTweenHandlers( function(v) { self.scrollRect = r; });
		scrollTween.start();

		this.expanded = v;

		switch(style) {
			case ExpanderStyle.ARROW:
			if(this.arrowTween!=null)
			this.arrowTween.stop();
			this.arrowTween = new Tween(expanded?0:90, expanded?90:0, 150, button.firstChild(), "rotation", feffects.easing.Linear.easeNone);
			this.arrowTween.start();


			case ExpanderStyle.ICON :
			if(this.button!=null)
				swapChildrenVisible(button.collapsedIcon, button.expandedIcon);

			case ExpanderStyle.ARROW_AND_ICON:
			if(this.arrowTween!=null)
			this.arrowTween.stop();
			this.arrowTween = new Tween(expanded?0:90, expanded?90:0, 150, button.firstChild(), "rotation", feffects.easing.Linear.easeNone);
			this.arrowTween.start();
			if(this.button!=null)
				swapChildrenVisible(button.collapsedIcon, button.expandedIcon);

		}


		this.dirty = true;
		return v;
	}
	//}}}


	//{{{ __setDisabled
	override private function __setDisabled(v:Bool) : Bool {
		super.__setDisabled(v);
		if(this.disabled) {
			mouseEnabled = false;
			buttonMode = false;
		}
		else {
			mouseEnabled = Opts.optBool(initOpts,"mouseEnabled",true);
			buttonMode = Opts.optBool(initOpts,"buttonMode",true);
		}
		return v;
	}
	//}}}
	//}}}

	//{{{ toggle
	public function toggle() {
		expanded = !expanded;
	}
	//}}}

	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Expander);
	}
	//}}}
	//}}}
}
//}}}
