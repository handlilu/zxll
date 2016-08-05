<?php

	require_once("plugins/default_head.php");
	
	
	
	if($_POST[update]=="ok"){
		$_update_mess=$_POST;
		$id = $_POST[id];
		$_update_mess[user_name] =$_POST[last_name1]." ".$_POST[first_name1];
		$_update_mess[update_time]=time();
		
		$ret = $dbclass->updateMess($_update_mess,$id);
		
		
		echo "<script>this.location='show_resume.php' </script>";
	}else{
	 var_dump($_POST);
    $id =$_POST[id];
    $id_mess=$_POST;
    $id_mess[update_time]=date("Y-m-d H:i:s",time());
//  $dbclass->updateMess($update_mess,$id);
    $birthday =$id_mess[birthday];
    $year = substr($birthday,0,4);
    $month = substr($birthday,5,2);
    $day= substr($birthday,8,2);
//	$smarty->assign('update_time',);
	$smarty->assign('user',$id_mess[first_name1]);
    $smarty->assign('first_name1',$id_mess[first_name1]);
    $smarty->assign('last_name1',$id_mess[last_name1]);
    $smarty->assign('first_name2',$id_mess[first_name2]);
    $smarty->assign('last_name2',$id_mess[last_name2]);
    $smarty->assign('sex',$id_mess[sex]);
    $smarty->assign('birthday',$id_mess[birthday]);
    $smarty->assign('year',$year);
    $smarty->assign('month',$month);
    $smarty->assign('day',$day);
    $smarty->assign('email',$id_mess[email]);
    $smarty->assign('phone',$id_mess[phone]);
    $smarty->assign('school',$id_mess[school]);
    $smarty->assign('major',$id_mess[major]);
    $smarty->assign('description',$id_mess[description]);
    $smarty->assign('id',$id);

    $smarty->display("update_check.tpl");	
}

