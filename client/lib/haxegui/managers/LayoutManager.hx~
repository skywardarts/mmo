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

package haxegui.managers;


//{{{
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import haxegui.XmlParser;
//}}}


/**
* LayoutManager handles loading layouts from XML files, and setting a layout.
*
* @version 0.1
* @author Russell Weir <damonsbane@gmail.com>
* @author Omer Goshen <gershon@goosemoose.com>
*/
class LayoutManager
{
	public static var layouts : Hash<Xml> = new Hash<Xml>();
	public static var lastLoaded : String;

	//{{{ fetchLayout
	/**
	* Convenience method for loading a style from a url.
	*
	* @param url Path to layout file
	* @param cb Function callback which gets a true (success) or false (fail)
	**/
	public static function fetchLayout(url : String, cb:Bool->Void=null) {
		var loader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, callback(onXmlLoaded,cb), false, 0, true);
		loader.load(new URLRequest(url));
	}
	//}}}


	//{{{ loadLayouts
	/**
	* Load all layouts in an XML document.
	**/
	public static function loadLayouts(xml:Xml) {
		for(elem in xml.elements()) {
			if(!XmlParser.isLayoutNode(elem))
				continue;
			var name = XmlParser.getLayoutName(elem);
			if(name == null)
				continue;
			layouts.set(name, elem);
			lastLoaded = name;
		}
	}
	//}}}


	//{{{ setLayout
	/**
	* Set the current layout.
	**/
	public static function setLayout(name:String) {
		if(!layouts.exists(name)) {
			throw("Layout '"+name+"' does not exist");
			return;
		}
		XmlParser.apply(layouts.get(name));
	}
	//}}}


	//{{{ onXmlLoaded
	/** fetchLayout handler **/
	private static function onXmlLoaded(cb:Bool->Void, e:Event) : Void
	{
		trace(here.methodName);
		var rv = true;
		try {
			var str : String = e.target.data;
			LayoutManager.loadLayouts(Xml.parse(str));
			trace("Current layouts:");
			for(k in LayoutManager.layouts.keys())
				trace(" : " + k);
		} catch(e:Dynamic) {
			rv = false;
		}
		if(cb != null) cb(rv);
	}
	//}}}


	//{{{ reload
	/**
	* Reload last layout.
	**/
	public static function reload() {
		setLayout(lastLoaded);
	}
	//}}}
}
