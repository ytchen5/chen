#### paste工具

paste文件用于合并文件行，将两个文件每一行合并起来

***常用选项：***

```
-d	自定义间隔符号，默认是tab
-s	串行处理，非并行处理
```

***举例说明：***

```
[root@vm1 scripts]# cat -n file1
     1	hello world
     2	8888
[root@vm1 scripts]# cat -n file2
     1	ytchen5 zhao
     2	99999
     3	000
[root@vm1 scripts]# 
[root@vm1 scripts]# paste file1 file2
hello world	ytchen5 zhao
8888	99999
	000
自定义合并起来之后的分隔符为:
[root@vm1 scripts]# paste -d: file1 file2
hello world:ytchen5 zhao
8888:99999
:000

串行处理每个文件占用一行
[root@vm1 scripts]# paste -s -d:  file1 file2
hello world:8888    # 第一个文件
ytchen5 zhao:99999:000  # 第二个文件
[root@vm1 scripts]# 

```

