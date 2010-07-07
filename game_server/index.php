<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once("include/lib/database.php");
require_once("include/lib/rest.php");

$db['master']['mmo'] = array
(
	"host" => "localhost",
	"db" => "mmo",
	"user" => "root",
	"pass" => "",
	"prefix" => ""
);

$database = new database($db);
$database->set_active("master", "mmo");

$rest = new rest(isset($_REQUEST['format']) ? $_REQUEST['format'] : "xml");
$rest->set_setting("caching", false);

$rest->add("post", "register", function($x1) use(&$database)
{
	$array['state'] = 1;

	$username = $_REQUEST['username'];
	$password = md5($_REQUEST['password']);

	$r1 = $database->get_row("SELECT user_id FROM users WHERE user_username = '{$username}'");

	if(!$r1)
		$database->query("INSERT IGNORE INTO users SET user_username = '{$username}', user_password = '{$password}'");
	else
		$array['state'] = 0;


	return $array;
});

$rest->run("get,post", $_GET['virtual_path']);

?>