<?php
	session_start();
	require_once("libs/Smarty.class.php");
	require_once("dbclass.php");
	date_default_timezone_set("PRC");	
	$smarty = new Smarty();
	
	$dbclass = new DateBase();
	$_select_mess = $_GET;
	$username = empty($_GET['username']) ? '' : trim($_GET['username']);
	$sex = isset($_GET['sex']) ? $_GET['sex'] : "" ;
	$school = empty($_GET['school']) ? '' : trim($_GET['school']);
	$phone = empty($_GET['phone'])	? '' : trim($_GET['phone']);
	$smarty->assign('username',$username);
    $smarty->assign('sex',$sex);
    $smarty->assign('school',$school);
    $smarty->assign('phone',$phone);
	$smarty->display("selete_resume.tpl");
	$countsql = $dbclass->counttotal($username,$_select_mess);
	$countsql = intval($countsql[tcount]);
	$pagenum =5;
	$total_age = ceil($countsql/5);
	
	$current_age = empty($_GET['page']) ? 1 : intval($_GET['page']);	
	$smarty->assign('current_age',$current_age);
	$smarty->assign('total_age',$total_age);

	$pagstar = intval($current_age*5);
	$pagend  = $pagstar+5; 	
	$orderz =$_GET[orderz];
	$orderf =$_GET[orderf];
	$pagstar = ($current_age -1 ) * 5  ;
	$_show_mess = $dbclass->showMess($username,$_select_mess,$pagstar,$pagenum,$orderz,$orderf);
	$smarty->assign('show_mess',$_show_mess);
	$smarty->display("show_resume.tpl");	

	
