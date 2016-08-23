<?php
	if($_FILES){
		include "cfg.php";
		global $mag;
		$snddir = '../mag2/snd/';

		$uploadfile = $mag . time() . "-" . secure(basename($_FILES['Filedata']['name'], ".mp3"));

		if (move_uploaded_file($_FILES['Filedata']['tmp_name'], $snddir . $uploadfile . ".mp3")) {
			echo $uploadfile . ".mp3";
		}/*else{
			echo $imgdir . $uploadfile;
		}*/
	}
?>