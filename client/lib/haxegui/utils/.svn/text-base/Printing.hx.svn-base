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

package haxegui.utils;


//{{{ Imports
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.text.TextField;
//}}}


//{{{ Printing
/**
 * Printing functions, PHP-Styled printing, mostly used by [Console]<br/>
 */
class Printing {
	//{{{ print_r
	/**
	*
	*
	*/
	public static function print_r(obj:Dynamic, ?indent:String="\t") : String
	{
		return Std.is(obj, DisplayObjectContainer) ? print_mc(obj, indent) : print_a(obj, indent);
	}
	//}}}


	//{{{ print_a
	/**
	*
	*
	*/
	public static function print_a(obj:Dynamic, ?indent:String="\t") : String
	{
		//
		var type = obj.constructor;
		var str : String = "\n"+indent + type;

		// special cases - list
		if(Std.is(obj, List)) {
			var a = cast(obj, List<Dynamic>).iterator();
			var i = 0;
			for(j in a)
				str += "\n" + indent + "["+(i++)+"] => "+j+" "+Type.typeof(j);
		}


		// Make sure its an object, and not a of class String
		if(!Reflect.isObject(obj) || Std.is(obj, String) )
			return Std.string(obj) + " " + type;

		for (i in Reflect.fields(obj))
		{
			str += "\n"+indent;
			var field = Reflect.field(obj, i) ;
			//~ type = field.constructor;

			if(Reflect.isObject(field))
			//~ if(Reflect.isObject(field) || Std.is(field, Array) )
			{
					str += indent + "[" + i  + "]" + " => " ;
					str += print_r(field, indent+indent) ;

			}
			else {
				str += indent + "["+i+"] => "+field+" "+type;
			}
		}

		return str;
	}
	//}}}


	//{{{ print_mc
	/**
	*
	*
	*/
	public static function print_mc(obj:DisplayObjectContainer, ?indent:String) : String
	{
		if (indent == null) { indent = "\t"; } else { indent += "\t"; }

		//
		var str : String = "\n";
		for (i in 0...obj.numChildren)
		{
			var child = obj.getChildAt(i);
			if(Std.is(child, DisplayObjectContainer))
			{
				str += indent + "[" + child.name  + "]" + " => " + child;
				str += indent + print_r(cast child, indent);
			}
			else
			{
				if(Std.is(child,Sprite) || Std.is(child,TextField))
					str += indent + "[" + child.name + "] => " + child + "\n";
			}
		}
		return str;
	}
	//}}}
}
//}}}
