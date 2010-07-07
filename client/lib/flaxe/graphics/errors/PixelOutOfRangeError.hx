package flaxe.graphics.errors;

class PixelOutOfRangeError extends flaxe.core.BasicError
{
	public function new()
	{
		super("PixelOutOfRangeError", "Pixel coordinates are out of range in the data array.", 700);
	}
}
