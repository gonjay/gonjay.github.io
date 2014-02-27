---
layout: post
title: "Rails 自定义Rake task 来备份和恢复数据库"
date: 2014-02-25 13:00:35 +0800
comments: true
categories: 
---
打开Rakefile，添加

```
namespace :db do
 task :backup do
   system "mysqldump --opt --user=root raiderboard > backup.sql"
 end


 task :restore do
   system "mysql --user=root raiderboard < backup.sql"
 end

end

```

然后在命令行输入`rake db:backup`就能获得一份sql备份文件，git/svn commit这份sql文件，到服务端git pull下来，然后输入`rake db:restore`便能恢复你本地的数据库到服务端的数据库了。

### 查看数据库大小

1 进去指定schema 数据库（存放了其他的数据库的信息） 
	
	mysql> use information_schema;
	Database changed
	
2 查询所有数据的大小 
	
	mysql> select concat(round(sum(DATA_LENGTH/1024/1024), 2), 'MB')
    -> as data from TABLES;  
	+-----------+
	| data      |
	+-----------+
	| 6674.48MB |
	+-----------+
	1 row in set (16.81 sec)
	
3 查看指定数据库实例的大小，比如说数据库 forexpert 
	
	mysql> select concat(round(sum(DATA_LENGTH/1024/1024), 2), 'MB')
    -> as data from TABLES where table_schema='forexpert';
	+-----------+
	| data      |
	+-----------+
	| 6542.30MB |
	+-----------+
	1 row in set (7.47 sec)
	
4 查看指定数据库的表的大小，比如说数据库 forexpert 中的 member 表 
	
	mysql> select concat(round(sum(DATA_LENGTH/1024/1024),2),'MB') as data
    -> from TABLES where table_schema='forexpert'
    -> and table_name='member';
	+--------+
	| data   |
	+--------+
	| 2.52MB |
	+--------+
	1 row in set (1.88 sec)
