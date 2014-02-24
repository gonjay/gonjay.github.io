---
layout: post
title: "Android Sutio 使用指南--像Gemfile一样使用gradle"
date: 2014-02-19 00:04:26 +0800
comments: true
categories: 
---


# 像Gemfile一样使用gradle

随着项目越来越大，为了更多特性，我们不得不使用越来越多的开源库。按照Eclipse等传统的方式，我们一般会这样做：
   
1. 下载jar包，并添加到项目的build path里面
2. 下载library，将整个文件夹导入到workspace里面，然后在自己的项目里面添加依赖

这种方式很有效，但你可以搜索一下Ruby的gem，node.js的npm，iOS的cocoapods，还有过去java项目中的maven依赖。

对比你就发现了，原来这些包管理工具让使用者都不用自己从网上下载，Android依赖管理不是那么优秀，于是Google在最新的Android开发工具便使用gradle来管理项目。那么想比起传统的maven，gradle有哪些优势呢？

### 选择Gradle的五个优势

1. 已经被证明能够处理大型的项目规模--LinkedIn, Netflix, Orbitz这些大公司都使用它来管理项目
2. gradle提供了对于多语言、多平台最自然的处理方式--Scala, Groovy, C/C++这些项目都能用gradle来管理
3. gradle专注build效率
4. gradle的发布周期很短
5. 社区支持很棒

[链接](http://www.gradleware.com/resources/tech/java/maven)

### 如何引用Maven？

之前我们是这样引用

	<dependency>
    	<groupId>com.nhaarman.listviewanimations</groupId>
	    <artifactId>library</artifactId>
    	<version>2.5.2</version>
	</dependency>
	
现在我们是这样

	repositories {
    	mavenCentral()
	}

	dependencies{
    	compile 'com.nhaarman.listviewanimations:library:2.5.2'
	}
	
你看最新的依赖管理方式让你再也不用去github上面下载jar包了或者导入整个library