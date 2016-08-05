<?php
//	require_once('login_check.php');
//	$dbclass = new DateBase;
	session_start();
	
	require_once("plugins/default_head.php");	

	$_post_insert = $_POST;
//	var_dump($_post_insert);	
// 信息格式化	
	if($_post_insert[sex]=="男"){
		$_post_insert[sex]=0;
	}else{
		$_post_insert[sex]=1;
	}
	$btime = $_post_insert[birthday];
	
	$insert_time = date("Y-m-d H:i:s",time());
	$_post_insert[birthday] = $btime;
	$_post_insert[update_time] = $insert_time;
	$_post_insert[user_name] = $_post_insert[last_name1]." ".$_post_insert[first_name1];	

	if($_post_insert[id]){
		$dbclass->updateMess($_post_insert,$_post_insert[id]);
	}else{
		$dbclass->insertMess($_post_insert);
	}
	unset($_SESSION[resume]);

	$smarty->display("insert_success.tpl");
	


	
//	var_dump($_POST);

