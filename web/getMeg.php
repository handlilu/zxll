<?php
  session_start();
  header( 'Cache-control:private,must-revalidate' );
  require_once('smarty/libs/Smarty.class.php');
  require_once('config.php');
  require_once('Free.class.php');
   $free = new free();
   
  if(isset($_POST) && $_POST != ''){
    $data = $_POST;
    $_SESSION = $_POST;
  } else {
    $data =$_GET;
    $_SESSION = $_GET;
  }
  /*
  echo "<pre>";
  print_r($data);
  echo "<pre>";
  */
  $free-> allSetter( $data );
    
$smarty->assign(free,$free);  
$smarty->display('getMeg.html');
