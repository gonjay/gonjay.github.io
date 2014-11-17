---
layout: post
title: "Ruby 中的'小语法'"
date: 2014-09-17 00:00:50 +0800
comments: true
categories: ['Ruby']
---
生成1到10的数组
```ruby
array = (1..10).to_a
```

通过数组的each，直接调用对象的方法
```ruby
ActiveRecord::Base.subclasses.each(&:delete_all)
```