<?php
session_name('CRIC2');
session_start();

class CricCon {

	function checkPass($pass){
		include "cfg.php";

		mysql_connect($Host, $User, $Pass) or die("Dommage");
		mysql_select_db($Base) or die("Dommage");
		
		$sql = "SELECT * FROM cric_admin WHERE pass= '".md5($pass)."' ";
		$req = mysql_query($sql) ;

		if(mysql_num_rows($req) == 1){
			$_SESSION["Sconnect"] = "ok";
			return 1; 
		}else{
			return 0; 
		}
	}
}

?>