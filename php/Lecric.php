<?php
session_name('CRIC');
session_start();

// THIS FILE IS FOR THE MAGVIEW PART

include "cfg.php";

mysql_connect($Host, $User, $Pass) or die("Dommage");
mysql_select_db($Base) or die("Dommage");

//if($_SESSION["Sview"] == "ok"){
	class Lecric {
		// ******************* VIEW ********************
		// --- SELECT
		function selectBlocs($page, $mag){
			$sql = "SELECT * FROM cric_bloc WHERE id_mag=$mag AND id_page=$page ORDER BY level DESC";
			$req = mysql_query($sql) ;
			$arr;
			
			while($top = mysql_fetch_object($req)){
				$arr [] = $top;
			}
			return ($arr) ? $arr : "Nothing on DB";
		}
		function selectPages($id_mag){
			$sql = "SELECT id AS data, page AS label, title FROM cric_page WHERE id_mag=$id_mag ORDER BY page ASC";
			$req = mysql_query($sql) ;
			
			while($top = mysql_fetch_object($req)){
				$arr[] = $top;
			}
			return $arr;
		}
		function selectPages2($id_mag){
			//$sql = "SELECT id AS data, page AS label, title FROM cric_page WHERE id_mag=$id_mag ORDER BY page ASC";
			$sql = "SELECT id AS data, title AS label FROM cric_page WHERE id_mag=$id_mag ORDER BY page ASC";
			$req = mysql_query($sql) ;
			
			while($top = mysql_fetch_object($req)){
				$arr[] = $top;
			}
			return $arr;
		}
	}
//}