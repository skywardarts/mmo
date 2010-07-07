<?php

class resource_service
{
	public static function register(&$resource)
	{
		$id = rand(0, 32768);

		while(isset(self::$registry[$id]))
			$id = rand(0, 32768);

		self::$registry[$id] = &$resource;

		return $id;
	}

	public static function unregister($id)
	{
		$resource = &self::$registry[$id];

		unset(self::$registry[$id]);

		return $resource;
	}

	private static $registry;
}

class lambda
{
	public function __construct(Closure $closure)
	{
		$this->closure = $closure;
	}

	public function __invoke()
	{
		return call_user_func_array($this->closure, func_get_args());
	}

	public function __sleep()
	{
		$this->resource_id = resource_service::register($this->closure);

		return array("resource_id");
	}

	public function __wakeup()
	{
		$this->closure = &resource_service::unregister($this->resource_id);
	}

	private $closure;
}

?>