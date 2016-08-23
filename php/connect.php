<?php
include "cfg.php";

mysql_connect($Host, $User, $Pass) or die("Dommage");
mysql_select_db($Base) or die("Dommage");

$sql = "SELECT * FROM admin WHERE pass= '".md5($_POST['var1'])." ' ";
$req = mysql_query($sql) ;

if(mysql_num_rows($req) == 1){
	echo "1"; 
}else{
	echo "0"; 
}
?>