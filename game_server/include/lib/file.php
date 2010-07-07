<?php

class file
{
	public function __construct($path, $options = NULL)
	{
		$this->path = $path;

		if(!$options)
			return;

		$this->open($options);
	}

	public function __destruct()
	{
		$this->close();
	}

	public function read_line()
	{
		return fgets($this->handle);
	}

	public function read_all()
	{
		$size = filesize($this->path);

		if($size == 0)
			return '';

		return fread($this->handle, $size);
	}

	public function write_all($data)
	{
		fwrite($this->handle, $data);
	}

	public function open($options)
	{
		$this->handle = fopen($this->path, $options);
	}

	public function close()
	{
		if($this->handle)
			fclose($this->handle);
	}

	private $path;
	private $handle;
}

?>