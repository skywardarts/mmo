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

//{{{ Imports
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.controls.Component;
//}}}

/**
 * 
 * 
 * 
 * @version 0.1
 * @author Russell Weir <damonsbane@gmail.com>
 * @author Omer Goshen <gershon@goosemoose.com>
 */
class FocusManager extends EventDispatcher, implements Dynamic
{


  private static var _instance:FocusManager = null;

  private static var _focus: DisplayObject;
  
  private static var _oldFocus: DisplayObject;

  private static var _showFocus : Bool;



  public static function getInstance ():FocusManager
  {
    if (FocusManager._instance == null)
      {
        FocusManager._instance = new FocusManager ();
      }
    return FocusManager._instance;
  }



  public function new () {
    super ();
    this.addEventListener (FocusEvent.MOUSE_FOCUS_CHANGE, onFocusChanged);
    this.addEventListener (FocusEvent.KEY_FOCUS_CHANGE, onFocusChanged);
    this.addEventListener (FocusEvent.FOCUS_IN, onFocusChanged);
    this.addEventListener (FocusEvent.FOCUS_OUT, onFocusChanged);
  }

  public override function toString () : String {
    return "FocusManager";
  }

  public function setFocus (o:DisplayObject) {
		//~ return;
	if(o==null || !Std.is(o, Component)) return;
    else
    if(!(cast o).focusable) return;
	
    if( _focus!=o )
    {
        _focus.dispatchEvent (new FocusEvent (FocusEvent.FOCUS_OUT));

        _oldFocus = _focus;
        _focus = o;

        this.dispatchEvent (new FocusEvent (FocusEvent.MOUSE_FOCUS_CHANGE));
        this.dispatchEvent (new FocusEvent (FocusEvent.KEY_FOCUS_CHANGE));

        _focus.addEventListener (FocusEvent.FOCUS_OUT, onFocusChanged);
        _focus.addEventListener (FocusEvent.FOCUS_IN, onFocusChanged);
        _focus.dispatchEvent (new FocusEvent (FocusEvent.FOCUS_IN, false, false));

    }
  }




  public function getFocus ():DisplayObject {
    return _focus;
  }

  public function onFocusChanged(e:FocusEvent) : Void {
    //~ trace(e.type+" "+e.target+"::"+e.target.name);
/*
   if(e.type==FocusEvent.FOCUS_IN) {

    var focusRect = new Sprite();
    focusRect.name = "_focusRect";

    var com = cast(_focus, Component);
    var rect = com.box.clone();
    focusRect.graphics.lineStyle(2, 0xffff00, .5);
    focusRect.graphics.drawRect(-5, -5, rect.width+10, rect.height+10);

    var obj = cast(_focus, DisplayObjectContainer);
    if(obj.numChildren>=1)
        obj.addChildAt(focusRect, obj.numChildren-1);
    else
        obj.addChild(focusRect);
    //~ flash.Lib.current.addChildAt(focusRect, _focus.numChildren-1);
    }
   if(e.type==FocusEvent.FOCUS_OUT) {
    var obj = cast(_focus, DisplayObjectContainer);
    if(obj.numChildren>=1)
    if(obj.getChildByName("_focusRect")!=null)
        obj.removeChild(obj.getChildByName("_focusRect"));

    //~ dispatchEvent (new FocusEvent (FocusEvent.MOUSE_FOCUS_CHANGE));
    }
*/
  }

}
