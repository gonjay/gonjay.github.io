---
layout: post
title: "使用 ffmpeg 每隔 1s 截取 1 张图片"
date: 2014-11-27 19:11:15 +0800
comments: true
categories: ["ffmpeg"]
---
ffmpeg 是一很强大的软件，不过没有 GUI ，基本用法一旦掌握就能用来做很多事情了。

<!--more-->

每隔一秒钟截取一帧，输出为一个 gif

	ffmpeg -i vid.avi -y -f gif -vf fps=fps=1 a.gif

每隔一秒截取一帧，输出为 foo-%03d.jpeg 的多张图片

	ffmpeg -i vid.avi -y -f image2 -vf fps=fps=1 foo-%03d.jpeg

http://wenku.baidu.com/view/296eefcaf90f76c661371af1.html