<?php


	$Base = "carminopmag";
	$User = "carminopmag";
	$Pass = "AgojjsGK";
	$Host = "mysql5-8.90";
	
mysql_connect($Host, $User, $Pass) or die("Dommage");
mysql_select_db($Base) or die("Dommage");

	
/*	
* 
* 
* CODE A UTLISIER
* 
* $maj = "UPDATE cric_page SET page=page+1 WHERE page>18 ";
	$result = mysql_query($maj);
	
	echo $result;
	echo mysql_error();*/
?>