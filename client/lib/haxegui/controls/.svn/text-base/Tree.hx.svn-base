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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.DataSource;
import haxegui.controls.Component;
import haxegui.controls.Expander;
import haxegui.controls.Image;
import haxegui.events.DragEvent;
import haxegui.events.ResizeEvent;
import haxegui.events.TreeEvent;
import haxegui.managers.CursorManager;
import haxegui.managers.DragManager;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
import haxegui.XmlParser;
//}}}


using haxegui.controls.Component;


//{{{ Tree Leaf
/**
*
* TreeLeaf class
*
*
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class TreeLeaf extends Component, implements IAggregate, implements IData {

	/** Leaf icon **/
	public var icon : Icon;
	/** Defaults to the name property **/
	public var label : Label;

	public var data : Dynamic;

	public var selected : Bool;


	static var styleXml = Xml.parse('
	<haxegui:Style name="TreeLeaf">
	<haxegui:controls:TreeLeaf>
	<events>
	<script type="text/hscript" action="mouseClick"><![CDATA[
	this.selected = !this.selected;
	this.color = this.selected ? DefaultStyle.FOCUS : DefaultStyle.INPUT_BACK;
	this.redraw();
	return;
	]]>
	</script>
	</events>
	</haxegui:controls:TreeLeaf>
	</haxegui:Style>
	').firstElement();

	static var layoutXml = Xml.parse('
	<haxegui:Layout name="TreeLeaf">
	<haxegui:controls:Icon x="22" y="2"/>
	<haxegui:controls:Label x="24" y="2" text="{parent.name}"/>
	</haxegui:Layout>
	').firstElement();

	//{{{ init
	override public function init(opts:Dynamic=null) {
		box = new Size(140,24).toRect();
		color = DefaultStyle.INPUT_BACK;
		// icon = null;

		super.init(opts);

		layoutXml.firstElement().set("src", Opts.optString(opts, "icon", Icon.STOCK_DOCUMENT));

		layoutXml.set("name", name);

		XmlParser.apply(TreeLeaf.layoutXml, this);
		XmlParser.apply(TreeLeaf.styleXml, true);

		// label = new Label(this);
		// label.init({text: this.name});
		// label.move(48, 4);
		label = getElementsByClass(Label).next();
		label.setText(Opts.optString(opts, "label", name));

		// icon = new Icon(this, 24, 4);
		// icon.init ({src: Opts.optString(opts, "icon", Icon.STOCK_DOCUMENT) });

	}
	//}}}


	//{{{ onMouseClick
	public override function onMouseClick(e:MouseEvent) {
		if(disabled) return;

		e.stopImmediatePropagation();

		super.onMouseClick(e);
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(TreeLeaf);
	}
	//}}}

}
//}}}


//{{{ TreeNode
/**
* Expandable tree node<br/>
*
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class TreeNode extends Component, implements IAggregate, implements IData {

	public var expander : Expander;

	public var expanded : Bool;

	public var selected : Bool;
	public var selectable : Bool;

	public var data : Dynamic;

	static var layoutXml = Xml.parse('
	<haxegui:Layout name="TreeNode">
	<haxegui:controls:Expander label="{parent.name}" style="arrow_and_icon" expanded="false"/>
	</haxegui:Layout>
	').firstElement();

	static var styleXml = Xml.parse('
	<haxegui:Style name="TreeNode">
	<haxegui:controls:TreeNode>
	<events>
	<script type="text/hscript" action="mouseClick"><![CDATA[
	event.stopImmediatePropagation();
	if(event.target==this) {
		this.selected = !this.selected;
		this.color = this.selected ? DefaultStyle.FOCUS : DefaultStyle.INPUT_BACK;
		this.redraw();
		return;
	}

	this.expander.__setExpanded(!this.expander.__getExpanded());

	if(this.expander.expanded)
	this.expand();
	else
	this.collapse();

	for(i in 2...this.expander.numChildren)
	this.expander.getChildAt(i).visible = this.expander.expanded;

	]]>
	</script>
	</events>
	</haxegui:controls:TreeNode>
	</haxegui:Style>
	').firstElement();

	//{{{ init
	override public function init(opts:Dynamic=null) {
		haxegui.Profiler.begin(here.className.split(".").pop()+"."+here.methodName);

		color = DefaultStyle.INPUT_BACK;
		box = new Size(140, 24).toRect();


		super.init(opts);

		layoutXml.set("name", name);

		XmlParser.apply(TreeNode.styleXml, true);
		XmlParser.apply(TreeNode.layoutXml, this);

		expander = cast firstChild();

		expander.label.mouseEnabled = true;
		expander.removeEventListener(MouseEvent.CLICK, expander.onMouseClick);

		expander.button.arrow.resize(new Size(8,8));
		expander.label.setText(Opts.optString(opts, "label", name));

		parent.addEventListener(ResizeEvent.RESIZE, onParentResize, false, 0, true);

		haxegui.Profiler.end();
	}
	//}}}

	//{{{ empty
	public function empty() {
		return expander.numChildren<=2;
	}
	//}}}


	//{{{ removeItems
	public function removeItems() {
		for(i in expander)
		if(!Std.is(i, Label) && !Std.is(i, ExpanderButton))
		// expander.removeChild(i);
		i.asComponent().destroy();

		// expander.expanded = false;
	}
	///}}}


	//{{{ addChild
	public override function addChild(o:DisplayObject) : DisplayObject {
		if(expander==null) return super.addChild(o);
		var c = expander.addChild(o);
		if(Std.is(c, TreeNode)) {
			c.addEventListener(TreeEvent.ITEM_OPENING, onChildClicked, false, 0, true);
		}
		return c;
	}
	//}}}


	//{{{ onChildClicked
	public function onChildClicked(e:TreeEvent) {
		var i = parent.getChildIndex(this) + 1;
		if(parent.numChildren<i) return;

		var v = expander.getVisibleChildren().length;
		if(expander.label!=null) v--;
		if(expander.button!=null) v--;
		var h = 24*v;

		for(j in i...parent.numChildren) {
			parent.getChildAt(j).y += (e.type==TreeEvent.ITEM_OPENING?1:-1)*h;
		}

		parentTree(this).box.height += (e.type==TreeEvent.ITEM_OPENING?1:-1)*h;
		parentTree(this).dirty = true;

		// for(a in ancestors())
		// if(Std.is(a, TreeNode)) { a.dispatchEvent(e); break; }
	}
	//}}}


	//{{{ getChildIndex
	public override function getChildIndex(o:DisplayObject) : Int {
		if(expander==null) return super.getChildIndex(o);
		return expander.getChildIndex(o);
		// return super.addChild(o);
	}
	//}}}


	//{{{ onParentResize
	public  function onParentResize(e:ResizeEvent) : Void {
		if(parent==null || parent.asComponent().box==null) return;
		box.width = parent.asComponent().box.width;
		expander.box = box.clone();
		for(i in expander) {
			i.asComponent().box.width = box.width;
			i.asComponent().dirty=true;
		}
		dirty = true;
	}
	//}}}


	//{{{ expand
	public function expand() {
		var h = 24*(this.expander.numChildren-2);
		var i = parent.getChildIndex(this) + 1;
		for(j in i...parent.numChildren)
		parent.getChildAt(j).y += h;

		dispatchEvent(new TreeEvent(TreeEvent.ITEM_OPENING));
		this.parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ collapse
	public function collapse() {
		var i = parent.getChildIndex(this) + 1;
		for(j in i...parent.numChildren)
		parent.getChildAt(j).y = 24*j - 24;

		dispatchEvent(new TreeEvent(TreeEvent.ITEM_CLOSING));
		this.parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
	}
	//}}}


	//{{{ getPath
	public function getPath() : Array<Dynamic>{
		var nodes : Array<Dynamic> = [this.expander.label.getText()];
		for(a in ancestors()) {
			if(Std.is(a, Tree)) break;
			if(Std.is(a, TreeNode))
			nodes.push(untyped a.expander.label.getText());
		}
		nodes.reverse();
		return nodes;
	}
	//}}}


	//{{{ parentTree
	public static function parentTree(node:TreeNode) : Tree {
		for(a in node.ancestors())
		if(Std.is(a, Tree)) return cast a;
		return null;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(TreeNode);
	}
	//}}}

}
//}}}


//{{{ Tree
/**
*
* Tree Class
*
* @version 0.2
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*
*/
class Tree extends Component, implements IDataSource {
	public var dataSource(default, setDataSource) : DataSource;

	/** A list of selected items on the tree **/
	public var selected 	  	: List<DisplayObject>;

	public var expandedNodes  	: List<TreeNode>;
	public var collapsedNodes 	: List<TreeNode>;

	public var rootNode 		: TreeNode;
	/**
	* Set to [true] to show the root node
	* @todo showRoot
	*/
	public var showRoot 		: Bool;

	//{{{ Functions
	//{{{ init
	override public function init(?opts:Dynamic=null) {
		box = new Size(140,24).toRect();
		color = DefaultStyle.INPUT_BACK;
		collapsedNodes = new List<TreeNode>();
		expandedNodes = new List<TreeNode>();
		selected = new List<DisplayObject>();


		super.init(opts);


		description = null;


		rootNode = new TreeNode(this, "rootNode");
		rootNode.init({width: box.width, color: this.color });
		rootNode.description = null;
		rootNode.expander.label.setText(Opts.optString(opts, "text", rootNode.expander.label.getText()));

		// var self = this;
		// addEventListener(ResizeEvent.RESIZE, function(e){ trace(e); self.redraw(); });
		parent.addEventListener(ResizeEvent.RESIZE, onParentResize, false, 0, true);
	}
	//}}}

	public override function addChild(o:DisplayObject) : DisplayObject {
		var c = super.addChild(o);
		if(Std.is(c, TreeNode)) {
			if((cast c).expanded) expandedNodes.add(cast c);
			else collapsedNodes.add(cast c);
		}
		return c;
	}


	public function count() : Int {
		return 0;
	}

	//{{{ redraw
	public override function redraw(opts:Dynamic=null) {
		// background
		this.graphics.clear();
		this.graphics.beginFill(this.color);
		this.graphics.drawRect(0, 0, box.width, box.height);
		this.graphics.endFill();

		for(i in 0...Std.int(box.height/20)) {
			this.graphics.beginFill(i%2==0 ? this.color : Color.darken(this.color, 10));
			this.graphics.drawRect(0, 24*i, box.width, 24);
			this.graphics.endFill();
		}

		// this.graphics.lineStyle(1, Color.darken(DefaultStyle.BACKGROUND,30), 1);
		// this.graphics.moveTo(24, 12);
		// this.graphics.lineTo(24, 24*this.rootNode.expander.numChildren);
		// for(i in 0...this.rootNode.expander.numChildren) {
		// 	this.graphics.moveTo(24, 24*i-12);
		// 	this.graphics.lineTo(48, 24*i-12);
		// }


		super.redraw(opts);
	}
	//}}}


	//{{{ process
	public function process(o:Dynamic, ?node:Dynamic=null) {
		haxegui.Profiler.begin(here.className.split(".").pop()+"."+here.methodName);

		if(o==null) return;
		if(node==null) node=this;
		for(f in Reflect.fields(o)) {
			if(Reflect.isObject(Reflect.field(o, f))) {
				if(Std.is(Reflect.field(o, f), String) || Reflect.fields(Reflect.field(o,f)).length==0 )  {
					var leaf = new TreeLeaf(node, f);
					leaf.init({
						x: x+24,
						y: 24*(node.getChildIndex(leaf)-1),
						width: box.width-(node.x),
						height: 24,
						isible: false,
						color: this.color
					});
				}
				else {
					var treenode = new TreeNode(node, f);
					treenode.init({
						width: box.width,
						height: 24,
						x: x+24,
						y: 24*(node.getChildIndex(treenode)-1),
						visible: false,
						color: this.color
					});
					process(Reflect.field(o,f), treenode);
				}
			}
		}

		haxegui.Profiler.end();
	}
	//}}}


	//{{{ processXml
	public function processXml(xml:Xml, ?node:Dynamic=null) {
		if(xml==null) return;
		if(node==null) node=this.rootNode;

		for(e in xml.elements()) {
			var fast = new haxe.xml.Fast(e);
			if(e.firstElement()==null) {
				var leaf = new TreeLeaf(node);
				leaf.init({
					x: x + 24,
					y: 24 * (node.getChildIndex(leaf)-1),
					width: box.width-(node.x),
					height: 24,
					visible: false,
					label:
					// (e.attributes().hasNext() && e.exists("name")) ? e.get("name") :
					// (e.exists("id")) ? e.get("id") : e.nodeName,
					fast.has.name ? fast.att.name : fast.has.id ? fast.att.id : fast.name,
					color: this.color
				});
			}
			else {
				var treenode = new TreeNode(node);
				treenode.init({
					width: box.width,
					height: 24,
					x: x+24,
					y: 24*(node.getChildIndex(treenode)-1),
					visible: false,
					// label: (e.attributes().hasNext() && e.exists("name")) ? e.get("name") : e.nodeName,
					label: fast.has.name ? fast.att.name : fast.has.id ? fast.att.id : fast.name,
					color: this.color
				});
				processXml(e, treenode);
			}

		}
	}
	//}}}


	//{{{ onParentResize
	public function onParentResize(e:ResizeEvent) : Void {
		box = parent.asComponent().box.clone();


		// if(parent.parent!=null) {
		// box.width = (cast parent.parent).box.width - x;
		// box.height = (cast parent.parent).box.height - y;
		// }

		// for(a in ancestors()) {
		// if(Std.is(a, haxegui.containers.Divider))
		// box.width -= 10;
		// }

		// redraw();
		for(i in this) {
			i.asComponent().box.width = box.width;
			i.asComponent().dirty=true;
		}

		dirty = true;


		dispatchEvent(e);
	}
	//}}}


	//{{{ onResize
	public override function onResize(e:ResizeEvent) : Void {
		redraw();
	}
	//}}}


	//{{{ expandNode
	public function expandNode(node:TreeNode) {
		node.expander.expanded = true;
		node.expand();
		for(i in 2...node.expander.numChildren)
		node.expander.getChildAt(i).visible = true;
		for(n in node.expander.getElementsByClass(TreeNode))
		expandNode(n);
	}
	//}}}


	//{{{ expandFull
	public function expandFull() {
		expandNode(rootNode);

		box = getBounds(this);
		dirty = true;
	}
	//}}}


	//{{{ visibleRowCount
	public function visibleRowCount() : Int {
		// var count = function(o) { if(o==null) return; var i=o.numChildren; for(j in o) i+=count(j); return i; };
		return 0;
	}
	//}}}


	//{{{ totalRowCount
	public function totalRowCount() : Int {
		// return 0;
		return countNode(rootNode);
	}
	//}}}


	//{{{ countNode
	public function countNode(n:TreeNode) : Int {
		if(n==null) return 0;
		var i = n.expander.numChildren;
		for(c in n.expander)
		if(Std.is(c, TreeNode)) i+=countNode(cast c);
		return i;
	}
	//}}}

	//{{{ setDataSource
	public function setDataSource(d:DataSource) : DataSource {
		dataSource = d;

		// dataSource.addEventListener(Event.CHANGE, onData, false, 0, true);
		// var l = 0;
		// if(dataSource.data!=null)
		// l = dataSource.data.length;
		// dispatchEvent(new ListEvent(ListEvent.CHANGE, new IntIter(0, l)));

		return dataSource;
	}
	//}}}


	//{{{ __init__
	static function __init__() {
		haxegui.Haxegui.register(Tree);
	}
	//}}}
	//}}}
}
//}}}

