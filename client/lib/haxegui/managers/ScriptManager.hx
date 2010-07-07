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


//{{{ imports
import flash.display.DisplayObject;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.TypedDictionary;

import haxegui.controls.Component;
import haxegui.utils.ScriptStandardLibrary;
import haxegui.managers.CursorManager;

import hscript.Expr;
import hscript.Interp;
//}}}


//{{{ ScriptObject
/** Typed object for managing scripts **/
typedef ScriptObject = {
	var interp  : Interp;
	var program : Expr;
	var setup   : Interp->DisplayObject->Dynamic->Void;
	var code    : String;
}
//}}}


//{{{ ScriptManager
/**
*
* ScriptManager handles running scripts for styling controls
*
* @version 0.1
* @author Russell Weir <damonsbane@gmail.com>
* @author Omer Goshen <gershon@goosemoose.com>
*/
class ScriptManager implements Dynamic {

	//{{{ Members
	//{{{ Public
	public static var debug 		: Bool = false;
	public static var debug_events  : Array<String> = new Array<String>();
	//}}}


	//{{{ Static
	static var defaultActions 		: Hash<ScriptObject>;
	static var instanceActions 		: TypedDictionary<Component,Hash<ScriptObject>>;
	static var initialized 			: Bool;
	//}}}
	//}}}


	//{{{ Functions
	//{{{ commonSetup
	/** Sets the default variables **/
	public static function commonSetup(interp:Interp, obj:DisplayObject, opts:Dynamic) : Void {
		for(f in Reflect.fields(opts))
		interp.variables.set(f, Reflect.field(opts,f));
	}
	//}}}


	//{{{ doCall
	/**
	* Inlined method for exec, for readability. Returns result of executed code
	*/
	private static inline function doCall(inst:Component,so:ScriptObject,options:Dynamic) : Dynamic {
		var rv = null;
		if(so != null) {
			if(so.setup != null)
			so.setup(so.interp,inst,options);
			so.interp.variables.set("this",inst);
			so.interp.variables.set("parent",inst.parent);
			rv = so.interp.execute( so.program );
		}
		return rv;
	}
	//}}}


	//{{{ exec
	/**
	* Execute a script for a particular Component
	*
	* @param inst The component executing the script ("this")
	* @param action An action type
	* @param options Object with key->value mapping of vars to pass to script
	**/
	public static function exec(inst:Component, action:String, options:Dynamic) : Dynamic {
		try {
			if(ScriptManager.debug) {
				if(debug_events != null && Lambda.has(debug_events, action)) {
					var a = getInstanceActionObject(inst, action);
					if(a != null && a.code != null)
					trace(a.code);
				}
			}
			return doCall(inst, getInstanceActionObject(inst, action), options);
		} catch(e:Dynamic) {
			if(e != "No default action.") {
				trace(inst.toString() + " " + action + " script error : " + e);
				// for(stackItem in haxe.Stack.exceptionStack()) trace(stackItem);
				// trace( haxe.Stack.toString(haxe.Stack.callStack()) );
			}
		}
		return null;
	}
	//}}}


	//{{{ getDefaultActionObject
	/**
	* Returns the default ScriptObject for the classType, throwing an error
	* if it does not exist.
	*
	* @param classType
	* @param action ScriptManager action var name
	* @return ScriptObject which is the default for the Component type
	* @throws String "No default action." if a default action does not exist
	**/
	public static function getDefaultActionObject(classType:Class<Dynamic>, action:String) : ScriptObject {
		var key = getDefaultActionKey(classType, action);
		if(!defaultActions.exists(key) || defaultActions.get(key) == null) {
			var sc = Type.getSuperClass(classType);
			if(sc == null)
			throw "No default action.";
			return getDefaultActionObject(sc, action);
		}
		return(defaultActions.get(key));
	}
	//}}}


	//{{{ getDefaultActionKey
	/**
	* Returns the key for the default action for the given Component instance
	*
	* @return String key used to index the defaultActions Hash
	**/
	private static inline function getDefaultActionKey(classType:Class<Dynamic>, action:String) : String {
		return Type.getClassName(classType) + "." + action;
	}
	//}}}


