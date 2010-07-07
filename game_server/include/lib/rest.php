<?php

require_once("xml.php");

class rest
{
	public function __construct($format)
	{
		$this->setting_list = array("caching" => true, "cache_time" => 300);
		$this->format = $format ? strtoupper($format) : "XML";
		$this->list = array("GET" => array(), "POST" => array(), "PUT" => array(), "DELETE" => array());
	}

	public function set_settings($setting_list)
	{
		foreach($setting_list as $name => $value)
			$this->setting_list[$name] = $value;
	}

	public function set_setting($name, $value)
	{
		$this->setting_list[$name] = $value;
	}

	public function run($types, $virtual_path)
	{
		$result = array();

		if($this->setting_list['caching'] && $this->get_cache_handler != NULL && $result = $this->get_cache_handler->__invoke(base64_encode(serialize($_REQUEST)), $this->setting_list['cache_time']))
		{
			
			
		}
		else
		{
			$types = explode(',', strtoupper($types));

			foreach($types as $type)
			if(isset($this->list[$type]))
			foreach($this->list[$type] as $path => $callback)
			{
				if(preg_match("#^" . $path . "$#simU", $virtual_path, $x1))
				{
					if(is_callable($callback))
					{
						//header($type . " 200 OK");

						if(phpversion() >= 5.3)
							$result = $callback($x1);
						else
							call_user_func_array($callback, array($x1));
					}
				}
			}

			if(!$result)
			{
				//header($type . " 404 Not Found");

				$result = "-1";
			}

			if($this->set_cache_handler)
			{
				$this->set_cache_handler->__invoke(base64_encode(serialize($_REQUEST)), $result);
			}
		}

		if($this->format == "XML")
		{
			header("Content-Type: text/xml");

			echo xml_encode($result, "response");
		}
		else if($this->format == "JSON")
		{
			header("Content-Type: text/plain");

			if(isset($_GET['callback']))
				echo $_GET['callback'] . '(' . json_encode($result) . ');';
			else
				echo json_encode($result);
		}
	}

	public function add($type, $path, $callback)
	{
		$type = strtoupper($type);

		$this->list[$type][$path] = $callback;
	}

	public $format;
	public $list;
	public $get_cache_handler;
	public $set_cache_handler;
	public $config_cache_time;
}

?>
