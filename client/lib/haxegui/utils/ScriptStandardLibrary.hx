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
import flash.ui.Keyboard;
import haxegui.managers.CursorManager;
import haxegui.managers.StyleManager;
import hscript.Interp;
//}}}


/**
* Functions for setting up a scripting environment with standard libraries.
*
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class ScriptStandardLibrary {
	//{{{ Functions
	//{{{ set
	/**
	* Sets all the exported library methods to the given interpreter.<br/>
	* <p>The haxegui package is exported without the "haxegui" prefix.</p>
	**/
	public static function set(interp:Interp) {
		//{{{ haxe
		interp.variables.set( "Bool", Bool );
		interp.variables.set( "Date", Date );
		interp.variables.set( "EReg", EReg );
		interp.variables.set( "Firebug", haxe.Firebug );
		interp.variables.set( "Hash", Hash );
		interp.variables.set( "Int", Int );
		interp.variables.set( "Lambda", Lambda );
		interp.variables.set( "Lib", flash.Lib );
		interp.variables.set( "List", List );
		interp.variables.set( "Log", haxe.Log );
		interp.variables.set( "Math", Math );
		interp.variables.set( "Reflect", Reflect );
		interp.variables.set( "Resource", haxe.Resource );
		interp.variables.set( "Std", Std );
		interp.variables.set( "String", String );
		interp.variables.set( "StringTools", StringTools );
		interp.variables.set( "Timer", haxe.Timer );
		interp.variables.set( "Type", Type );
		interp.variables.set( "Xml", Xml );
		interp.variables.set( "root", flash.Lib.current );
		interp.variables.set( "stage", flash.Lib.current.stage );
		interp.variables.set( "trace", haxe.Log.trace );

		interp.variables.set( "baseURL", haxegui.Haxegui.baseURL );
		//}}}


		//{{{ feffects
		interp.variables.set("feffects",
		{
			Tween : feffects.Tween,
			easing : {
				Back 	: feffects.easing.Back,
				Bounce  : feffects.easing.Bounce,
				Circ 	: feffects.easing.Circ,
				Cubic 	: feffects.easing.Cubic,
				Elastic : feffects.easing.Elastic,
				Expo 	: feffects.easing.Expo,
				Linear  : feffects.easing.Linear,
				Quad 	: feffects.easing.Quad,
				Quart 	: feffects.easing.Quart,
				Quint 	: feffects.easing.Quint,
				Sine 	: feffects.easing.Sine,
			},
		});
		//}}}

		interp.variables.set( "remoting",
		{
			HttpConnection 		: haxe.remoting.HttpConnection,
			HttpAsyncConnection : haxe.remoting.HttpAsyncConnection,
			SocketConnection	: haxe.remoting.SocketConnection
		}
		);


		//{{{ flash
		interp.variables.set("flash",
		{
			display : {
				Bitmap : flash.display.Bitmap,
				BitmapData : flash.display.BitmapData,
				BlendMode : {
					ADD : flash.display.BlendMode.ADD,
					ALPHA : flash.display.BlendMode.ALPHA,
					DARKEN : flash.display.BlendMode.DARKEN,
					DIFFERENCE : flash.display.BlendMode.DIFFERENCE,
					ERASE : flash.display.BlendMode.ERASE,
					HARDLIGHT : flash.display.BlendMode.HARDLIGHT,
					INVERT : flash.display.BlendMode.INVERT,
					LAYER : flash.display.BlendMode.LAYER,
					LIGHTEN : flash.display.BlendMode.LIGHTEN,
					MULTIPLY : flash.display.BlendMode.MULTIPLY,
					NORMAL : flash.display.BlendMode.NORMAL,
					OVERLAY : flash.display.BlendMode.OVERLAY,
					SCREEN : flash.display.BlendMode.SCREEN,
					SUBTRACT : flash.display.BlendMode.SUBTRACT,
				},
				GradientType : {
					LINEAR: flash.display.GradientType.LINEAR,
					RADIAL: flash.display.GradientType.RADIAL,
				},
				LineScaleMode : {
					HORIZONTAL : flash.display.LineScaleMode.HORIZONTAL,
					NONE : flash.display.LineScaleMode.NONE,
					NORMAL : flash.display.LineScaleMode.NORMAL,
					VERTICAL : flash.display.LineScaleMode.VERTICAL,
				},
				JointStyle : {
					BEVEL : flash.display.JointStyle.BEVEL,
					MITER : flash.display.JointStyle.MITER,
					ROUND : flash.display.JointStyle.ROUND
				},
				CapsStyle : {
					NONE : flash.display.CapsStyle.NONE,
					ROUND : flash.display.CapsStyle.ROUND,
					SQUARE : flash.display.CapsStyle.SQUARE
				},
				Shape : flash.display.Shape,
				Sprite : flash.display.Sprite,
				MovieClip : flash.display.MovieClip,
				AVM1Movie : flash.display.AVM1Movie
			},
			external : {
				ExternalInterface : flash.external.ExternalInterface
			},
			filters : {
				BevelFilter : flash.filters.BevelFilter,
				BitmapFilter : flash.filters.BitmapFilter,
				BitmapFilterQuality : {
					HIGH : flash.filters.BitmapFilterQuality.HIGH,
					LOW : flash.filters.BitmapFilterQuality.LOW,
					MEDIUM : flash.filters.BitmapFilterQuality.MEDIUM,
				},
				BitmapFilterType : {
					OUTER : flash.filters.BitmapFilterType.OUTER,
					INNER : flash.filters.BitmapFilterType.INNER,
					FULL : flash.filters.BitmapFilterType.FULL,
				},
				BlurFilter : flash.filters.BlurFilter,
				ColorMatrixFilter : flash.filters.ColorMatrixFilter,
				ConvolutionFilter : flash.filters.ConvolutionFilter,
				DisplacementMapFilter : flash.filters.DisplacementMapFilter,
				DisplacementMapFilterMode : {
					CLAMP : flash.filters.DisplacementMapFilterMode.CLAMP,
					COLOR : flash.filters.DisplacementMapFilterMode.COLOR,
					IGNORE : flash.filters.DisplacementMapFilterMode.IGNORE,
					WRAP : flash.filters.DisplacementMapFilterMode.WRAP,
				},
				DropShadowFilter : flash.filters.DropShadowFilter,
				GlowFilter : flash.filters.GlowFilter,
				GradientBevelFilter : flash.filters.GradientBevelFilter,
				GradientGlowFilter : flash.filters.GradientGlowFilter,
			},
			geom : {
				Matrix : flash.geom.Matrix,
				Point : flash.geom.Point,
				Rectangle : flash.geom.Rectangle,
			},
			text : {
				StyleSheet : flash.text.StyleSheet,
				TextField : flash.text.TextField,
				TextFieldType : flash.text.TextFieldType,
				TextFormat : flash.text.TextFormat,
				TextFormatAlign : flash.text.TextFormatAlign,
				AntiAliasType: {
					NORMAL  : flash.text.AntiAliasType.NORMAL,
					ADVANCED  : flash.text.AntiAliasType.ADVANCED
				},
				TextFieldAutoSize: {
					CENTER  : flash.text.TextFieldAutoSize.CENTER,
					LEFT  : flash.text.TextFieldAutoSize.LEFT,
					NONE  : flash.text.TextFieldAutoSize.NONE,
					RIGHT  : flash.text.TextFieldAutoSize.RIGHT,
				}
			},
			events : {
				DataEvent     	: flash.events.DataEvent,
				Event 		  	: flash.events.Event,
				EventPhase	  	: flash.events.EventPhase,
				FocusEvent    	: flash.events.FocusEvent,
				KeyboardEvent 	: flash.events.KeyboardEvent,
				MouseEvent    	: flash.events.MouseEvent,
				//SampleDataEvent : flash.events.SampleDataEvent,
				TextEvent     	: flash.events.TextEvent
			},
			net : {
				URLLoader	: flash.net.URLLoader,
				URLRequest	: flash.net.URLRequest
			},
			media : {
				Sound		 : flash.media.Sound,
				SoundChannel : flash.media.SoundChannel,
				SoundMixer   : flash.media.SoundMixer
			},
			ui : {
				Keyboard : keyboard(),
				Mouse	 : flash.ui.Mouse
			},
			system : {
				Capabilities : flash.system.Capabilities,
				Security 	 : flash.system.Security,
				System 		 : flash.system.System,
			},
			utils : {
				ByteArray	 : flash.utils.ByteArray,
				Endian		 : flash.utils.Endian
			}
		});
		//}}}


		//{{{ ui
		interp.variables.set("Keyboard", keyboard());
		interp.variables.set("Mouse", flash.ui.Mouse);
		//}}}


		//{{{ CodeHighlighter
		//interp.variables.set("CodeHighlighter", CodeHighlighter);
		//}}}


		//{{{ haxegui
		/** haxegui exported with haxegui package stripped **/
		interp.variables.set("AbstractButton", haxegui.controls.AbstractButton);
		interp.variables.set("Alert", haxegui.Alert);
		interp.variables.set("Appearance", haxegui.Appearance);
		interp.variables.set("Color", haxegui.utils.Color);
		interp.variables.set("ColorPicker", haxegui.ColorPicker);
		interp.variables.set("ColorPicker2", haxegui.ColorPicker2);
		interp.variables.set("Component", haxegui.controls.Component);
		interp.variables.set("Console", haxegui.Console);
		interp.variables.set("Container", haxegui.containers.Container);
		interp.variables.set("CursorManager", CursorManager);
		interp.variables.set("DataSource", haxegui.DataSource);
		interp.variables.set("DefaultStyle", DefaultStyle);
		interp.variables.set("Dialog", haxegui.Dialog);
		interp.variables.set("Divider", haxegui.containers.Divider);
		interp.variables.set("DragManager", haxegui.managers.DragManager);
		interp.variables.set("FileDialog", haxegui.FileDialog);
		interp.variables.set("FocusManager", haxegui.managers.FocusManager);
		interp.variables.set("Grid", haxegui.containers.Grid);
		interp.variables.set("Haxegui", haxegui.Haxegui);
		interp.variables.set("Image", haxegui.controls.Image);
		interp.variables.set("Introspector", haxegui.Introspector);
		interp.variables.set("LayoutManager", haxegui.managers.LayoutManager);
		interp.variables.set("MenuBar", haxegui.controls.MenuBar);
		interp.variables.set("MouseManager", haxegui.managers.MouseManager);
		interp.variables.set("Opts", haxegui.utils.Opts);
		interp.variables.set("PopupMenu", haxegui.controls.PopupMenu);
		interp.variables.set("Printing", haxegui.utils.Printing);
		interp.variables.set("Profiler", haxegui.Profiler);
		interp.variables.set("RichTextEditor", haxegui.RichTextEditor);
		interp.variables.set("ScriptManager", haxegui.managers.ScriptManager);
		interp.variables.set("ScriptStandardLibrary", ScriptStandardLibrary);
		interp.variables.set("ScrollPane", haxegui.containers.ScrollPane);
		interp.variables.set("Size", haxegui.utils.Size);
		interp.variables.set("Stack", haxegui.containers.Stack);
		interp.variables.set("Stats", haxegui.Stats);
		interp.variables.set("StyleManager", StyleManager);
		interp.variables.set("ToolBar", haxegui.controls.ToolBar);
		interp.variables.set("TooltipManager", haxegui.managers.TooltipManager);
		interp.variables.set("Window", haxegui.Window);
		interp.variables.set("WindowManager", haxegui.managers.WindowManager);
		interp.variables.set("XmlParser", haxegui.XmlParser);
		//}}}


		//{{{ Cursor
		interp.variables.set("Cursor",{
			ARROW 	  : Cursor.ARROW,
			CROSSHAIR : Cursor.CROSSHAIR,
			DRAG 	  : Cursor.DRAG,
			HAND 	  : Cursor.HAND,
			HAND2 	  : Cursor.HAND2,
			IBEAM 	  : Cursor.IBEAM,
			NESW 	  : Cursor.NESW,
			NS 	 	  : Cursor.NS,
			NWSE 	  : Cursor.NWSE,
			SIZE_ALL  : Cursor.SIZE_ALL,
			WE 		  : Cursor.WE,
		});
		//}}}

		//{{{ windowClasses
		interp.variables.set("windowClasses", {
			TitleBar			: haxegui.windowClasses.TitleBar,
			WindowFrame			: haxegui.windowClasses.WindowFrame
		}
		);
		//}}}


		//{{{ events
		interp.variables.set("events",
		{
			MenuEvent			: haxegui.events.MenuEvent,
			MoveEvent			: haxegui.events.MoveEvent,
			ResizeEvent			: haxegui.events.ResizeEvent,
			WindowEvent			: haxegui.events.WindowEvent,
		}
		);
		//}}}


		//{{{ controls
		interp.variables.set("controls",
		{
			AbstractButton		: haxegui.controls.AbstractButton,
			Button				: haxegui.controls.Button,
			CheckBox			: haxegui.controls.CheckBox,
			ComboBox			: haxegui.controls.ComboBox,
			Input				: haxegui.controls.Input,
			Label				: haxegui.controls.Label,
			ProgressBar			: haxegui.controls.ProgressBar,
			RadioButton			: haxegui.controls.RadioButton,
			ScrollBar			: haxegui.controls.ScrollBar,
			Slider				: haxegui.controls.Slider,
			Stepper				: haxegui.controls.Stepper,
			Tree				: haxegui.controls.Tree,
			UiList				: haxegui.controls.UiList,
		});
		//}}}


		//{{{ toys
		interp.variables.set("toys",
		{
			AnalogClock			: haxegui.toys.AnalogClock,
			Arrow				: haxegui.toys.Arrow,
			Balloon				: haxegui.toys.Balloon,
			Circle				: haxegui.toys.Circle,
			Curvy				: haxegui.toys.Curvy,
			Knob				: haxegui.toys.Knob,
			Line				: haxegui.toys.Line,
			Note				: haxegui.toys.Note,
			Patch				: haxegui.toys.Patch,
			Pin					: haxegui.toys.Pin,
			Rectangle			: haxegui.toys.Rectangle,
			SevenSegment		: haxegui.toys.SevenSegment,
			Socket				: haxegui.toys.Socket,
			Transformer			: haxegui.toys.Transformer
		}
		);
		//}}}
	}
	//}}}


	//{{{ Keyboard
	//grep -e "static var" /usr/share/haxe/std/flash9/ui/Keyboard.hx | awk '{print "\t\t\t",$3," : Keyboard.",$3,","}' >> haxegui/utils/ScriptStandardLibrary.hx
	private static function keyboard() : Dynamic {
		return {
			BACKSPACE  : Keyboard.BACKSPACE,
			CAPS_LOCK  : Keyboard.CAPS_LOCK,
			CONTROL  : Keyboard.CONTROL,
			DELETE  : Keyboard.DELETE,
			DOWN  : Keyboard.DOWN,
			END  : Keyboard.END,
			ENTER  : Keyboard.ENTER,
			ESCAPE  : Keyboard.ESCAPE,
			F1  : Keyboard.F1,
			F10  : Keyboard.F10,
			F11  : Keyboard.F11,
			F12  : Keyboard.F12,
			F13  : Keyboard.F13,
			F14  : Keyboard.F14,
			F15  : Keyboard.F15,
			F2  : Keyboard.F2,
			F3  : Keyboard.F3,
			F4  : Keyboard.F4,
			F5  : Keyboard.F5,
			F6  : Keyboard.F6,
			F7  : Keyboard.F7,
			F8  : Keyboard.F8,
			F9  : Keyboard.F9,
			HOME  : Keyboard.HOME,
			INSERT  : Keyboard.INSERT,
			LEFT  : Keyboard.LEFT,
			NUMPAD_0  : Keyboard.NUMPAD_0,
			NUMPAD_1  : Keyboard.NUMPAD_1,
			NUMPAD_2  : Keyboard.NUMPAD_2,
			NUMPAD_3  : Keyboard.NUMPAD_3,
			NUMPAD_4  : Keyboard.NUMPAD_4,
			NUMPAD_5  : Keyboard.NUMPAD_5,
			NUMPAD_6  : Keyboard.NUMPAD_6,
			NUMPAD_7  : Keyboard.NUMPAD_7,
			NUMPAD_8  : Keyboard.NUMPAD_8,
			NUMPAD_9  : Keyboard.NUMPAD_9,
			NUMPAD_ADD  : Keyboard.NUMPAD_ADD,
			NUMPAD_DECIMAL  : Keyboard.NUMPAD_DECIMAL,
			NUMPAD_DIVIDE  : Keyboard.NUMPAD_DIVIDE,
			NUMPAD_ENTER  : Keyboard.NUMPAD_ENTER,
			NUMPAD_MULTIPLY  : Keyboard.NUMPAD_MULTIPLY,
			NUMPAD_SUBTRACT  : Keyboard.NUMPAD_SUBTRACT,
			PAGE_DOWN  : Keyboard.PAGE_DOWN,
			PAGE_UP  : Keyboard.PAGE_UP,
			RIGHT  : Keyboard.RIGHT,
			SHIFT  : Keyboard.SHIFT,
			SPACE  : Keyboard.SPACE,
			TAB  : Keyboard.TAB,
			UP  : Keyboard.UP,
			capsLock : Keyboard.capsLock,
			numLock : Keyboard.numLock,
			isAccessible : Keyboard.isAccessible,
		};
	}
	//}}}
	//}}}
}
