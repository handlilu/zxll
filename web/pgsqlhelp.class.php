<?php
class pgsqltool{
	private $conn_str ="";
        private $conn;
	function  sqltool(){
		$this->conn=pg_connect($this->conn_str);
		
                if(!$this->conn){
			die("could not connect".pg_last_error());
		}
	}
	function execute_dql($sql){
               $this->conn=pg_connect($this->conn_str);
	       $res=pg_query($sql) or die("<script> history.go(-1);</script>"  );	
	       return $res;		
	}
	function execute_dml($sql){
               $this->conn=pg_connect($this->conn_str);
               $res=pg_query($sql) or die( pg_last_error()."<script>alert('error');history.go(-1);</script>"  );	
			if(pg_affected_rows($res)>0){
				return 1;
			}else {
				return 2;
			}
	}
	function execute_dql2($sql){
		$this->conn=pg_connect($this->conn_str);
                $arr=array();
		$res=pg_query($sql) or die("<script>alert('error');history.go(-1);</script>" );
		$i=0;
		while($rows=pg_fetch_assoc($res)){
			$arr[$i++]=$rows;
		}
		pg_free_result($res);
		return $arr;
		
      	}
	//close link
	function close_connect(){
		if (!empty($this->conn)){
			pg_close($this->conn);
		}
	}

 }
       


