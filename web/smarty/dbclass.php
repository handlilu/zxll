<?php
	Class DateBase {	
	
	public $_dbconn = "";	
	/** db test
	$pg = pg_connect($_dbconn);
	if(!$pg){
		echo "Error : Unable to open database:";
	}else{
		//echo "success";
		//$sql = "insert into public.resume_mess(id,first_name1)values('822','ddd;xxxx')";
		//$arr_mess = array("id"=>"3233","first_name1"=>"xxxddff");
		$result = pg_query($pg,$sql); 
		//$result = @pg_insert($pg,"resume",$arr_mess);
              if($result){
                  return $result;
              }else{
				echo	pg_last_error($result);
                //  $reslut = "insert file";
                //  return $result;
              }
		pg_close($db);
	}
	*/
	public	$_resume_Mess = array();
	function insertMess($_post_mess){
	//	var_dump($_post_mess);:
	//	echo $_post_mess[emaile];
	//	exit;
		$sql = "insert into public.resume_mess(user_name,
			first_name1,
			last_name1,
			first_name2,
			last_name2,
			update_time,
			emaile,
			phone,
			school,
			major,
			description,
			sex,
			birthday)
			values(
			'".$_post_mess[user_name]."',
			'".$_post_mess[first_name1]."',
			'".$_post_mess[last_name1]."',
			'".$_post_mess[first_name2]."',
			'".$_post_mess[last_name2]."',
			'now()',
			'".$_post_mess[email]."',
			'".$_post_mess[phone]."',
			'".$_post_mess[school]."',
			'".$_post_mess[major]."',
			'".$_post_mess[description]."',
			$_post_mess[sex],
			'".$_post_mess[birthday]."'); ";
		
//		exit;
		$pg = pg_connect($this->_dbconn);
		if(!$pg){
			echo "Con't connection postgresql";
		}else{
			$result = pg_query($sql);
			//$result = pg_insert($pg,"resume_mess",$_post_mess);
			if($result){
				$result="insert success";
				echo pg_last_error();
				return $result;
			}else{
				$reslut = "insert fiale";
				echo pg_last_error();
				return $result;
			}
			pg_close($pg);
		}
	}
	
	
	function showMess($name,$_select_mess,$pagstar,$pagend,$_orderz,$_orderf){
		$pos = strpos($name,' ');
		$lengs = strlen($name);
		
		$last_name1 = trim(substr($name,$pos));
		$first_name1 =trim(substr($name,0,$pos));

		$pg = pg_connect($this->_dbconn);
		
		$sqla ="select
					picture_path,
					user_name,
					sex,
					birthday,
					emaile,
					phone,
					school,
					description,
					id
		 from public.resume_mess where del_falg=0 ";
		
		if($_select_mess[username]){
			$sqla .=" and user_name like '%".$_select_mess[username]."%'" ;
		}
		if(strlen($_select_mess[sex])>0){
			$sqla .="and sex='".$_select_mess[sex]."'";
		}
		if($_select_mess[school]){
			$sqla .="and school like'%".$_select_mess[school]."%'";
		}
		if($_select_mess[phone]){
			$sqla .="and phone like '%".$_select_mess[phone]."%'";
		}

		if($_orderz){
			$sqla .= " order by ".$_orderz;
		}
		if($_orderf){
			$sqla .= " order by ".$_orderf." desc ";
		}
		if($_orderz or $_orderf){
		}else{
			$sqla .= " order by update_time desc ";
		}
		$sql = $sqla." limit ".$pagend." offset ".$pagstar.";";
		

		$ret = pg_query($sql)  ;
		if($ret){
			// return 返回 一个数zu pg_fetch_all
		//	echo "xxx";
			return 	pg_fetch_all($ret);
			
		 }else{
			echo pg_last_error($ret);
		}
		pg_close($pg);
	}

	function counttotal($name,$_select_mess){
		$sqlcount = "select count(*) as tcount from public.resume_mess where del_falg=0 ";

        if($_select_mess[username]){
            $sqlcount .=" and user_name like '%".$_select_mess[username]."%'" ;
        }
        if(strlen($_select_mess[sex])>0){
            $sqlcount .="and sex='".$_select_mess[sex]."'";
        }
        if($_select_mess[school]){
            $sqlcount .="and school like'%".$_select_mess[school]."%'";
        }
        if($_select_mess[phone]){
            $sqlcount .="and phone like'%".$_select_mess[phone]."%'";
        }
        $sqlcount = $sqlcount.";";
        $pg = pg_connect($this->_dbconn);
		$ret = pg_query($sqlcount)  ;
        if($ret){
            return  pg_fetch_array($ret);

         }else{
            echo pg_last_error($ret);
        }
        pg_close($pg);
	}
	
	function updateMess($_update_mess,$id){
		$sqlup = " update resume_mess set ";
			if($_update_mess[update_time]){
                 $sqlup .= "update_time = now() ,";
             }
			if($_update_mess['user_name']){
				$sqlup .= "user_name = '".$_update_mess[user_name]."',";
			}
			if($_update_mess[first_name1]){
				$sqlup .= " first_name1 = '".$_update_mess[first_name1]."' ,";
			}
			 if($_update_mess[last_name1]){
                $sqlup .= " last_name1 = '".$_update_mess[last_name1]."' ,";
            }
			if($_update_mess[last_name2]){
                $sqlup .= " last_name2 = '".$_update_mess[last_name2]."' ,";
            }
			if($_update_mess[first_name2]){
                $sqlup .= " first_name2 = '".$_update_mess[first_name2]."' ,";
            }	
			if($_update_mess[sex]){
                $sqlup .= " sex = '".$_update_mess[sex]."' ,";
            }
			if($_update_mess[birthday]){
                $sqlup .= " birthday = '".$_update_mess[birthday]."' ,";
            }
			if($_update_mess[emaile]){
                $sqlup .= " emaile = '".$_update_mess[emaile]."' ,";
            }
			if($_update_mess[phone]){
                $sqlup .= " phone = '".$_update_mess[phone]."' ,";
            }
			if($_update_mess[school]){
                $sqlup .= " school = '".$_update_mess[school]."' ,";
            }
			if($_update_mess[major]){
                $sqlup .= " major = '".$_update_mess[major]."' ,";
            }
			if($_update_mess[description]){
                $sqlup .= " description = '".$_update_mess[description]."'";
            }
		
			$sql = $sqlup." where id = '".$id."';";
		$pg = pg_connect($this->_dbconn);
		$ret=pg_query($sql);
		if(!$ret){
			echo pg_last_error($pg);
		}
		pg_close($pg);
	}

	function selectOnceByid($id){
		$sql = "select * from resume_mess where del_falg = 0 and id = '".$id."'";	
		$pg = pg_connect($this->_dbconn);
		$ret = pg_query($sql);
		if($ret){
			return pg_fetch_array($ret);
		}else{
			echo pg_last_error($pg);
		}
		pg_close($pg);
	}
	
	function delectOnce($id){
		$sql = "update resume_mess set del_falg = 1 where id = '".$id."';";
		$pg = pg_connect($this->_dbconn);
		$success="success";
		$ret = pg_query($sql);
		if($ret){
			return $success;
		}else{
			pg_last_error($pg);
		}
		pg_close($pg);
	}
	
	function insertPic($pic_path,$id){
		$sql = "update resume_mess set picture_path ='".$pic_path."', update_time = now()  where id = '".$id."';";
		$pg = pg_connect($this->_dbconn);
		$ret = pg_query($sql);
		if($ret){
			return $success;
		}else{
			pg_last_error($pg);
		}
		pg_close($pg);
	}

}
