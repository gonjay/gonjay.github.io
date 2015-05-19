---
layout: post
title: "Git撤销最近一次Commit"
date: 2014-11-23 00:32:05 +0800
comments: true
categories: ["Git"]
---

有时候会发现commit错了，需要重新commit，但是又不想为了一个小的修改多一次修复的commit。

<!--more-->
```sh
$ git commit ... (1)
$ git reset --soft 'HEAD^' (2)
$ edit (3)
$ git add .... (4)
$ git commit -c ORIG_HEAD (5)
```