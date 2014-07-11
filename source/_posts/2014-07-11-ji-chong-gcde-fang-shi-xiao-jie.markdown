---
layout: post
title: "几种GC的方式小结"
date: 2014-07-11 11:26:54 +0800
comments: true
categories: GC
---

### 标记清除方式

从根开始将可能被引用的对象用递归的方式进行标记，没有被标记的就当垃圾回收掉。

![](http://ww2.sinaimg.cn/mw600/a22a83f5gw1ehhxoubcppj20an0jk75f.jpg)

### 复制收集方式

因为标记清楚方式中有一个弊病就是在一次清除中，如果只有一小部分存活，消耗的时间会很多，所以复制收集方式应运而生。

![](http://ww2.sinaimg.cn/mw600/a22a83f5gw1ehhxorye36j20aj0jodgt.jpg)

### 引用计数方式

熟悉Objective-C开发iOS或者一些C++的开发者可能非常熟悉。

基本原理是，在每个对象中保存该对象的引用计数，当引用增加或者减少的时候对计数更新。

![](http://ww2.sinaimg.cn/mw600/a22a83f5gw1ehhxopz9awj20bz0czjs2.jpg)