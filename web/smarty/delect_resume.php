<?php

	require_once("plugins/default_head.php");
	$id =$_GET[id];
	
	$ret = $dbclass->delectOnce($id);	
	if($ret=="success"){
			unset($id);
			$smarty->display("insert_success.tpl");
	}
