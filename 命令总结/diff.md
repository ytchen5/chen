

## diff工具

diff工具用于逐行比较文件的不同

注意：diff描述两个文件不同的方式是告诉我们怎样改变第一个文件之后与第二个文件匹配

### 语法和选项

#### 语法

```
diff [选项] 文件1 文件2
```

#### 常用选项：

| 选项     | 含义                                         | 备注 |
| -------- | -------------------------------------------- | ---- |
| -b       | 不检查空格                                   |      |
| -B       | 不检查空白行                                 |      |
| -i       | 不检查大小写                                 |      |
| -w       | 忽略所有的空格                               |      |
| --normal | 正常格式显示（默认）                         |      |
| -c       | 上下文格式显示                               |      |
| -u       | 合并格式显示                                 |      |
| -q       | 只比较目录文件不同，不比较文件内容有什么不同 |      |

#### 举例说明

比较连个普通文件异同，文件准备

```
[root@vm1 scripts]# cat -n file1
     1	aaaa
     2	111
     3	hello world
     4	222
     5	333
     6	bbb
[root@vm1 scripts]# cat -n file2
     1	aaa
     2	hello
     3	111
     4	222
     5	bbb
     6	333
     7	world
```

***正常显示***

```
[root@vm1 scripts]# diff file1 file2
1c1,2   # 第一个文件第一行需要改变（C=change）才能和第二个文件第一和第二行相同
< aaaa  # <代表表示左面file1的文件内容
---		# 表示分隔符
> aaa	# >代表右面的文件file2的件内容
> hello # >代表右面的文件file2的件内容
3d3		# 第一个文件的第3行删除（d=delete）才能和第二个文件的第三行相同
< hello world
5d4		# 第一个文件的第5行删除才能和第二个文件的第四行相同
< 333
6a6,7	# 第一个文件的第6行增加如下内容才能和第二个文件的第6，7 行相同
> 333
> world
```

***上下文格式显示***

```
[root@vm1 scripts]# diff -c file1 file2
前两行主要列出需要比较的文件名和文件的时间戳 ***代表file1 ---代表file2
*** file1	2021-07-19 09:08:44.646923235 -0400
--- file2	2021-07-19 09:09:34.836465546 -0400
*************** #我是分隔符
*** 1,6 **** #以***开头表示文件file1文件，1,6表示1到6行
! aaaa		 # 表示改行需要修改才与第二个文件匹配
  111			
- hello world	# 表示需要删除改行才与第二个文件匹配
  222			
- 333			# 表示需要删除改行才与第二行匹配
  bbb
--- 1,7 ----     # 以---开头的表示file2文件，1，7表示1-7行
! aaa			 # 表示第一个文件需要修改成的样子
! hello		     # 表示第一个文件需要修改成的样子
  111
  222
  bbb
+ 333			# 表示第一个文件需要添加的内容
+ world         # 表示第一个文件需要添加的内容
```

***合并格式显示***

```
[root@vm1 scripts]# diff -u file1 file2
--- file1	2021-07-19 10:09:09.776754067 -0400
+++ file2	2021-07-19 10:08:35.945540319 -0400
@@ -1,6 +1,7 @@
-aaaa
+aaa
+hello
 111
-hello world
 222
-333
 bbb
+333
+world
[root@vm1 scripts]# 
```

***比较两个目录不同***



```
默认情况下也会比较两个目录里面相同文件的内容
[root@vm1 scripts]# diff dir1 dir2
Only in dir1: file1
diff dir1/file2 dir2/file2
0a1,7
> aaa
> hello
> 111
> 222
> bbb
> 333
> world
Only in dir2: test1
Only in dir2: test2
Only in dir2: test3
[root@vm1 scripts]# 
使用-q可以只比较文件不比较文件内容
[root@vm1 scripts]# diff -q dir1 dir2
Only in dir1: file1
Files dir1/file2 and dir2/file2 differ
Only in dir2: test1
Only in dir2: test2
Only in dir2: test3
```

***其他小技巧***

有时候我们需要以一个文件为标准，去修改其他文件，并且修改的地方较多时候我们需要以打补丁的方式完成

```
1)先找出文件的不同并保存在一个文件里面
diff -uN ./dir1/file1 ./dir2/file2 >./file.patch   # 谁在后面就以谁为标准
-u 上下文格式显示
-N	将不同的文件当做空文件

2）将不同的文件当补丁到文件
[root@vm1 scripts]# patch ./dir1/file1 file.patch 
patching file ./dir1/file1

3)测试验证
[root@vm1 scripts]# diff ./dir1/file1 ./dir2/file2 
[root@vm1 scripts]# 
```

