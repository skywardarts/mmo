import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

class AbstractBase
{
	public function AbstractBase()
	{
		if(getQualifiedSuperclassName(this).substr(-8) == "Abstract")
			throw new Error(getQualifiedClassName(this) + " is abstract and must be extended.");
	}
}
