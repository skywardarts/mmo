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
import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextField;
import haxegui.Window;
import haxegui.containers.Container;
import haxegui.containers.Divider;
import haxegui.containers.ScrollPane;
import haxegui.containers.Grid;
import haxegui.controls.CheckBox;
import haxegui.controls.Component;
import haxegui.controls.Image;
import haxegui.controls.Input;
import haxegui.controls.Label;
import haxegui.controls.MenuBar;
import haxegui.controls.Stepper;
import haxegui.controls.Tree;
import haxegui.controls.UiList;
import haxegui.events.DataEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.FocusManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Size;
import haxegui.windowClasses.StatusBar;
//}}}


using haxegui.controls.Component;
using haxegui.utils.Color;


/**
*
* Introspector class
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.2
*/
class Introspector extends Window {

	//{{{ Members
	public var container 	: Container;
	public var treePane 	: ScrollPane;
	// public var listPane 	: ScrollPane;
	public var textPane 	: ScrollPane;
	public var hdivider 	: Divider;
	public var vdivider 	: Divider;
	public var hbox			: HBox;
	public var tree 		: Tree;
	public var list1 		: UiList;
	public var list2 		: UiList;

	public var tf			: TextField;

	/** the inspected component **/
	public var target : Component;

	public static var props = {
		alpha					: "alpha",
		box						: "box",
		description				: "description",
		filters					: "filters",
		initOpts				: "initOpts",
		height					: "height",
		name 					: "name",
		parent 					: "parent",
		visible					: "visible",
		width					: "width",
		x						: "x",
		y						: "y",
		scaleX					: "scaleX",
		scaleY					: "scaleY",
	}

	public static var dirtyProps = [ "color", "width", "height" ];


	static var xml = Xml.parse('
	<haxegui:Layout name="Introspector">
		<haxegui:controls:MenuBar x="10" y="20"/>
		<haxegui:containers:Container name="Container" x="10" y="40">
			<haxegui:containers:HDivider name="HDivider">
			<haxegui:containers:VDivider name="VDivider">

			<haxegui:containers:ScrollPane>
			<haxegui:controls:Tree fitH="true"/>
			</haxegui:containers:ScrollPane>

			<haxegui:containers:HBox cellSpacing="0" width="300" fit="true">
			<haxegui:controls:UiList/>
			<haxegui:controls:UiList/>
			</haxegui:containers:HBox>

			</haxegui:containers:VDivider>
			<haxegui:containers:ScrollPane/>
			</haxegui:containers:HDivider>
		</haxegui:containers:Container>
		<haxegui:windowClasses:StatusBar/>
	</haxegui:Layout>
	').firstElement();
	//}}}


	//{{{ Functions
	//{{{ init
	public override function init(?opts:Dynamic) {
		super.init(opts);


		box = new Size(640, 500).toRect();

		xml.set("name", name);

		XmlParser.apply(Introspector.xml, this);


		//
		container = cast this.getChildByName("Container");

		//
		hdivider = cast container.getChildByName("HDivider");

		//
		vdivider = cast hdivider.getChildByName("VDivider");


		//
		// textPane = new ScrollPane(vdivider, "textPane");
		// textPane.init();
		textPane = cast hdivider.firstChild().asComponent().nextSibling();

		tf = new flash.text.TextField();
		tf.wordWrap = false;
		tf.multiline = true;
		tf.width = vdivider.box.width;
		tf.height = vdivider.box.height;
		tf.autoSize = flash.text.TextFieldAutoSize.NONE;
		tf.background = true;
		// tf.backgroundColor = Color.WHITE;
		tf.backgroundColor = Color.tint(Color.GREEN, .13);
		tf.text = Introspector.xml.toString();
		textPane.addChild(tf);
		textPane.vert.scrollee=tf;
		textPane.horz.scrollee=tf;

		textPane.addEventListener(ResizeEvent.RESIZE, onTextPaneResized, false, 0, true);


		//
		treePane = cast vdivider.firstChild();

		//
		tree = cast treePane.content.getChildAt(0);

		var o = {};
		for(i in 0...(cast root).numChildren)
		if(Std.is((cast root).getChildAt(i), DisplayObjectContainer))
		Reflect.setField(o, (cast root).getChildAt(i).name,  reflectDisplayObjectContainer((cast root).getChildAt(i)));

		tree.process(o, tree.rootNode);

		//
		// listPane = new ScrollPane(hdivider, "listPane");
		// listPane.init({});

		//
		// hbox = new HBox(listPane, "HBox");
		hbox = cast vdivider.firstChild().asComponent().nextSibling();
		// hbox.init({});

		//
		// list1 = new UiList(hbox, "Properties");
		// list1.init();
		list1 = cast hbox.firstChild();
		list2 = cast hbox.firstChild().asComponent().nextSibling();

		//
		// list2 = new UiList(hbox, "Values");
		// list2.init();

		list1.dataSource = new DataSource();
		list1.dataSource.data = Reflect.fields(props);

		list2.dataSource = new DataSource();
		list2.dataSource.data = [];
		for(i in Reflect.fields(props)) list2.dataSource.data.push("N/A");


		/*
		//
		statusbar = new StatusBar(this, "StatusBar", 10, 360);
		statusbar.init();


		// treePane.addEventListener(ResizeEvent.RESIZE, onResize, false, 0, true);
		// listPane.addEventListener(ResizeEvent.RESIZE, onResize, false, 0, true);
		// textPane.addEventListener(ResizeEvent.RESIZE, onResize, false, 0, true);
		// treePane.addEventListener(ResizeEvent.RESIZE, tree.onParentResize, false, 0, true);

		*/
		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));

