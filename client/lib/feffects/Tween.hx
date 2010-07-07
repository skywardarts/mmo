package feffects;

import haxe.FastList;

typedef Easing = Float -> Float -> Float -> Float -> Float

/**
* Class that allows tweening numerical values of an object.<br/>
* Version 1.1.2
* Usage :<br/>
* import feffects.Tween;<br/>
* import feffects.easing.Elastic;<br/>
* ...<br/>
* var t = new Tween( 0, 100, 2000, mySprite, "y", Elastic.easeIn );	// create a new tween with object and property set<br/>
* OR
* var t = new Tween( 0, 100, 2000, Elastic.easeIn );				// create a new tween<br/>
* t.setTweenHandlers( update, end );								// (optional if object and property specified) set the callback functions<br/>
* AND
* t.start();														// start the tween<br/>
* 
* t.setEasing( Elastic.easeIn );									// (optional) set the easing function used to compute values<br/>
* t.seek( 1000 );													// (optional) go to the specified position (in ms)</br>
* t.pause();<br/>
* t.resume();<br/>
* t.reverse();														// reverse the tween from the current position</br>
* t.stop();
*/

class Tween
{
	static var aTweens	= new FastList<Tween>();
	static var aPaused	= new FastList<Tween>();
	static var jsDate	= Date.now().getTime();
	static var interval	= 10;
	static var timer	: haxe.Timer;	
		
	public var duration	(default, null): Int;
	public var position	(default, null): Int;
	public var reversed	(default, null): Bool;
	public var isPlaying(default, null): Bool;
			
	var initVal			: Float;
	var endVal			: Float;
	var startTime		: Int;
	var pauseTime		: Int;
	var offsetTime		: Int;
	var reverseTime		: Int;
	
	var updateFunc		: Float->Void;
	var endFunc			: Float->Void;
	var easingF			: Easing;
	var obj				: Dynamic;
	var prop			: String;
				
	static function AddTween( tween : Tween ) : Void
	{
		aTweens.add( tween ) ;
		timer.run = DispatchTweens;
	}

	static function RemoveTween( tween : Tween ) : Void
	{
		if ( tween == null || timer == null )
			return;
					
		aTweens.remove( tween );
								
		if ( aTweens.isEmpty() && aPaused.isEmpty() )
		{
			timer.stop() ;
			timer = null ;
		}
	}
	
	public static function getActiveTweens() : FastList<Tween>
	{
		return aTweens;
	}
	
	public static function getPausedTweens() : FastList<Tween>
	{
		return aPaused;
	}
	
	static function setTweenPaused( tween : Tween ) : Void
	{
		if ( tween == null || timer == null )
			return;
					
		aPaused.add( tween );
		aTweens.remove( tween );
	}
	
	static function setTweenActive( tween : Tween ) : Void
	{
		if ( tween == null || timer == null )
			return;
					
		aTweens.add( tween );
		aPaused.remove( tween );
	}

	static function DispatchTweens() : Void
	{
		for ( i in aTweens )
			i.doInterval();
	}
		
	/**
	* Create a tween from the [init] value, to the [end] value, while [dur] (in ms)<br />
	* If [obj] & [prop] set, Reflect is used to apply the value to the obj's param
	* There is a default easing equation.
	*/
	
	public function new( init : Float, end : Float, dur : Int, ?obj : Dynamic, ?prop : String, ?easing : Easing )
	{
		initVal = init;
		endVal = end;
		duration = dur;
		this.obj = obj;
		this.prop = prop;
		if ( easing != null )
			easingF = easing;
		else if ( Reflect.isFunction( obj ) )
			easingF = obj;
		else
			easingF = easingEquation;
		isPlaying = false;
	}
	
	public function start() : Void
	{
		if( timer != null )
			timer.stop();
		timer = new haxe.Timer( interval ) ;	
		#if flash
			startTime = flash.Lib.getTimer();
		#elseif js
			untyped startTime = Date.now().getTime() - jsDate;
		#end
		
		if ( duration == 0 )
			endTween();
		else
			Tween.AddTween( this );
		isPlaying = true;
		position = 0;
		reverseTime = startTime;
		reversed = false;
	}
	
	public function pause() : Void
	{
		#if flash
			pauseTime = flash.Lib.getTimer();
		#elseif js
			untyped pauseTime = Date.now().getTime() - jsDate;
		#end
		Tween.setTweenPaused( this );
		isPlaying = false;
	}
	
	public function resume() : Void
	{
		#if flash
			startTime += flash.Lib.getTimer() - pauseTime;
			reverseTime += flash.Lib.getTimer() - pauseTime;
		#elseif js
			untyped startTime += Date.now().getTime() - jsDate - pauseTime;
			untyped reverseTime +=  Date.now().getTime() - jsDate - pauseTime;
		#end
		Tween.setTweenActive( this );
		isPlaying = true;
	}
	
	/**
	* Go to the specified position [ms] (in ms) 
	*/
	public function seek( ms : Int ) : Void
	{
		offsetTime = ms;
	}
		
	/**
	* Reverse the tweeen from the current position 
	*/
	public function reverse() : Void
	{
		reversed = !reversed;
		#if flash
		if ( !reversed )
			startTime += ( flash.Lib.getTimer() - reverseTime ) << 1;
		reverseTime = flash.Lib.getTimer();
		#elseif js
		if ( !reversed )
			untyped startTime += ( Date.now().getTime() - jsDate - reverseTime ) << 1;
		untyped reverseTime = Date.now().getTime() - jsDate;
		#end
	}
	
	public function stop() : Void
	{
		Tween.RemoveTween( this );
		isPlaying = false;
	}
	
	inline function doInterval() : Void
	{
		#if flash
			var stamp = flash.Lib.getTimer();
		#elseif js
			var stamp = Date.now().getTime() - jsDate;
		#end
		
		var curTime = 0;
		untyped{
		if ( reversed )
			curTime = ( reverseTime << 1 ) - stamp - startTime + offsetTime;
		else
			curTime = stamp - startTime + offsetTime;
		}
		
		var curVal = getCurVal( curTime );
		if ( curTime >= duration || curTime <= 0 )
			endTween();
		else
		{
			if ( updateFunc != null )
				updateFunc( curVal );
			if ( prop != null )
				Reflect.setField( obj, prop, curVal );
		}
		position = curTime;						
	}
	
	inline function getCurVal( curTime : Int ) : Float
	{
		return easingF( curTime, initVal, endVal - initVal, duration );
	}

	function endTween() : Void
	{
		RemoveTween( this );
		var val = 0.0;
		if ( reversed )
			val = initVal;
		else
			val = endVal;
		
		if ( updateFunc != null )
			updateFunc( val );
		
		if ( endFunc != null )
			endFunc( val );
			
		if ( prop != null )
			Reflect.setField( obj, prop, val );
	}

	/**
	* Set the [update] event when the value is tweening, and the [end] value when it finished
	*/
	
	public function setTweenHandlers( update : Float -> Void, ?end : Float -> Void ) : Void
	{
		updateFunc = update;
		endFunc = end;
	}
	
	/**
	* Set the [easingFunc] equation to use for tweening
	*/
	public function setEasing( easingFunc : Easing ) : Void
	{
		if ( easingFunc != null )
			easingF = easingFunc;
	}

	inline function easingEquation( t : Float, b : Float, c : Float, d : Float ) : Float
	{
		return c / 2 * ( Math.sin( Math.PI * ( t / d - 0.5 ) ) + 1 ) + b;
	}
}