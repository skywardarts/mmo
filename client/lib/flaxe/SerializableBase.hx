package flaxe;

interface SerializableBase
{
	function pack(data:flash.utils.ByteArray):Void;
	function unpack(data:flash.utils.ByteArray):Void;
}