		this.stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, onFocusChanged, false, 0, true);
	}
	//}}}


	public function onTextPaneResized(e:ResizeEvent) {
		tf.width = textPane.box.width;
		tf.height = Math.max( tf.height, textPane.box.height );
	}


	//{{{ onFocusChanged
	public function onFocusChanged(e:Dynamic) {
		if(e == this) return;
		if(!Std.is(e, flash.events.Event)) return;
		if(!Std.is(e.target, Component)) return;
		if(this.contains(e.target)) return;
		if(e.target==target) return;
		target = e.target;

		// trace(this+" inspecting: "+target);

		var self = this;


		if(Std.is(e.target, Component)) {
			Reflect.setField(props, "id", "id");
			Reflect.setField(props, "disabled", "disabled");
			Reflect.setField(props, "color", function(e) { return "0x"+StringTools.hex(e.target.color,6); });
			Reflect.setField(props, "focusable", "focusable");
			Reflect.setField(props, "dirty", "dirty");
			Reflect.setField(props, "box", "box");
		}


		var d1 = new DataSource();
		var d2 = new DataSource();

		d1.data = [];
		d2.data = [];

		for(key in Reflect.fields(props)) {

			//
			d1.data.push(key);

			//
			if(Reflect.isFunction(Reflect.field(props, key)))
			d2.data.push( Reflect.callMethod(props, Reflect.field(props, key), [e]) );
			else {
				var value = Reflect.field( target, Reflect.field(props, key));
				d2.data.push( value );
			}
		}

		list1.dataSource = d1;
		list2.dataSource = d2;

		for( i in list2)
		if(Std.is(i, ListItem)) {
			// replace label with input
			i.asComponent().setAction("mouseClick",
			"
			if(this.numChildren==2) return;
			this.label.visible=false;
			if(Std.is(this.data, Bool)) {
				var chkbox = new haxegui.controls.CheckBox(this);
				chkbox.init();
				checkbox.__setSelected(this.data);
			}
			else
			if(Std.is(this.data, Int)) {
				var step = new haxegui.controls.Stepper(this);
				step.init();
				step.left = 0;
				step.right = 0;
				step.top = 0;
				step.bottom = 0;
				step.box.width = this.box.width-10;
				step.input.box.width = this.box.width-10;
				step.input.dirty=true;
				step.adjustment.setValue(Std.parseInt(this.label.getText()));
			}
			else {
				var input = new haxegui.controls.Input(this);
				input.init();
				input.box.width = this.box.width;
				input.setText(this.label.getText());
			}
			this.dispatchEvent(new haxegui.events.ResizeEvent(events.ResizeEvent.RESIZE));
			");

			// and back to label
			i.asComponent().setAction("focusOut",
			"
			if(focusTo==this || this.contains(focusTo)) return;
			if(this.numChildren==2) {

				if(Std.is(this.getChildAt(1), controls.Input)) {
					this.data = this.getChildAt(1).getText();
					this.label.setText(this.getChildAt(1).getText());
				}
				else
				if(Std.is(this.getChildAt(1), controls.CheckBox)) {
					this.data = this.getChildAt(1).__getSelected();
					this.label.setText(Std.string(this.getChildAt(1).__getSelected()));
				}
				else
				if(Std.is(this.getChildAt(1), controls.Stepper)) {
					this.data = this.getChildAt(1).adjustment.getValue();
					this.label.setText(this.getChildAt(1).adjustment.valueAsString());
				}


				this.getChildAt(1).destroy();
				this.getChildAt(0).visible = true;

				var item1 = parent.parent.firstChild().getChildAt(parent.getChildIndex(this));
				var introspector = this.getParentWindow();
				Reflect.setField(introspector.target, item1.label.getText(), this.data);
				// Reflect.setField(introspector.target, item1.label.getText(), this.label.getText());

				if(Lambda.has(Introspector.dirtyProps, item1.label.getText()))
				// introspector.target.dirty = true;
				introspector.target.redraw();
			}
			");

		}


		// tree.destroy();
		// tree = new Tree(treePane.content);
		// tree.init();
		tree.rootNode.removeItems();
		var node = new TreeNode(tree.rootNode.expander, target.name);
		node.move(24,24);
		node.init();

		tree.rootNode.expander.expanded = true;

		var t = target;

		var o = {};
		for(i in 0...t.numChildren)
		if(Std.is((cast t).getChildAt(i), DisplayObjectContainer))
		Reflect.setField(o, (cast t).getChildAt(i).name,  reflectDisplayObjectContainer((cast t).getChildAt(i)));


		tree.process(o, node);



		var xml = Reflect.field(Type.getClass(target), "layoutXml");
		var txt = xml!=null ? Std.string(xml) : Std.string(target);

		var styles = new flash.text.StyleSheet();
		styles.parseCSS(".code-line-numbers {    color:#809080;    border-right:1px dotted #809080;    float:left;    text-align:right;    width:2em;    padding-right:3px;    margin-right:12px;}.code-code {}.code-keyword {    font-weight: bold;    color: #000000;}.code-type {    font-weight: bold;    color: #106020;}.code-variable {    color: #004050;}.code-number {    color: #F08000;}.code-comment {    color: #208000;}.code-string {    color: #F00000;}");
		tf.styleSheet = styles;
		tf.text = CodeHighlighter.highlight( txt, "xml") ;


		dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));

	}
	//}}}


	//{{{ onResize
	public override function onResize(e:ResizeEvent) {

		super.onResize(e);
	} //}}}


	//{{{ destroy
	public override function destroy() {
		this.stage.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, onFocusChanged);
		super.destroy();
	}
	//}}}


	//{{{ reflectDisplayObjectContainer
	public function reflectDisplayObjectContainer(d:DisplayObjectContainer) : Dynamic {
		if(d==null) return;
		var o = {};
		for(i in 0...d.numChildren) {
			var child = d.getChildAt(i);
			if(child==null) return child;
			if (
				Std.is(child, flash.display.Bitmap) ||
				Std.is(child, flash.display.BitmapData) ||
				Std.is(child, flash.display.Shape) ||
				Std.is(child, flash.text.TextField)
				) {
					var o2 = {};
					Reflect.setField( o2, child.name, child.name );
					// Reflect.setField( o, child.name, o2 );
				return o2;
				}


			// if(Std.is(child, DisplayObjectContainer)
			Reflect.setField( o, child.name, reflectDisplayObjectContainer(cast child) );
		}
		return o;
	}
	//}}}
	//}}}
}
