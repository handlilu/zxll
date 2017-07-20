zxll
------------

grep检索脚本：
环境目录：xxxxx

1.打开目录：
  在当前目录下新建文件：
  dirlist.txt    // 存放所有需要检索的目录（比如：/export/www/proto/GOO/docs/）
  keyword.txt    // 存放需要检索的关键字（比如：deqwas）
  新建目录：result  // 存放检索完了之后生成的文件
2.进入conf目录：
  grep_exclude_dir_list.conf  // 需要排除的目录（比如：BACK）
  grep_white_ext_list.conf    // 需要检索的文件的后缀名(比如：php)
3.执行命令：
  nohup ./grep_f.sh dirlist.txt keyword.txt aa > find.log 2> 1 &

  &： 命令在后台执行,所以这时可以继续去做其他操作,等待命令执行完毕再来查看即可
  jobs: 可以查看执行的进程,但是只可以查看自己的进程
  ps -auxxwf： 查看执行的进程,但是可以查看所有的进程
4.命令执行完了可以直接进入result目录下,打开生成的文件即可

