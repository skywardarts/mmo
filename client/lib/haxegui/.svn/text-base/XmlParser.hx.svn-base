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


import haxegui.controls.Component;
import haxegui.controls.Component;
import haxegui.managers.ScriptManager;
import haxegui.utils.ScriptStandardLibrary;


/**
* Style and Layout parser
*
* @version 0.1
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
*/
class XmlParser {

	//{{{ Members
	private var isStyle : Bool;
	/** @todo maybe find a different runtime container **/
	static var GLOBAL_OBJECT = flash.Lib.current;
	//}}}


	//{{{ Constructor
	private function new(xml:Xml, ?parent:Dynamic) {
		var typeParts = xml.nodeName.split(":");
		if(typeParts[0] != "haxegui")
		throw "Not a haxegui node";

		switch(typeParts[1].toLowerCase()) {
			case "layout" : isStyle = false;
			case "style"  : isStyle = true;
			default		  : throw "Unhandled xml type: " + typeParts[1];
		}

		// trace(this+": Parsing " + typeParts[1].toLowerCase() + " for " + xml.get("name"));
		for(x in xml.elements())
		parseNode(x, parent);
	}
	//}}}

	//{{{ Functions

	//{{{ toString
	public function toString() : String {
		return "XmlParser";
	}
	//}}}


	//{{{ getLayoutName
	/**
	* Gets the name from a layout xml node.
	*
	* @return Null or layout name
	**/
	public static function getLayoutName(xml:Xml) : String {
		var typeParts = xml.nodeName.split(":");
		if(typeParts[0] != "haxegui")
		return null;
		switch(typeParts[1].toLowerCase()) {
			case "layout":
			default: return null;
		}
		return xml.get("name");
	}
	//}}}


	//{{{ getStyleName
	/**
	* Gets the name from a style xml node.
	* @param xml Xml to parse
	* @return Null or style name
	**/
	public static function getStyleName(xml:Xml) : String {
		var typeParts = xml.nodeName.split(":");
		if(typeParts[0] != "haxegui")
		return null;
		switch(typeParts[1].toLowerCase()) {
			case "style":
			default: return null;
		}
		return xml.get("name");
	}
	//}}}


	//{{{ isLayoutNode
	/**
	* @param xml Xml to parse
	* @return true when parsing a layout node
	*/
	public static function isLayoutNode(xml:Xml) : Bool {
		var typeParts = xml.nodeName.split(":");
		if(typeParts[0] == "haxegui" && typeParts[1].toLowerCase() == "layout")
		return true;
		return false;
	}
	//}}}


	//{{{ isStyleNode
	/**
	* @param xml Xml to parse
	* @return true when parsing a style node
	*/
	public static function isStyleNode(xml:Xml) : Bool {
		var typeParts = xml.nodeName.split(":");
		if(typeParts[0] == "haxegui" && typeParts[1].toLowerCase() == "style")
		return true;
		return false;
	}
	//}}}


	//{{{ isDataNode
	/**
	* @param xml Xml to parse
	* @return true when parsing a data node
	*/
	public static function isDataNode(xml:Xml) : Bool {
		if(xml.nodeName == "List" || xml.nodeName == "Array" || xml.nodeName == "Xml")
		return true;
		return false;
	}
	//}}}


	//{{{ isDataSourceNode
	/**
	* @param xml Xml to parse
	* @return true when parsing a data source node
	*/
	public static function isDataSourceNode(xml:Xml) : Bool {
		var typeParts = xml.nodeName.split(":");
		if(typeParts[0] == "haxegui" && typeParts[1].toLowerCase() == "datasource")
		return true;
		return false;
	}
	//}}}


	//{{{ apply
	/**
	* Applies the given style or layout from the provided Xml node
	**/
	public static function apply(xml:Xml, ?parent:Dynamic) {
		var xp = new XmlParser(xml, parent);
	}
	//}}}


