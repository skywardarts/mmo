<?php

class vector
{
	public function __construct($data)
	{
		$this->data = $data;
	}

	public function get($key, $value)
	{
		if(!$this->data)
			return $value;

		if(!array_key_exists($key, $this->data))
			return $value;

		if(gettype($value) !== gettype($this->data[$key]))
			return $value;

		return $this->data[$key];
	}

	private $data;
}

?>