//
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
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import flash.ui.Mouse;
import haxe.Timer;
import haxegui.Window;
import haxegui.containers.Container;
import haxegui.controls.Component;
import haxegui.controls.Image;
import haxegui.controls.ScrollBar;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.logging.ErrorType;
import haxegui.logging.ILogger;
import haxegui.logging.LogLevel;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Printing;
import haxegui.utils.Size;
import haxegui.windowClasses.TitleBar;
import hscript.Expr;
import hscript.Parser;
//}}}


using haxegui.controls.Component;
using haxegui.utils.Color;


/**
*
* Console for debugging, one [TextField] tracing messages and another parsing hscript.<br/>
* <p>The console implements psuedo-filesystem access to the display list. Type [help] in the console to list commands.</p>
*
* @todo update the docs
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class Console extends Window, implements ILogger {

	//{{{ Members
	/** hscript parser **/
	var parser : hscript.Parser;


	/**
	* hscript interpreter
	*
	* can be used in the console like this:
	* <pre class="code haxe">
	* // returns [object Interp]
	* this.interp
	*
	* // returns the interpreter's variables hash, where objects are packages and fields are classes
	* this.interp.variables
	* </pre>
	**/
	var interp : hscript.Interp;


	/** the console's input history, press up to pop a command **/
	var history : Array<String>;


	/**
	* the current console "working directory"
	* the [_pwd] variable is for internal use, use "pwd" in the console:
	* <pre class="code haxe">
	* pwd.move(20,20);
	* </pre>
	**/
	var _pwd : DisplayObjectContainer;


	/**
	* the current console "working directory", in its array form.
	* you can use it with commands like:
	* <pre class="code haxe">
	* this.pwd.push("Container20");
	* this.pwd.pop();
	* this.pwd = "root.Window13.ScrollPane18.Container20.Button24".split(".");
	* </pre>
	**/
	var pwd : Array<String>;


	var watchTimer : Timer;
	var ctrlKey : Bool;

	public var container : Container;
	public var output : TextField;
	public var input : TextField;
	public var vert : ScrollBar;
	//}}}

	static var xml = Xml.parse(	'
	<haxegui:Layout name="Console">
		<haxegui:containers:Container name="Container">
			<haxegui:controls:ScrollBar name="ScrollBar" top="0" bottom="0" right="0" color="0x444444" scroll="1"/>
		</haxegui:containers:Container>
	</haxegui:Layout>
	').firstElement();


	//{{{ Constructor
	public override function new (?parent:DisplayObjectContainer=null, ?name:String=null, ?x:Float, ?y:Float) {
		super(parent, "Console", x, y);
	}
	//}}}


	///{{{ Functions
	//{{{ init
	public override function init(?opts:Dynamic) {
		type = WindowType.ALWAYS_ON_TOP;
		minSize = new Size(124,60);

		// TitleBar.iconFile = "utilities-terminal.png";

		super.init(opts);


		xml.set("name", name);

		XmlParser.apply(Console.xml, this);



		box = new Size(640, 260).toRect();


		// container = new Container(this, "Container", 10, 20);
		// container.init();
		container = cast this.getChildByName("Container");


		// Output TextField for trace and log messages
		output = new TextField();
		output.name = "output";
		output.htmlText = "";
		output.width = box.width - 40;
		output.height = box.height - 70;
		output.border = true;
		output.wordWrap = true;
		output.multiline = true;
		output.autoSize = flash.text.TextFieldAutoSize.NONE;
		output.type = flash.text.TextFieldType.DYNAMIC;
		output.selectable = true;
		output.mouseEnabled = true;
		output.focusRect = true;
		output.tabEnabled = true;
		output.mouseWheelEnabled = true;
		output.defaultTextFormat = DefaultStyle.getTextFormat();


		// Input TextField for hscript execution
		input = new TextField();
		input.name = "input";
		input.defaultTextFormat = DefaultStyle.getTextFormat(8, Color.WHITE);
		input.type = flash.text.TextFieldType.INPUT;
		input.background = true;
		input.backgroundColor = 0x4D4D4D;
		input.border = true;
		input.width = box.width - 40;
		input.height = 20;
		input.selectable = true;


		input.addEventListener (KeyboardEvent.KEY_DOWN, onInputKeyDown);
		input.addEventListener (KeyboardEvent.KEY_UP, onInputKeyUp);
		// input.addEventListener (Event.COPY, onInputCopy);


		// Container
		container.color = Opts.optInt(opts,"bgcolor", Color.BLACK.tint(.9));
		container.alpha = Opts.optFloat(opts, "bgalpha", 0.85);


		container.addChild(output);
		container.addChild(input);

		// Vertical Scrollbar
		// vert = new ScrollBar(container, "vscrollbar");
		// vert.init({target : output, color: this.color});
		vert = cast container.getChildByName("ScrollBar");
		vert.color = this.color;
		vert.scrollee = output;
		vert.removeEventListener(ResizeEvent.RESIZE, vert.onParentResize);
		// vert.removeEventListener(Event.SCROLL, vert.onTextFieldScrolled);
		// output.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
		vert.adjust();

		// Shell
		pwd 	= ["root"];
		_pwd 	= cast root;
		history = new Array<String>();
		parser  = new hscript.Parser();
		interp  = new hscript.Interp();


		var self = this;
		haxegui.utils.ScriptStandardLibrary.set(interp);
		interp.variables.set( "console", this );
		interp.variables.set( "pwd", pwd);
		interp.variables.set( "this", getPwd() );

		interp.variables.set( "help", help() );
		interp.variables.set( "clear", function(){ self.clear(); } );
		interp.variables.set( "print_r", Printing.print_r );
		interp.variables.set( "history", history );
		interp.variables.set( "interp", interp );
		interp.variables.set( "dir", function() { trace( self.interp.variables); } );
		interp.variables.set( "get", function() { self.getPwdOnNextClick(); } );
		interp.variables.set( "tree", function() { Printing.print_r(self._pwd); } );
		interp.variables.set( "where", function() { trace(untyped self._pwd.name+" "+self._pwd.box.toString().substr(1).split("=").join("='").split(",").join("'").split(")").join("'").split("h").join("height").split("w").join("width")); });

		interp.variables.set( "note", function() new haxegui.toys.Note(flash.Lib.current.stage.mouseX, flash.Lib.current.stage.mouseY).init() );
		interp.variables.set( "pin", function() new haxegui.toys.Pin(flash.Lib.current.stage.mouseX, flash.Lib.current.stage.mouseY).init() );

		var self = this;
		interp.variables.set( "watch", function(o:Dynamic, ?args:Array<Dynamic>, ?interval:Int=100) {
			if(o==null) return;
			if(args==null) args=[];

			if(self.watchTimer!=null)
			self.watchTimer.stop();
			self.watchTimer = new haxe.Timer(interval);
			self.watchTimer.run = function() {
			self.clear();
			if(Reflect.isObject(o))
				trace(o);
			else
			if(Reflect.isFunction(o))
				trace(Reflect.callMethod(o, o, args));
			}

		});

		interp.variables.set( "unwatch", function() { if(self.watchTimer!=null) self.watchTimer.stop(); });

			interp.variables.set( "cd", function(?v) {
			if(v==null) return "";
			switch(v) {
				case ".":
				case "..":
				self.pwd.pop();
				case "/":
				self.pwd = ["root"];
				default:
				var tmpPwd = new Array<String>().concat(self.pwd);
				tmpPwd.push(v);

				var o = cast flash.Lib.current;
				for(i in 1...tmpPwd.length) {
				if(o.getChildByName(tmpPwd[i])==null) return v+": No such object";
				o = cast(o.getChildByName(tmpPwd[i]), flash.display.DisplayObjectContainer);
				self._pwd = cast o;
				}

				self.pwd.push(v);
			}
			return self.pwd.join(".");
		});


		interp.variables.set( "ls", function(?d,?v) {
			// trace(v+" "+h);

			var o = cast flash.Lib.current;
			for(i in 1...self.pwd.length)
			o = untyped o.getChildByName(self.pwd[i]);

			// if(d!=null && d!="")
			// o = untyped o.getChildByName(d);

			var txt="\n";
			if(v)
			for(i in 0...o.numChildren) {
				if(Std.is(o.getChildAt(i), Component)) {
				txt += StringTools.lpad(o.getChildAt(i).created, " ", 6) + "\t";
				txt += StringTools.lpad(o.getChildAt(i).id, " ", 6) + "\t";
				}
				else
				txt += StringTools.lpad("", " ", 12) + "\t\t";

				txt += StringTools.rpad(o.getChildAt(i).name, " ", 25) + "\t";
				txt += Type.getClassName(Type.getClass(o.getChildAt(i)));
				txt += "\n";
			}
			else
			for(i in 0...o.numChildren) {
				txt += o.getChildAt(i).name + "\t";
				txt += "\t";
			}


			trace(txt);
		});

	}
	//}}}


	//{{{ onResize
	override public function onResize (e:ResizeEvent) : Void {
		if(vert==null) return;


		super.onResize(e);


		output.width = box.width - 30;
		output.height = box.height - 40;


		input.width = box.width - 30;
		input.y = box.height - 40;

/*
		vert.box.height = box.height - 20;
		vert.x = box.width - 30;
		vert.down.y = Math.max( 20, box.height - 40);
		vert.dirty = true;
		vert.frame.dirty = true;
		vert.handle.y = Math.min( vert.handle.y, vert.box.height - vert.handle.box.height - 20 );
		vert.handle.y = Math.max( vert.handle.y, 20 );
*/
	}
	//}}}

	public function onScroll(e:MouseEvent) {
		 // trace(e);
		 // vert.adjustment.setValue(output.scrollV/output.maxScrollV);
		 // e.preventDefault();

		 // vert.adjust(output.scrollV/output.maxScrollV);

	}


	//{{{ onInputFocusChanged
	/**
	* Called in respose to a TAB key press, handles auto-completion
	*/
	public function onInputFocusChanged(e:FocusEvent) {
		e.preventDefault();
		flash.Lib.current.stage.focus = cast e.target;

		var lastChar = input.text.charAt(input.text.length-1);

		for(i in 0..._pwd.numChildren) {
			var child = _pwd.getChildAt(i);
			if(child.name.charAt(0)==lastChar) {
			input.text += child.name.substr(1, child.name.length-1);
			input.setSelection(input.text.length, input.text.length);
			break;
			}
		}
/*
		for(f in Reflect.fields(_pwd)) {
			if(f.charAt(0)==lastChar) {
			input.text += f.substr(1, f.length-1);
			input.setSelection(input.text.length, input.text.length);
			input.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, onInputFocusChanged);
			return;
			}
		}
*/
		input.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, onInputFocusChanged);
	}
	//}}}

	//{{{
	public function onInputKeyUp(e:KeyboardEvent) : Void {
	}
	//}}}



	//{{{ onInputKeyDown
	/** Process keyboard input **/
	public function onInputKeyDown(e:KeyboardEvent) : Void {

		switch(e.keyCode) {
			case Keyboard.ENTER :
			if(input.text=="")	{
				trace("");
				return;
			}

			// text replacement for shell functions
			if(input.text.substr(0,2)=="ls") {
				var args = input.text.split(" ");
				args.reverse();

				var dir = null;
				// dir = args.pop();

				var la = false;
				for(a in args)
				if(a=="-l" || a=="-la") la=true;

				input.text="ls('"+dir+"',"+la+")";
			}


			if(input.text.substr(0,2)=="cd") {
				var dir=input.text.split(" ").pop();
				if(dir!="cd")
				input.text="cd('"+dir+"')";
			}

			// convert shell commands to functions by adding brackets
			var r = ~/^(clear|dir|get|where)/gm;
			input.text = r.replace(input.text, "$1()");


			// set the program
			var program = parser.parseString(input.text);

			// set the current pwd
			interp.variables.set("this", getPwd());

			// this exports children
			for(i in 0...getPwd().numChildren)
				interp.variables.set( getPwd().getChildAt(i).name, getPwd().getChildAt(i));

			// this exports members
			for(f in Reflect.fields(getPwd()))
				interp.variables.set(f, Reflect.field(getPwd(),f));

			// clear the command and push to history
			history.push(input.text);
			input.text = "";


			try {
				// execute
				var rv = interp.execute(program);
				if(rv!=null)
				trace(rv);
			}
			catch(e:hscript.Error) {
				switch(e) {
					case EUnknownVariable(v):
					switch(v) {
						default:
						log("Unknown variable: "+"<B>"+v+"</B>", ErrorType.ERROR);
					}
					case EUnexpected(s):
					switch(s) {
						case "<eof>":
						log("Unexpected: "+"<B>"+s+"</B>", ErrorType.ERROR);

						default:
						log("Unexpected: "+"<B>"+s+"</B>", ErrorType.ERROR);
					}
					case EUnterminatedString:
					trace(e);
					default:
					trace(e);
				}
			}
			catch(e : Dynamic) {

				trace(e);
			}

			case Keyboard.TAB:
			input.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onInputFocusChanged, false, 0, true);

			case Keyboard.UP :
			input.text = history.pop();
		}
	}
	//}}}


	//{{{ getPwdOnNextClick
	public function getPwdOnNextClick() {
		stage.addEventListener(MouseEvent.MOUSE_DOWN, getPwdFromClick, false, 0, true);
		trace("Waiting for click event....");
	}
	//}}}


	//{{{ getPwdFromClick
	public function getPwdFromClick(e:MouseEvent) {
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, getPwdFromClick);
		_pwd = Component.asComponent(e.target);
		//pwd = e.target.ancestors().join(".");
		var o = _pwd;
		pwd = [];
		while(o!=flash.Lib.current) {
			pwd.push(o.name);
			o = o.parent;
		}
		pwd.push("root");
		pwd.reverse();
		trace(e.target);
	}
	//}}}


	//{{{ getPwd
	/**
	* Traverses the display list according to the current path
	* @return The DisplayObject of the current "working directory"
	**/
	public function getPwd() : Dynamic {
		var o = cast flash.Lib.current;
		for(i in 1...pwd.length)
		o = cast(o.getChildByName(pwd[i]), flash.display.DisplayObjectContainer);
		_pwd = cast o;
		return _pwd;
	}
	//}}}


	//{{{ clear
	/** Clear the output **/
	public function clear() : Void {
		this.output.text = "";
		trace("");
	}
	//}}}


	//{{{ help
	/**
	* @return Short help for available console commands
	**/
	public function help() : String {
		var text = "\n";
		var commands = {
			pwd 	 : "\tcurrent path",
			cd 		 : "\tpush an object name to current path, ex. cd Component, cd .., cd /",
			ls		 : "\tprints current object",
			get 	 : "\tgrab the path target from next mouse click",
			dir		 : "\tprints the interpreter's variables list",
			clear 	 : "clear the console",
			help 	 : "display this help",

		}

		for(i in Reflect.fields(commands))
		text += "\t<I>" + i + "</I>\t\t" + Reflect.field(commands, i) + "\n";

		return text;
	}
	//}}}


	//{{{ log
	/**
	* Log a message to console<br/>
	*
	* @param msg	 Object to log, can be text, events and errors.
	* @param inf	 here
	* @param error	 Optional error level
	**/
	public function log( msg : Dynamic, ?inf : haxe.PosInfos, ?error:ErrorType ) : Void {
		if(msg==null) return;

		var text =  "<FONT FACE='MONO' SIZE='10' COLOR='#eeeeee'>";
		text += DateTools.format (Date.now (), "%H:%M:%S") + " " ;

		#if debug
		if(inf != null) {
			text += inf.fileName + ":" + inf.lineNumber + ":";
		}
		#end

		text += pwd.join(".") + "~> ";

		switch(Type.typeof(msg)) {
			case TClass(c):
			case TEnum(e):
			switch(Type.getEnumName(e)) {
				case "hscript.Error":
				error = ErrorType.ERROR;
			}
			case TFunction:
			text += "<FONT COLOR='#FFC600'>FUNCTION</FONT>: ";
			default:
		}

		switch(error) {
			case ErrorType.ERROR:
			text += "<FONT COLOR='#FF0000'>ERROR</FONT>: ";
			case ErrorType.WARNNING:
			text += "<FONT COLOR='#FF7700'>WARNNING</FONT>: ";
			case ErrorType.NOTICE:
			text += "<FONT COLOR='#FF7700'>NOTICE</FONT>: ";
			case ErrorType.INFO:
			text += "<FONT COLOR='#FF7700'>INFO</FONT>: ";
		}

		text += msg ;

		output.htmlText += text;
		output.htmlText += "</FONT>";
		output.scrollV = output.maxScrollV + 1;
	}
	//}}}
	//}}}
}