	//{{{ parseNode
	/**
	* Parse an xml node, creating a proper class instance, calling init() if needed.<br/>
	* @param node 	The xml parse
	* @param parent Parent to attach instance to (needed for component constructors)
	* @return
	*/
	function parseNode(node:Xml, ?parent:Dynamic) : Void {
		var className = node.nodeName.split(":").join(".");

		// ignore <events> children, processed below.
		if(className == "events")
		return;

		var ns = "";
		for(i in node.attributes())
		if(i.substr(0,7)=="haxegui")
		className = "haxegui."+className;

		var resolvedClass = Type.resolveClass(className);
		if(resolvedClass == null) {
			trace(this+": warning : Class " + className + " not resolved.");
			return;
		}


		if(!isStyle) {
			if(Std.is(parent, List)) {
				parent.add( node.firstChild().nodeValue );
				Reflect.setField(GLOBAL_OBJECT, node.parent.get("name"), parent);
				return;
			}

			if(Std.is(parent, Array)) {
				parent.push( node.firstChild().nodeValue );
				Reflect.setField(GLOBAL_OBJECT, node.parent.get("name"), parent);
				return;
			}

			if(node.nodeName=="Xml") {
				parent.data = Xml.parse(node.firstChild().nodeValue) ;
				Reflect.setField(GLOBAL_OBJECT, node.get("name"), parent.data);
				return;
			}

			if(node.nodeName=="Float" || node.nodeName=="String" || node.nodeName=="String" || node.nodeName=="Bool") {
				Reflect.setField(GLOBAL_OBJECT, node.get("name"), node.firstChild().nodeValue);
				return;
			}

			if(node.nodeName=="Function") {
				var f = function(){};
				var args = {};
				var code = node.elementsNamed("Return").next().firstChild().nodeValue;

				var parser = new hscript.Parser();
				var program = parser.parseString(code);
				var interp = new hscript.Interp();

				for(arg in node.elementsNamed("Argument")) {
					Reflect.setField(args, arg.get("name"), Type.createInstance(Type.resolveClass(arg.get("type")), []));
					interp.variables.set(arg.get("name"), 2 );
				}


				// interp.variables.set( "this", inst );
				// interp.variables.set( "parent", parent );
				// interp.variables.set( "arguments", args );


				ScriptStandardLibrary.set(interp);
				try {
					var rv = interp.execute(program);
					trace(rv);
				}
				catch(e:Dynamic) {
					trace(e);
				}


				Reflect.setField(GLOBAL_OBJECT, node.get("name"), f);
				return;
			}

		}


		if(!isStyle)
		if(isDataSourceNode(node) || isDataNode(node)) {
			var data : Dynamic = null;
			if(isDataSourceNode(node))
			data = Type.createInstance(resolvedClass, [node.get("name")]);
			else
			data = Type.createInstance(resolvedClass, []);

			if(Std.is(parent, DataSource))
			parent.data = data;


			if(node.elements().hasNext())
			for(i in node.elements())
			parseNode(i, data);

			// if(Std.is(parent, Component) && Std.is(data, DataSource)) {
			if(Std.is(parent, haxegui.controls.IDataSource) && Std.is(data, DataSource)) {
				// parent.dataSource = data;
				parent.setDataSource(data);

				// if(Reflect.hasField( parent, "onData") )
				// if(Reflect.isFunction( Reflect.field(parent, "onData") ))
				// Reflect.callMethod( parent, parent.onData, [] );


			}

			return;
		}


		var inst : Dynamic = null;
		var comp : Component = null;
		if(!isStyle) {
			var args : Dynamic = {};
			// switch(Type.getClassName(resolvedClass)) {
			// case "flash.text.TextField", "flash.display.Sprite":
			// inst = Type.createInstance(resolvedClass, []);
			// parent.addChild(inst);

			// default:
			inst = Type.createInstance(resolvedClass, [parent, node.get("name")]);
			// }
			if(Std.is(inst, Component)) {
				comp = cast inst;
			}


			for(attr in node.attributes()) {
				var val = node.get(attr);

				switch(val.charAt(0)) {
					case "@":
					Reflect.setField(args, attr, Reflect.field(GLOBAL_OBJECT, val.substr(1, val.length) ) );
					trace(attr+"\t"+Reflect.field(GLOBAL_OBJECT, val.substr(1, val.length) ));

					case "{":
					val = val.substr(1,val.length-2);

					var parser = new hscript.Parser();
					var program = parser.parseString(val);
					var interp = new hscript.Interp();

					interp.variables.set( "this", inst );
					interp.variables.set( "parent", parent );
					ScriptStandardLibrary.set(interp);
					try {
						var rv = interp.execute(program);
						Reflect.setField(args, attr, rv );
					}
					catch(e:Dynamic) {
						trace(e);
					}

					default:
					Reflect.setField(args, attr, val );
				}
			}

			if(node.firstChild() != null) {
				//~ if(node.firstChild().nodeType==Xml.PCData)
				if(Std.string(node.firstChild().nodeValue).charAt(0)!="\n") {
					if(Std.string(node.firstChild().nodeValue).charAt(0)!="\t") {
						var str : String = node.firstChild().nodeValue;
						str = str.split("\t").join("");
						Reflect.setField(args, "text", str );
					}
				}
			}

			// run the init script, if it's a Component or other
			// type with an Init field
			if(Reflect.hasField( inst, "init") )
			if(Reflect.isFunction( Reflect.field(inst, "init") ))
			Reflect.callMethod( inst, inst.init, [args] );
		}


		// parse event scripts
		for(evtSet in node.elementsNamed("events")) {
			for(x in evtSet.elements())
			parseScriptNode(className, x, inst, resolvedClass);
		}


		// if(!isStyle) {
		if(node.elements().hasNext())
		for(i in node.elements())
		parseNode(i, inst);
		if(comp != null && comp.hasAction("onLoaded")) {
			trace("Executing onLoaded method for component "+ comp.name);
			try {
				ScriptManager.exec(comp, "onLoaded", {});
			} catch(e:Dynamic) {
				trace("Error executing onLoaded method for component "+ comp.name);
			}
			// }
		}
	}
	//}}}


	//{{{ parseScriptNode
	/**
	* parseScriptNode<br/>
	* <p>Scripts must go in a CData tag</p>
	* @param className  	Name of the class
	* @param node 			Xml to parse
	* @param inst 			The instance to attach the script to
	* @param resolvedClass	The class to attach the script to
	* @throws String 		Error
	* @return
	*/
	function parseScriptNode(className:String, node:Xml, inst:Component, resolvedClass:Class<Dynamic>) {
		var location = " in "+className+"<events> section";
		if(node.nodeName != "script") {
			trace("XmlParser : warning : Unexpected node " + node.nodeName + location);
			return;
		}

		var type : String = node.get("type");
		var action : String = node.get("action");

		if(type != "text/hscript") {
			trace("XmlParser : error : Unhandled script type " + type + location);
			return;
		}

		if(action == null) {
			trace("XmlParser : warning : No action attribute " + node.nodeName + location);
			return;
		}

		var code : String = "";

		for(i in node) {
			if(i.nodeType == Xml.PCData) continue;
			if(i.nodeType == Xml.CData)
			code += i.nodeValue;
			else
			trace("XmlParser : warning : Bad node type " + node.firstChild().nodeType + location);
		}


		if(isStyle)
		ScriptManager.setDefaultScript(resolvedClass, action, code);
		else {
			inst.setAction(action,code);
			if(!inst.hasOwnAction(action))
			throw "instance name " + inst.name + " has no " + action;
		}
	}
	//}}}
	//}}}
}
