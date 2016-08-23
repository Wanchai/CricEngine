<?php
session_name('CRIC2');
session_start();

// THIS FILE IS FOR THE CRIC ENGINE

include "cfg.php";

mysql_connect($Host, $User, $Pass) or die("Dommage");
mysql_select_db($Base) or die("Dommage");

if($_SESSION["Sconnect"] == "ok") {
	class Lecric2 {
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
		// ******************* CONNECT ********************
		// --- ADD
		function addPage($id_mag, $page_num = NULL){
			$p;
			if(!$page_num){
				$sql = "SELECT id FROM cric_page WHERE id_mag=$id_mag";
				$req = mysql_query($sql) ;
				$p = mysql_num_rows($req) + 1 ;
				$insert = "INSERT INTO cric_page (id_mag, page) VALUES ($id_mag, $p)";
				$result = mysql_query($insert);			
			}else{
				$p = $page_num;
				$insert = "INSERT INTO cric_page (id_mag, page) VALUES ($id_mag, $page_num)";
				$result = mysql_query($insert);				
			}
			return array("data" => mysql_insert_id(), "label" => $p, "title" => "");
		}
		function addBloc($x, $y, $width, $height, $content, $id_page, $id_mag, $type){
			$insert = "INSERT INTO cric_bloc (x, y, width, height, content, id_mag, id_page, type) VALUES ($x, $y, $width, $height, '$content', $id_mag, $id_page, '$type')";
			$result = mysql_query($insert);
			return mysql_fetch_row(mysql_query("SELECT LAST_INSERT_ID()"));
			//return mysql_insert_id();
			//return $insert;
		}
		// --- UPDATE
		function replaceBgd($tab){
			$sql = "SELECT id, type FROM cric_bloc WHERE type='bgd' AND id_mag='$tab->id_mag' AND id_page='$tab->id_page' ";
			$req = mysql_query($sql) ;
			if(mysql_num_rows($req) == 0){
				$insert = "INSERT INTO cric_bloc (x, y, width, height, content, id_mag, id_page, type, level) VALUES (0, 0, 960, 540, '$tab->content', $tab->id_mag, $tab->id_page, 'bgd', 0)";
				$result = mysql_query($insert);
				return mysql_insert_id();			
			}else{
				$obj = mysql_fetch_object($req);
				$req = "UPDATE lecric_bloc SET content='$tab->content' WHERE id=$obj->id";
				$req = mysql_query($req);
				return "" ;			
			}
		}
		function updatePageTitle($txt, $id){
			$maj = "UPDATE cric_page SET title='$txt' WHERE id=$id ";
			$result = mysql_query($maj);
			return $txt;		
		}
		function updateBloc($x, $y, $width, $height, $content, $id, $level, $bg_color = NULL, $bg_alpha = NULL, $border_color = NULL, $thickness = NULL){
			
			$maj = "UPDATE cric_bloc SET x='$x', y='$y', width='$width', height='$height', content='$content', level=$level, bg_color='$bg_color', bg_alpha='$bg_alpha', border_color='$border_color', thickness='$thickness' WHERE id=$id ";
			$result = mysql_query($maj);
			return $result.$maj;
		}
		function updateLevels($tab){
			foreach($tab as $key=>$value){
				$maj = "UPDATE cric_bloc SET level=$value->level WHERE id=$value->id ";
				$result = mysql_query($maj);
			}
			return "updateLevels";
		}
		// --- DELETE
		function delBloc($id, $content, $type){
			$sql = "DELETE  FROM cric_bloc WHERE id=$id";
			$req = mysql_query($sql) ;
			if($type == "img" && $type == "bgd"){
				$blop = unlink("../../../mag2/img/".$content);
			}else if($type == "snd"){
				$blop = unlink("../../../mag2/snd/".$content);
			}else{
				$blop = "";
			}
			return $blop ;
		}
		function askDB($table, $where){
			$where = ($where != "") ? $where : "1" ;
			$sql = "SELECT * FROM ". $table . " WHERE ". $where;
			$req = mysql_query($sql) ;
			
			while($top = mysql_fetch_object($req)){
				$arr [] = $top;
			}
			return $arr;
		}
	}
}