---
layout: post
title: "Rails中app/assets的来历"
date: 2014-02-22 00:46:31 +0800
comments: true
categories: ['Rails', 'Assets pipline', '前端']
---
## 引用更多

在过去的rails和传统应用中，所有的css和js文件全部都是静态的，写好了放在public，需要的时候就引用。

但是，随着项目不断发展，这些文件会变得越来越多，在一个网站的首页你经常看见这样的壮观场景：

```

    <link rel="stylesheet" type="text/css" href="libs/jquery-ui-1.10.3/themes/base/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="libs/bootstrap-2.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="libs/fotorama-4.4.8/fotorama.css" />
    <link rel="stylesheet" type="text/css" href="libs/wp-pagenavi-2.50/pagenavi-css" />
    <link rel="stylesheet" type="text/css" href="libs/prettyPhoto/prettyPhoto.css" />
    <link rel="stylesheet" type="text/css" href="libs/anthology/styles/superfish.css" />
    <link rel="stylesheet" type="text/css" href="libs/anthology/plugins/fonts/fonts.css" />
    <link rel="stylesheet" type="text/css" href="styles/style.css" />
    <link rel="stylesheet" type="text/css" href="styles/model-jewellery.css" />
    <link rel="stylesheet" type="text/css" href="styles/model-diamond.css" />
    <script type="text/javascript" src="libs/jquery-1.9.1/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="libs/jquery-ui-1.10.3/ui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="libs/jquery-ui-touch-punch-0.2.2/jquery.ui.touch-punch.min.js"></script>
    <script type="text/javascript" src="libs/jQuery.jPlayer.2.5.0/jquery.jplayer.min.js"></script>
    <script type="text/javascript" src="libs/angular-1.2.6/angular.js"></script>
    <script type="text/javascript" src="libs/angular-1.2.6/angular-resource.min.js"></script>
    <script type="text/javascript" src="libs/angular-1.2.6/angular-route.min.js"></script>
    <script type="text/javascript" src="libs/angular-1.2.6/angular-cookies.min.js"></script>
    <script type="text/javascript" src="libs/angular-1.2.6/angular-sanitize.min.js"></script>
    <script type="text/javascript" src="libs/angular-1.2.6/angular-touch.min.js"></script>
    <script type="text/javascript" src="libs/angular-1.2.6/angular-animate.min.js"></script>
    <script type="text/javascript" src="libs/angular-ui-bootstrap-0.7.0/ui-bootstrap-tpls-0.7.0.min.js"></script>
    <script type="text/javascript" src="libs/fotorama-4.4.8/fotorama.js"></script>
    <script type="text/javascript" src="libsx/jquery-ui-slider-namearray.js"></script>
    <script type="text/javascript" src="libsx/touch-tricks.js"></script>

    <link rel="stylesheet" type="text/css" href="styles/fix-anthlogy-style.css" />
    <link rel="stylesheet" type="text/css" href="styles/fix-4c-screen.css" />
    <link rel="stylesheet" type="text/css" href="styles/model-common.css" />

    <script src="scripts/mvc/model-common.js"></script>
    <script src="scripts/mvc/model-filter.js"></script>
    <script src="scripts/mvc/model-diamond.js"></script>
    <script src="scripts/mvc/model-jewellery.js"></script>
    <script src="scripts/mvc/model-4c.js"></script>
    <script src="scripts/mvc/model-misc.js"></script>
    <script src="scripts/mvc/model-wishcar.js"></script>
    <script src="scripts/mvc/app-main.js"></script>

    <script src="scripts/env.js"></script>
    <script src="scripts/config.js"></script>
    <script src="scripts/main.js"></script>
    
```

### 害怕了？😨
我也怕了，不仅是我们怕了，浏览器也怕了。浏览器为了照顾设备的感受，一般情况下是会限制同一时间的发送网络请求的次数的，所以这必然造成了网站的访问速度下降。So，玩Ruby的那群人做了些gem `Sprockets` `Jammit`来当做连接css和js并压缩它们的框架，后来发现确实好用，Rails3.2也就自带了。于是便有了统一管理这些css和js的资源目录，框架会自己去相应的目录里面寻找这些文件然后生产一份大文件，随后就有了Rails应用的标志HTML
	
	<link href="/assets/application-1e0b7b6177f955c71f083db518841bbf.css" media="all" rel="stylesheet" type="text/css" />
	<script src="/assets/application-ef900b6062fe4b543f09c78ba9062141.js" type="text/javascript"></script>

这样子，世界一下清净了很多呢，这便是`assets pipline`概念的由来。当然，我所在的那个项目因为是基于本地html做的，所以加载这么多次资源文件压力会很小，如果是在线的应用按照assets pipline的思路来是最好的选择。

