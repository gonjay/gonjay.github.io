---
layout: post
title: "Rosace API"
date: 2014-03-07 00:04:23 +0800
comments: true
categories: 
# syntax
===

#### 文本：

	1.  {{ expr }} 
	2. !{{ unsafe_expr }}
	3. #{{ text }}#
	4. \(任意字符）

属性：（可加 namespace 如 <elem rosace:if="expr">）

    1. <elem var.varname="expr">
    2. <elem repeat.varname="expr">
    3. <elem if="expr">
    4. <elem if.attrname="expr">
    5. <elem templ="text {{ expr }}">
    6. <elem macro="macroname(param,..)[optional (arg,...)]">
    7. <elem require.renderername="src.html">

自动编译模板：（使用 rosace-page.js 时有效）

    <elem class="rosace">...</elem>

自动渲染数据：（使用 rosace-page.js 时有效，优先级从高到低）

    1. <elem class="rosace">
          <script type="text/json" class="rosace-data">
             { "items" : [1, 2, 3] }
          </script>
          ...
       </elem>
    2. <elem class="rosace">
          <script type="text/json" src="data.json" class="rosace-data"></script>
          ...
       </elem>
    3. <elem class="rosace" [rosace:]data-obj="expr">
    4. <elem class="rosace" [rosace:]data-src="src.json">


===
# api
===

1. 创建（或取回已缓存的）模板

		var renderer = $rosace('<elem>...</elem>', [optional] opts, [optional] 		callback(err, renderer));
                            (element,
                            ([element, ..],
                            (element.childNodes,
                            ($(selector),
                            (url,
   
  		当参数为 url 时，返回的 renderer 尚未初始化
  
  		必须等到 callback(err, renderer) 被调用时才处在可用的状态

2. 渲染模板与宏

		在模板外：
	    var html = renderer(data_object);
               renderer.macroname(arg, arg2, ...);

    	在模板内：
  
		!{{ this(data_object) }}
    	!{{ this.macroname(arg, arg2, ..) }}
	    !{{ renderername(data_object) }}
    	!{{ renderername.macroname(arg, arg2, ...) }}

3. 用 jQuery 一次性编译+渲染
		
		var renderer = $(selector).rosace([optional] data_object, [optional] opts);
		

4. opts 

		(string)  id：指定模板根元素的 id。如果不指定，会自动生成。
		(bool) cache：是否缓存已编译的模板

		默认值：{ id: undefined, cache: true })
		仅当用 html, url 或单个 elem 编译模板时有效。

5. 第三方依赖

  		使用 YAML 需引用：[js-yaml](http://nodeca.github.io/js-yaml/)


===
# samples
===


2-7: require

inc-menu.html
-------------
	<ul macro="ul(items)(tree.items)">
	    <li repeat="item in items">
	        {{ item.name }}
	        !{{ item.subitems && this.ul(item.subitems) }}
	    </ li>
	</ul>

page.html
---------
	<div class="rosace" data-src="tree.json" require.menu="inc-menu.html">
	    !{{ menu({ tree: tree }) }}
	    !{{ menu.ul(tree.items) }}
	</div>




创建好的模板本身是一个形如 `function (data) { return str; }` 的函数
例如：

	var html = '<span macro="hello(name)('World')">Hello, {{user}}!</span>' +
	           '{{ this.hello('rosace') }}';
	var f = $rosace(html);

	f({ user: 'World' })

	--> 输出
	<span>Hello, World!</span>
	<span>Hello, rosace!</span>

创建好的模板里包含有所有子模板的引用。
例如还是刚才的模板为例：

	var html = '<span macro="hello(name)('World')">Hello, {{user}}!</span>' +
	           '{{ this.hello('rosace') }}';
	var f = $rosace(html);

	f.hello('World')
	--> 输出
	<span>Hello, World!</span>

	<elem id="temp">
	   {{ name }}
	<elem>

调用 `$('#temp').rosace({ name: 'Kabbesy' });`
则页面直接被修改为

	<elem id="temp>
	   Kabbesy
	</elem>