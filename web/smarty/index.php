<?php
	 session_start();
	require_once("plugins/default_head.php");
	$id = $_GET['id'] ? $_GET['id'] : "";
	if($id){
		$ret = $dbclass->selectOnceByid($id);
		if($ret){
		$smarty->assign('first_name1',$ret[first_name1]);
    	$smarty->assign('last_name1',$ret[last_name1]);
    	$smarty->assign('first_name2',$ret[first_name2]);
    	$smarty->assign('last_name2',$ret[first_name2]);
		$ret[sex] = intval($ret[sex])=='1' ? "女" : "男";
    	$smarty->assign('sex',$ret[sex]);
    	$smarty->assign('birthday',$ret[birthday]);
    	$smarty->assign('email',$ret[emaile]);
		$smarty->assign('checkemail',$ret[emaile]);
    	$smarty->assign('phone',$ret[phone]);
    	$smarty->assign('school',$ret[school]);
    	$smarty->assign('major',$ret[major]);
		$smarty->assign('description',$ret[description]);
		$ret[year] = substr($ret[birthday],0,4);
		$ret[month] = substr($ret[birthday],5,2);
		$ret[day] = substr($ret[birthday],8,2);
    	$smarty->assign('year',$ret[year]);
    	$smarty->assign('month',$ret[month]);
    	$smarty->assign('day',$ret[day]);
		$smarty->assign('id',$id);
		}else{
			echo "<script> alert('ERROR!') ;window.location.href='show_resume.php' </script>";
		}
	}else{

	$smarty->assign('first_name1',$_SESSION[resume][first_name1]);
    $smarty->assign('last_name1',$_SESSION[resume][last_name1]);
    $smarty->assign('first_name2',$_SESSION[resume][first_name2]);
    $smarty->assign('last_name2',$_SESSION[resume][first_name2]);
    $smarty->assign('sex',$_SESSION[resume][sex]);
    $smarty->assign('birthday',$_SESSION[resume][birthday]);
    $smarty->assign('email',$_SESSION[resume][email]);
    $smarty->assign('phone',$_SESSION[resume][phone]);
    $smarty->assign('school',$_SESSION[resume][school]);
    $smarty->assign('major',$_SESSION[resume][major]);
    $smarty->assign('description',$_SESSION[resume][description]);
	$smarty->assign('year',$_SESSION[resume][year]);
	$smarty->assign('month',$_SESSION[resume][month]);
	$smarty->assign('day',$_SESSION[resume][day]);
	$smarty->assign('checkemail',$_SESSION[resume][checkemail]);
	}
	
	$smarty->display('login.tpl');
	

