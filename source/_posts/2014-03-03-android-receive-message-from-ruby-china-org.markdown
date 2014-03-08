---
layout: post
title: "Android客户端接收来自Faye的消息推送"
date: 2014-03-03 21:53:50 +0800
comments: true
categories: 
---
### 基本原理
先看了railscasts的[260 Messaging with Faye](http://railscasts.com/episodes/260-messaging-with-faye)部分，了解Faye的基本原理。

按照其教程发现有一个关于thin的bug，谷歌之解决，后来发现rubychina应该也是遇到过类似的问题。

解决的方法是加上`Faye::WebSocket.load_adapter('thin')`
``` ruby
require 'faye'
Faye::WebSocket.load_adapter('thin')
faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45)
run faye_server
```
当然，理论上来说，Faye是支持各种web服务器的，这个地方因为和Rails比较紧密所以选用Faye，如果考虑到更高的并发的话，选择Node.js来跑也是不错的，faye也是有Node的版本的。

### 实现
在实现了web端之后，就考虑到移植到安卓客户端

谷歌android faye，发现有人已经做了一个安卓端的fayeclient，根据websocket的协议来，实现一个并不困难。

对比faye客户端的js代码
``` javascript
	$(function() {
	  var faye = new Faye.Client('http://localhost:9292/faye');
      faye.subscribe('/messages/new', function (data) {
      alert(data);
      });
	});
```
和[Android-Faye-Client](https://github.com/saulpower/Android-Faye-Client)的java代码
``` java
URI uri = URI.create(String.format("ws://%s:443/events", baseUrl));
String channel = String.format("/%s/**", User.getCurrentUser().getUserId());

mClient = new FayeClient(uri, channel);
mClient.setFayeListener(this);
mClient.connectToServer(null);
```    
我们就知道大概了如何实现了，需要指出的是，js客户端直接用的http协议，而我们在java这边需要用的是ws协议(也即WebSocket，wss类似https，是ws的安全加强版)

如果你使用的是Android Studio，在你的`build.gradle`里面添加如下依赖即可:

	dependencies {
    	compile 'com.saulpower.fayeclient:library:1.0'
	}

因为这个应用是基于Ruby-China做得的，端口号可以查看[RubyChina首页](view-source:http://ruby-china.org/)的源代码获取。而channel号也在首页源代码中可见，用的一个temp_access_token，这个token是专门用来做faye的channel号的，通过第一个版本的api可以获取到这个token。
``` html
	<script type="text/javascript" data-turbolinks-eval=false>
	  ROOT_URL = "http://ruby-china.org/";
	  ASSET_URL = "http://l.ruby-china.org/";
	  FAYE_SERVER_URL = "http://ruby-china.org:8080/faye";
	    CURRENT_USER_ACCESS_TOKEN = "72a47853462c91db8f7ed8d3d8899d00";
	  if (FAYE_SERVER_URL) {
	    App.initNotificationSubscribe();
	  }
	</script>
```	
在[RubyChina4Android](https://github.com/gonjay/rubychina4android)中，用户登录的时候会获取一遍temp_access_token，并注册Serveice。接下来，如果有人在论坛里面@你，应该就能在手机上收到消息推送了。

## Source Code
以上所有的代码都可以在[RubyChina4Android](https://github.com/gonjay/rubychina4android)里面找到