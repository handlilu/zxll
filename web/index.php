<?php 
 session_start();
 header("Content-type:text/html;charset=utf-8");
 include_once('smarty/libs/Smarty.class.php');
 include_once('config.php');
 include_once('listservice.php');
 // var_dump($_GET);
 // var_dump($_SESSION);
 $listservice = new liluservice();
 if($_GET['clearsess']==1){
   session_destroy();
 }
 if(!empty($_GET['name']) && $_GET['order']='update'){
   $order =$_GET['order'];
   $name =$_GET['name']; 
   $res= $listservice->get_yingzhao_new_jianlibyname($name); 
// var_dump($res);
   $firstname = $res[0]['name'];  
   $lastname = $res[0]['name_n'];
   $firstname1 = $res[0]['fname'];
   $lastname1 = $res[0]['fname_n'];
   $sex = $res[0]['sex'];
   $sel1 = substr($res[0]['birth'],0,4);
   $sel2 = substr($res[0]['birth'],5,2);
   $sel3 = substr($res[0]['birth'],-2);
   $email = $res[0]['email'];
   $school = $res[0]['school'];
   $tel = $res[0]['tel'];
   $object = $res[0]['object'];
   $skill = urldecode($res[0]['skill']);
   }else{
 // var_dump($_SESSION);
   $order ="insert";
   $firstname = $_SESSION['firstname'];
   $lastname = $_SESSION['lastname'];
   $firstname1 = $_SESSION['firstname1'];
   $lastname1 = $_SESSION['lastname1'];
   $sex = $_SESSION['Sex'];
   $sel1 = $_SESSION['sel1'];
   $sel2 = $_SESSION['sel2'];
   $sel3 = $_SESSION['sel3'];
   $email = $_SESSION['Email'];
   $tel = $_SESSION['tel'];
   $school = $_SESSION['degree'];
   $object= $_SESSION['object'];
   $skill = $_SESSION['skill'];

}
 print_r($_GET); 
 $smarty->assign('firstname',$firstname);  
 $smarty->assign('lastname',$lastname);
 $smarty->assign('firstname1',$firstname1);
 $smarty->assign('lastname1',$lastname1);
 $smarty->assign('sex',$sex);
 $smarty->assign('year',$sel1);
 $smarty->assign('month',$sel2);
 $smarty->assign('day',$sel3);
 $smarty->assign('email',$email);
 $smarty->assign('tel',$tel);
 $smarty->assign('school',$school);
 $smarty->assign('object',$object);
 $smarty->assign('skill',$skill);
 $smarty->assign('name',$name);
 $smarty->assign('order',$order);
 $smarty->assign('cust_ids',array(100,101,102,103));
 $smarty->assign('cust_names',array('lilu','eryi','lilei'));
 $smarty->assign('customer_id',100);
 $smarty->assign('data',array("1990","1991","1992","1993","1994","1995","1996","1997"));
 $smarty->assign('mon',array("01","02","03","04","05","06","07","08","09",10,11,12));
 $smarty->assign('daydata',array("01","02","03","04","05","06","07","08","09",10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31));
 $a=$_SESSION['abc'];
 $smarty->assign('a',$a);
 $smarty->display('index.tpl');
 

?>

