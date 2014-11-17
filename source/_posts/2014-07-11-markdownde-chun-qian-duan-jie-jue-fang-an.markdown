---
layout: post
title: "Markdown的纯前端解决方案"
date: 2014-07-11 11:28:33 +0800
comments: true
categories: ['Markdown', 'Projects']
---

## 更新

这个解决方案应该是我目前遇到的最完美的方案了：

http://jbt.github.io/markdown-editor/

### Stuff used to make this:

 * [marked](https://github.com/chjj) for Markdown parsing
 * [CodeMirror](http://codemirror.net/) for the awesome syntax-highlighted editor
 * [highlight.js](http://softwaremaniacs.org/soft/highlight/en/) for syntax highlighting in output code blocks
 * [js-deflate](https://github.com/dankogai/js-deflate) for gzipping of data to make it fit in URLs

## Old

前阵子在维护一个Node.js的项目，是用来做git仓库管理的，类似 `github` `gitlab` 之类的内部项目。

整个项目的Markdown以及包括代码高亮等的操作，全部放在后端来渲染，因为人家Node.js本来就是`Javascript`嘛，所以各种js的库也是用得顺手。不像许多Node项目是由前端出身的人转做后端，这个项目给人的感觉就是一个纯后端做出来的东西，整个前端部分在我看来很多都可以剥离出来的。

其实不仅仅像这种项目，许多web应用都是，它作为一个web app来使用的时候，不是什么事情都交给后端就好了，后端很强大能实现很多东西，但是后端毕竟不是万能的，该用前端优化的时候就应该应前端来做，典型的例子就是Markdown文本的渲染了。

其实像我知道的github、ruby-china等，Markdown的渲染都是交由后端来实现的，不是特别理解这个事情，因为在github上面经常会因为网络不通常导致，一个markdown的文本预览不到，很是恼火，ruby-china因为是在国内，所以感觉不出来。

而且放到后端渲染还有一个比较痛苦的问题就是升级和维护这个模块，用起来不觉得，一旦要升级下markdwon渲染引擎的版本可着实一件苦逼的事情。

所有在有了showdown.js这样的神器之后，果断将整个项目的Markdwon放到到了前端，配合着highlight.js非常的容易就能实现Markdown文本的渲染，最关键的是，因为jQuery的便利性，这货和后端结合的时候完全是无缝的啊有木有。

这里有一个 [传送门](http://gonjay.github.io/editor/)，是我测试用的在线Markdown在线编辑器，可以查看一下源代码，非常简单就能完成设置。

{% gist 9a2d7b4e97f6e483c475 index.js %}

步骤是：

* showdown.js渲染出对应的html
* highlight.js渲染对应的语言的语法高亮