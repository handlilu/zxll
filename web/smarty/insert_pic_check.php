<?php
	session_start();
    require_once("plugins/default_head.php");
    $subset =$_GET[subsend];
    $path ="uploadpic/";
    $pictype = array("image/gif","image/png","image/pjpeg","image/jpeg");
    $id = isset($_GET['id']) ? intval($_GET['id']) : 0; 
   	
	$smarty->assign('pic_id',$id);
		
	$smarty->assign('pic_path',$_FILES['file']['tmp_name']."/".$_FILES['file']['name']);
   
    if($_FILES && $_POST['id']){
		$id = $_POST['id'];
        if($_FILES['file']['error']>0){
			
			echo "<script>alert('IMG ERROR');  window.location.href='insert_pic.php?id=".$id."'</script>";
            exit;
        }
        if(!in_array($_FILES['file']['type'],$pictype)){
            echo "格式ERROR";
			echo "<script>alert('IMG ERROR');  window.location.href='insert_pic.php?id=".$id."'</script>";
            exit;
        }
        if($_FILES['file']['size']>1024*1024*4){
            echo "Error :size";
			echo "<script>alert('IMG ERROR');  window.location.href='insert_pic.php?id=".$id."'</script>";
            exit;
        }

		
        $_file_name = $time.$_FILES['file']['name'];
        $_file_path = $_FILES['file']['tmp_name'];
    	$time = strval(time());
	    $pic_path = $path.$time.$_FILES['file']['name'];
		// bug ： refresh in confire page  picture move repeated
		move_uploaded_file($_FILES['file']['tmp_name'],$pic_path);
		echo "path:".$pic_path."===id:".$_SESSION['pic_id'];
		$smarty->assign('pic_path',$pic_path);
	}

	$check_pic = $_POST['check_pic'];
	
	var_dump($_FILES['file']['tmp_name']);
	if($check_pic=="ok"){
		$pic_path = $_POST['pic_path'];
		echo "path:".$pic_path."===id:".$_SESSION['pic_id'];
		if($_SESSION['pic_id']>0){
		//	move_uploaded_file($_FILES['file']['tmp_name'],$pic_path);
			$dbclass->insertPic($pic_path,$_SESSION['pic_id']);
		}
		echo "session=====".$_SESSION['pic_id']; 
		$smarty->assign('refresh',$id);
		$smarty->display("update_picok.tpl");
		unset($_SESSION['pic_id']);
	}else{		
		$smarty->assign('refresh',$id);
		$smarty->display("update_pic_check.tpl");
	}
