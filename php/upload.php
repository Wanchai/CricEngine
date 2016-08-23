<?php
	if($_FILES){
		include "cfg.php";
		global $mag;
		$imgdir = '../mag2/img/';

		$uploadfile = $mag . time() . "-" . secure(basename($_FILES['Filedata']['name']));

		if (move_uploaded_file($_FILES['Filedata']['tmp_name'], $imgdir . $uploadfile)) {
			echo $uploadfile;
		}else{
			echo $imgdir . $uploadfile;
		}
	}
?>