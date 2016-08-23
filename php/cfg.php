<?php

if($_SERVER['HTTP_HOST']== "localhost" || $_SERVER['HTTP_HOST']== "127.0.0.1"){
	$Base = "lecric";
	$User = "root";
	$Pass = "";
	$Host = "127.0.0.1";



	$domain = "http://localhost/dev/lecric/";
	$phpdir = "http://localhost/dev/lecric/php/";
	$imgdir = "http://localhost/dev/lecric/img/";

}else{
	$Base = "";
	$User = "";
	$Pass = "";
	$Host = "";

	$domain = "";
}


	// Magazine number/folder -> 1/
	$mag = "2/";


function secure($text){
	$search = "/[^a-zA-Z0-9\s-_.]/";
	$replace = "";
	$text = preg_replace($search, $replace, $text);
	return $text;
}

?>