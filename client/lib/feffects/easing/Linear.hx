package feffects.easing;

class Linear implements haxe.Public
{
	inline static function easeNone ( t : Float, b : Float, c : Float, d : Float ) : Float
	{
		return c * t / d + b;
	}
	
	inline static function easeIn ( t : Float, b : Float, c : Float, d : Float ) : Float
	{
		return c * t / d + b;
	}
	
	inline static function easeOut ( t : Float, b : Float, c : Float, d : Float ) : Float
	{
		return c * t / d + b;
	}
	
	inline static function easeInOut ( t : Float, b : Float, c : Float, d : Float ) : Float
	{
		return c * t / d + b;
	}
}
