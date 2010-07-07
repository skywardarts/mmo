<?php

class cron
{
	public function __construct()
	{
		$this->children = array();
	}

	public function add($callback, $timeout, $timestamp = NULL)
	{
		if($timestamp === NULL)
			$timestamp = time();

		array_push($this->children, array("callback" => $callback, "timeout" => $timeout, "timestamp" => $timestamp));
	}

	public function update()
	{
		$timestamp = time();

		foreach($this->children as &$child)
		{
			if(($timestamp - $child['timestamp']) < $child['timeout'])
				continue; // we aren't ready for this child yet

			$child['timestamp'] = $timestamp;

			if($child['callback'])
				$child['callback']();
		}
	}

	public $children;
}

?>