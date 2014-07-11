---
layout: post
title: "Android Studio 开发中的Tips"
date: 2014-07-11 11:42:59 +0800
comments: true
categories: ['Android', 'Studio', 'Gradle']
---

入门Android时使用的一直是Eclipse，后来就转用Android Studio了，最近因为需要返回使用Eclipse，突然发现在编译打包一个apk的时候，Eclipse居然比Android Studio要快上不少！！

Android Studio build 速度太慢，这个太不科学了，google一下发现了以下解决方案：


#### 使用最新的Android gradle plugin

	build.gradle

    	buildscript {
    	       dependencies {
    	                  classpath 'com.android.tools.build:gradle:0.9.+'       
    	              }    
    	          }
  
#### 使用最新的Gradle

gradle-wrapper.properties
distributionUrl=http\://services.gradle.org/distributions/gradle-1.8-all.zip

#### 使用gradle deamon 后台任务，使用gradle parallel并行任务

	gradle.properties

    org.gradle.daemon=true    
    org.gradle.parallel=true

开启deamon后，CPU起来了，这样就对了嘛，用机器时间减少人等待的时间，提高生产效率