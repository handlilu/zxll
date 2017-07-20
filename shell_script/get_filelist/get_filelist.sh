#!/bin/bash

if [ ! -f "$1" ]; then
  echo -e $(date)"File doesn't exist!";
else
  file=$1;
  file_count=0;

  while read line
  do

    if [ -z "$line" ]; then
      continue;
    fi

    if [ ! -f "$line" ]; then
      echo -e "$line" doesn't exist!";
      continue;
    fi

    #if [${line##*.} != '']; then
    #fi
    let file_count=file_count+1;
    usr=`stat -c %U $line`;
    w_str=${w_str}${line}"\t"${usr}"\n";
    #echo "${line##*.}";
  done < $file

  echo -e "Total files: $file_count";
  echo "Press 'y' to continue, press other key to exit!";
  read isContinue;
  if [ "$isContinue" != "y" ]; then
    exit;
  fi

  echo -n -e "$w_str" > $file".tmp";

  current_usr=`whoami`;
  des_dir=$2;
  echo -e "Current user is $current_usr";
  echo -e "Destination directory is $des_dir";

  echo "Press 'y' to continue, press other key to exit!";
  read isContinue;
  if [ "$isContinue" != "y" ]; then
    exit;
  fi

  if [ -z "$des_dir" ]; then
    des_dir=$(date +%Y%m%d)"_"$current_usr;
  else
    des_dir=$des_dir"_"$current_usr
  fi

  while read line
  do
    arr=($line);
    if [ "${arr[1]}" = "$current_usr" ]; then

      if [ ! -d "$des_dir" ]; then
        msg=`mkdir $des_dir`;
        if [ ! -z "$msg" ]; then
          echo $msg;
          exit;
        fi
      fi
      echo "Start to copy files:";
      echo "cp -p --parents "${arr[0]}" "$des_dir"/";
      msg=`cp -p --parents ${arr[0]} $des_dir/`;
      if [ ! -z $msg ]; then
        echo $msg;
      fi
    fi

    #dir=`dirname ${arr[0]}`;
    #basename=`basename ${arr[0]}`;
    #date=$(date +%y%m%d);
    #echo $dir"/"$date"/"$basename;
  done < $file".tmp"

  if [ -d "$des_dir" ]; then
    copied_count=0;
    copied_count=`find $des_dir -type f | wc -l`;
    echo -e "Copied files: $copied_count";
    msg=`zip -r $des_dir.zip $des_dir`;
    echo $msg;

    if [ ! -f "$des_dir.zip" ]; then
      echo -e "Zip file doesn't exist!";
      exit;
    fi
    msg=`cp $des_dir.zip xxxxxx`;
    if [ ! -z "$msg"]; then
      echo -e "$msg";
      exit;
    else
      hostname=`hostname`;
      if [ ${hostname:0:2} = "da" ]; then
        http_host="dev";
      elif [ ${hostname:0:2} = "sa" ]; then
        http_host="stg";
      fi
      echo "http://"$http_host".xxxxxxxx"$des_dir".zip";
    fi
  fi
fi