---
layout: post
title: "Mac下用Terminal玩mysql"
date: 2014-02-23 19:28:08 +0800
comments: true
categories: 
---
### 安装

	brew install mysql
	
### 启动
	
	mysql.server start

然后再输入
	
	mysql

不然会出现
	
	ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
	
的错误。屡试不爽！

### 基本命令

在输入`mysql`之后，就连到MySQL了。

* 使用SHOW语句找出在服务器上当前存在什么数据库：

	mysql> `SHOW DATABASES;`
	
* 创建一个数据库MYSQLDATA

	mysql> `CREATE DATABASE MYSQLDATA;`
	
* 选择你所创建的数据库
	
	mysql> `USE MYSQLDATA;` (按回车键出现Database changed 时说明操作成功！)
	
* 查看现在的数据库中存在什么表
	
	mysql> `SHOW TABLES;`
	
* 创建一个数据库表
	
	mysql> `CREATE TABLE MYTABLE (name VARCHAR(20), sex CHAR(1));`
	
* 显示表的结构：
	
	mysql> `DESCRIBE MYTABLE;`
	
* 往表中加入记录
	
	mysql> `insert into MYTABLE values (”hyq”,”M”);`
	
* 用文本方式将数据装入数据库表中（例如D:/mysql.txt）
	
	mysql> `LOAD DATA LOCAL INFILE “D:/mysql.txt” INTO TABLE MYTABLE;`
	
* 导入.sql文件命令（例如D:/mysql.sql）
	
	mysql>`use database;`
	
	mysql>`source d:/mysql.sql;`
	
* 删除表
	
	mysql>`drop TABLE MYTABLE;`
	
* 清空表

	mysql>`delete from MYTABLE;`
	
* 更新表中数据

	mysql>`update MYTABLE set sex=”f” where name=’hyq’;`

### 如何支持中文
我不明白MySQL为何不默认utf-8，也许是等着被一众NoSql干掉吧

	CREATE DATABASE `test`
	CHARACTER SET 'utf8'
	COLLATE 'utf8_general_ci';
