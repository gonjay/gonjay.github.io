---
layout: post
title: "LeetCode 小结"
date: 2015-01-03 15:21:50 +0800
comments: true
categories: 
---
LeetCode小结

Longest Common Prefix 与 Longest Valid Parentheses

<!--more-->

## Longest Common Prefix

最长公共前缀，和这个问题相关的还有最长公共子序列，不过 LeetCode 上的这道 Longest Common Prefix 比较简单，题目的意识是给一些字符串的数据，找到他们相同部分的前缀，例如：

	a
	aabb
	aabbcc

的最长公共前缀是 `a`，再比如：

	abc
	abcc
	abcd

的最长公共前缀是 `abc`。

这种 `Common Prefix` 或者 `Common Sequence` 字眼的题目貌似经常出现在 ACM 比赛当中，我之前没有 ACM 的经验，做起来就把类似 Prefix 和 Sequence 的问题给弄混淆了，囧。

## Longest Valid Parentheses

匹配最长的有效括号的题目，需要运用数据结构中栈的知识，别小看这道题目哦，LeetCode上面的 AC 为：

	Total Accepted: 23174 Total Submissions: 115348

这个题目上我踩的坑主要是对题目的理解上，比如 "()()(()" 的答案是 4，比如 "()(())" 的答案是 6，比如 "()(()" 的答案是 2，我得 Python 代码如下：

```python
class Solution:
    # @param s, a string
    # @return an integer
    def longestValidParentheses(self, s):
        arr = []
        maxLen = 0
        # 一个比较 trick 的操作
        arr.append(-1)
        for i in range(len(s)):
            if s[i] == "(":
                # 把当前 "(" 所在的位置压入栈中
                arr.append(i)
            else:
                arr.pop()
                # 如果栈空了，就把 ")" 所在的位置压入栈
                if len(arr) < 1:
                    arr.append(i)
                else:
                    # 比较，用当前的位置减去上一次出栈(pop)的位置
                    # 并和历史上的最长有效的括号比较
                    maxLen = max(maxLen, i - arr[-1])
        return maxLen
```