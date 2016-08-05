<?php 
 session_start();
header("Content-type:text/html;charset=utf-8");
 include_once('smarty/libs/Smarty.class.php');
 include_once('config.php');
 include_once('listservice.php');
 $listservice =new liluservice();
  if(isset($_GET['name'])){
    $name = $_SESSION['name'] = $_GET['name'];
      
   $res = $listservice->getpg($name);
   $a=$res[0]['photo'];
   if($a=='') $message='あなたがまだ画像';
   }
 if(empty($_SESSION['start_time'])){
   $start_time=time();
   $_SESSION['start_time'] =$start_time;
  }  
 $smarty->assign('a',$a);
 $smarty->assign('message',$message);
 $smarty->assign('name',$name);
 $smarty->display('upload.tpl');
