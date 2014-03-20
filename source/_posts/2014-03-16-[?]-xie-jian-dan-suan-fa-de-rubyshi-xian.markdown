---
layout: post
title: "一些简单算法的Ruby实现"
date: 2014-03-16 10:32:51 +0800
comments: true
categories: 
---
## 插入排序
直接插入排序

原理：将数组分为无序和有序两个区，然后不断将无序区的第一个元素按大小顺序插入到有序区中，最终将所有无序区元素都移动到无序区完成排序。

```c
	void InsertSort(Node L[],int length)
	{
		int i,j;
		for(i = 1; i < length; i ++)
		{
			j = i + 1;
			if(L[j] < L[i])
			{
				L[0] = L[j];
				//当L[0]小于有序区的最后一个元素的时候，最后一个元素扩大，再和有序区倒数第二个比较
				while(L[0] < L[i])
				{
					L[i+1] = L[i];
					i --;
				}
				L[i+1] = L[0];
			}
			i = j - 1;
		}		
	}
```


```ruby
def insert_sort(node)
  i,j=0
  for i in 0...(node.length - 1)
    # puts i
    j = i + 1
    if node[j] < node[i]
      break if node[j].nil?
      n = node[j]
      while n < node[i]
        node[i+1] = node[i]
        i -= 1
      end
      node[i+1] = n
    end
    i = j - 1
  end
  node
end

node = [7,2,13,4,5,1,1]

puts insert_sort node

```

希尔算法

原理：又称增量缩小排序。先将序列按增量划分为元素个数相同的若干组，使用直接插入排序法进行排序，然后不断缩小增量直至1，最后使用直接插入排序完成排序。

```c
void ShellSort(Node L[], int d)
{
  while(d >= 1)
  {
  	Shell(L,d);
  	d = d/2;
  }
}

void Shell(Node L[], int d)
{
  int i,j;
  for(i = d + 1 ; i < length; i ++)
  {
  	if(L[i] < L[i-d])
  	{
      L[0] = L[i];
      j = i - d;
      while(j > 0 && L[j] > L[0])
      {
      	L[j+d] = L[j];
      	j = j - d;
      }
      L[j+d] = L[0];
  	}
  }
}

```

```ruby
def shell_sort(node, d)
  while(d > 0)
	shell node, d
	d = d / 2
  end
end

def shell(node, d)
  j = 0
  i = i + d
  for i in 1...(node.length - 1) do
    if(node[i] < node[i-d])
      j = i - d
      node[0] = node[i]
      while(j > 0 && node[j] > node[i])
      	node[j+d] = node[j]
      	j = j - d
      end
      node[j] = node[0]
    end
  end
end
```

### 交换排序

冒泡排序

原理：将序列划分为无序和有序区，不断通过交换较大元素至无序区尾完成排序

```c
void bubble_sort(Node L[])
{
  int i, j;
  Bool isChanged;
  for(j = L.length; j > 0; j --)
  {
  	isChanged = false;
  	for(i=0; i < j; i ++)
  	{
  	  if(L[i] > L[i+1])
  	  {
  	  	int temp = L[i];
  	  	L[i] = L[i+1];
  	  	L[i+1] = temp;
  	  	isChanged = true;
  	  }
  	}
  	if(!isChanged)break;
  }
}
```

### 选择排序
直接选择排序

原理：将序列分为无序和有序区，寻找无序区中最小值和无序区的首元素交换，有序区扩大一个，循环最终完成排序

```c
void SelectSort(Node L[])
{
  int i,j,k;
  for(i=0;i<L.length;i++)
  {
  	k = i;
  	for(j=i+1;j<L.length;j++)
  	{
  	  if(L[j] < L[k]) k = j;
  	}
  	if(k != i)
  	{
  	  int temp = L[i];
  	  L[i] = L[k];
  	  L[k] = temp;
  	}
  }
}
```

堆排序

原理：利用大根堆或小根堆思想，首先建立堆，然后将堆首与堆尾交换，堆尾之后为有序区。











































