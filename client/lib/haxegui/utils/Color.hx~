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

import flash.geom.Transform;

/**
* Functions to ease dealing with hex color triplets.<br/>
* This class especially comes handy with haxe's [using] keyword (not in hscript).
*
* @todo: HLS, HLV, CMYK... <http://haxe.org/doc/snip/colorconverter>
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class Color
{
	//{{{ Colors
	// Basic colors only, for a full named list do:
	// cat /etc/X11/rgb.txt | awk '{ printf "public static inline var %s = 0x%06X;\n", $4$5$6, or(lshift($1,16), or(lshift($2, 8), $3)) } '
	public static inline var BLACK 	  : UInt = 0x000000;
	public static inline var WHITE 	  : UInt = 0xFFFFFF;
	public static inline var RED   	  : UInt = 0xFF0000;
	public static inline var GREEN 	  : UInt = 0x00FF00;
	public static inline var BLUE 	  : UInt = 0x0000FF;
	public static inline var CYAN  	  : UInt = 0x00FFFF;
	public static inline var MAGENTA  : UInt = 0xFF00FF;
	public static inline var YELLOW   : UInt = 0xFFFF00;
	//}}}


	//{{{ Functions


	//{{{ toHex
	/**
	 * @return Flash formatted hex string (0xRRGGBB)
	 */
	public static inline function toHex(color:UInt) : String {
		return "0x"+StringTools.hex(color, 6);
	}
	//}}}


	//{{{ grayHex
	/**
	* Single int to gray rgb triplet
	* <pre class="code haxe">
	* // results in #0A0A0A
	* var htmlGray10 = "#"+StringTools.hex(Color.grayHex(10),6);
	* // results in 0x141414
	* var flashGray20 = "0x"+StringTools.hex(Color.grayHex(10)+Color.grayHex(10),6);
	* </pre>
	**/
	public static inline function grayHex( v:UInt ) : UInt {
		return ( v << 16 | v << 8 | v );
	}
	//}}}


	//{{{ clamp
	/**
	* Clamps to black and white
	* <pre class="code haxe">
	* // not using clamp, traces 12C1414
	* trace(StringTools.hex((300<<16)|(20<<8)|20));
	* // rgb() uses clamping, traces FFFFFF
	* trace(StringTools.hex(Color.rgb(300,20,20)));
	* </pre>
	**/
	public static inline function clamp( color:UInt ) : UInt {
		return cast (Math.max(BLACK, Math.min(WHITE, color)));
	}
	//}}}


	//{{{ darken
	/**
	* Darken color by value
	* @param input color
	* @param value (integer)
	* @return output color
	*/
	public static inline function darken(color:UInt, v:UInt ) : UInt {
		return clamp(color - grayHex(v));
	}
	//}}}


	//{{{ tint
	/**
	* Tint color by percentage
	* <pre class="code haxe">
	* // gives 50% gray
	* var c = Color.tint(Color.BLACK, .5);
	* </pre>
	* @param input color
	* @param value (float 0-1)
	* @return output color
	*/
	public static inline function tint( color:UInt, tint:Float ) : UInt	{
		var r = color >> 16 ;
		var g = color >> 8 & 0xFF ;
		var b = color & 0xFF ;

		tint = 1 - tint;

		r = Math.round( r + ( ( 255 - r ) * tint ) );
		g = Math.round( g + ( ( 255 - g ) * tint ) );
		b = Math.round( b + ( ( 255 - b ) * tint ) );

		return clamp(( r << 16 ) | ( g << 8 ) | b);
	}
	//}}}


	//{{{ rgb
	/**
	* Returns clamped hex integer color from rgb triplet
	* <pre class="code haxe">
	* var red = Color.rgb(255,0,0);
	* var htmlGreen = "#"+StringTools.hex(Color.rgb(0,255,0),6);
	* </pre>
	* @param red value
	* @param green value
	* @param blue value
	* @return output color
	*/
	public static inline function rgb(r:UInt,g:UInt,b:UInt) : UInt {
		return clamp((r << 16) | (g << 8) | b);
	}
	//}}}


	//{{{ toRGB
	/**
	* Return object with rgb triplet from hex integer
	* <pre class="code haxe">
	* var rgb = Color.toRGB(Color.RED);
	* // outputs 0
	* trace(rgb.r-255);
	* </pre>
	* @param input color
	* @return Dynamic object with r,g,b fields
	*/
	public static inline function toRGB(color:UInt) : Dynamic {
		var r = (color >> 16) & 0xFF ;
		var g = (color >> 8) & 0xFF ;
		var b = color & 0xFF ;
		return { r: r, g: g, b: b };
	}
	//}}}


	//{{{ random
	public static inline function random() : UInt {
		return Std.int(Math.random()*Color.WHITE);
	}
	//}}}
	//}}}
}
