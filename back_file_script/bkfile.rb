#!/usr/bin/ruby -w
# 把当前目录的文件备份到SVNbk下对应的old文件夹中
 params = ARGV
 def bkfile (params)
     if params.size != 2
        puts "just input 2 params"
     else
        path     = `pwd [-L]`
        svn_file = ['js','lib','app','javascripts','stylesheets','css']
        path_arr = path.split('/')
        path_arr.each_with_index do |p,i|
           if svn_file.include?(p)
              path_arr[i] = p+'_bksvn'
           end
        end
        path_new = path_arr.join('/')
        time     = Time.new
        old_dir  = "#{path_new.gsub(/\r|\r\n|\n/,'')}/old/"
        bkname   = old_dir+ARGV[0]+'.bk'+time.strftime("%Y%m%d%H%M")+"."+ARGV[1]
        filename = path.gsub(/\r|\r\n|\n/,'')+'/'+ARGV[0]
        if File.exist?(filename)
           if !File.directory?old_dir
              exec " mkdir -p #{old_dir} "
           end
           exec "cp #{filename} #{bkname}"
        else
           puts "Please check you first params which must be a filename and exist!!"
        end
     end
 end
 bkfile params