	//{{{ getInstanceOwnActionObject
	/**
	* Finds the best script for a Component instance for a given action.
	* If the instance has it's own script, that is returned, otherwise
	* the default for the instance's class type is returned, if any.
	*
	* @param inst A Component
	* @param action Action type
	* @return ScriptObject, either the instance one, or the default for the class
	* @throws String on error
	**/
	public static function getInstanceActionObject(inst:Component, action:String) : ScriptObject {
		var so = getInstanceOwnActionObject(inst, action);
		if(so != null)
		return so;
		return getDefaultActionObject(Type.getClass(inst), action);
	}
	//}}}


	//{{{ getInstanceOwnActionObject
	/**
	* Finds the ScriptObject for an action on a Component instance.
	*
	* @param inst A Component
	* @param action Action type
	* @return ScriptObject or null if component instance has no action
	**/
	public static function getInstanceOwnActionObject(inst:Component, action:String) : ScriptObject	{
		if(instanceActions.exists(inst))
		return instanceActions.get(inst).get(action);
		else
		return null;
	}
	//}}}


	//{{{ setDefaultScript
	/**
	* Sets the hscript for a particular event. All events are the same names as the
	* public fields of the ScriptManager instance.
	*
	* @param action An action name
	* @param code The code to execute.
	* @param init The initialization function for the interpreter, which is run once
	* @param setup The function called each time a display object needs to run the script
	* @throws String if action is invalid
	**/
	public static function setDefaultScript(classType : Class<Dynamic>, action:String, code:String, init:Interp->Void=null, setup:Interp->DisplayObject->Dynamic->Void=null) {
		if(!initialized) initialize();
		var parser = new hscript.Parser();
		var program = parser.parseString((code==null) ? "" : code);
		var interp = new hscript.Interp();
		if(init != null)
		init(interp);
		else
		ScriptStandardLibrary.set(interp);
		if(setup == null)
		setup = commonSetup;


		var key = getDefaultActionKey(classType,action);
		if(defaultActions.exists(key)) return defaultActions.get(key).code;

		defaultActions.set(key, { interp: interp, program: program, setup: setup, code: code });

		return code;
	}
	//}}}


	//{{{ setInstanceScript
	/**
	* Sets the hscript for a particular event. All events are the same names as the
	* public fields of the ScriptManager instance.
	*
	* @param action An action name
	* @param code The code to execute.
	* @param init The initialization function for the interpreter, which is run once
	* @param setup The function called each time a display object needs to run the script
	* @return The code provided, for chaining in setters.
	* @throws String if action is invalid
	**/
	public static function setInstanceScript(
	inst : Component,
	action:String,
	code:String,
	init:Interp->Void=null,
	setup:Interp->DisplayObject->Dynamic->Void=null) : String
	{
		if(!initialized) initialize();
		var classType = Type.getClass(inst);
		var parser = new hscript.Parser();
		var program = parser.parseString((code==null) ? "" : code);
		var interp = new hscript.Interp();
		if(init != null)
		init(interp);
		else
		ScriptStandardLibrary.set(interp);
		if(setup == null)
		setup = commonSetup;

		if(!instanceActions.exists(inst))
		instanceActions.set(inst, new Hash<ScriptObject>());
		instanceActions.get(inst).set(action,
		{
			interp:interp,
			program: program,
			setup: setup,
			code: code,
		});
		return code;
	}
	//}}}


	//{{{ redirectTraces
	/**
	* Redirect "trace" calls to a new handler.
	*
	* @param func A Dynamic->?haxe.PosInfos->Void logging function
	*/
	public static function redirectTraces(f:Dynamic) {
		for(so in defaultActions) {
			so.interp.variables.set( "trace", f );
		}
		for(comp in instanceActions) {
			var hash = instanceActions.get(comp);
			for(so in hash) {
				so.interp.variables.set( "trace", f );
			}
		}
	}
	//}}}


	//{{{ initialize
	public static function initialize() {
		if(initialized) return;
		initialized = true;
		defaultActions = new Hash<ScriptObject>();
		// uses weak keys so when instance is gone, so is the script object.
		instanceActions = new TypedDictionary<Component,Hash<ScriptObject>>(true);
	}
	//}}}


	//{{{ __init__
	static function __init__() : Void {
		initialize();
	}
	//}}}
	//}}}
}
//}}}

