---
layout: post
title: "Start cocos2d with Lua"
date: 2014-03-25 15:02:55 +0800
comments: true
categories: ['Cocos2d-x']
---
## quick-cocos2d-x



## tip

cocos游戏开发的流程是先采用Lua或者JS，把整个游戏实现出来，然后利用相应的工具去打包成不同平台下的项目，比如打包Android平台或者iOS平台的项目，然后利用相应平台的工具编译成apk或者ipa文件。

这也就意味着，对于一个利用cocos开发的游戏要接入我们的SDK，我们应该不会去开发针对Lua或者JS的单独SDK，而是给出一个指导，即当游戏开发商生成了一个Android项目或者iOS项目之后，应该怎样接入我们的平台。这就涉及到Lua调用Java，Java调用Lua，又或者Objective-C调用Lua或者Lua调用Objective-C了，剩下的事情，就是纯粹SDK的一些操作。

接下来尝试，将一个html5的cocos打包生成一个Android项目，尝试用js去调用java以及java调用js