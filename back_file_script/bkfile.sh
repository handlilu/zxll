#!/bin/sh
path=`pwd`
date=`date +"%Y%m%d%H%M"`

if [ $# = 2 ]
then
    filename=${path}"/"$1
    yourname=$2
else
    echo "input at least 2 parameters!!!The first is file name and the second is your name!!! Please try again!!!"
    exit
fi

if [ ! -f $filename ]
then
    ehco "$1 isn't a file or it doesn't exits!!!Please check your first parameters and try again!!!"
    exit
fi

bkname=$1".bk"${date}"."${yourname}
if [[ $filename =~ 'bksvn' ]]
then
  echo 'bksvn'
cp ${filename} ${path}"/old/"${bkname}
else

  if [[ $filename =~ '/app/' ]]
  then
     path01=${path/\/app\//\/app_bksvn\/}
  elif [[ $filename =~ '/javascripts/' ]]
  then
     path01=${path/javascripts/javascripts_bksvn}
  elif [[ $filename =~ '/js/' ]]
  then
     path01=${path/\/js\//\/js_bksvn\/}
  elif [[ $filename =~ '/lib/' ]]
  then
     path01=${path/\/lib\//\/lib_bksvn\/}
  elif [[ $filename =~ 'stylesheets' ]]
  then
     path01=${path/stylesheets/stylesheets_bksvn}
  elif [[ $filename =~ '/css/' ]]
  then
     path01=${path/\/css\//\/css_bksvn\/}
  else
     path01=${path}
  fi

cp ${filename} ${path01}"/old/"${bkname}
fi

if [ $? != 0 ]
then
    echo "bk failed!!! Please try again!!!"
fi
