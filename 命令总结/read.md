### read交互式定义变量

目的：让用户自己给变量赋值，比较灵活

语法：read [选项] 变量名

常见选项：

| 选项 | 释义                                                       |
| ---- | ---------------------------------------------------------- |
| -p   | 定义提示用户信息                                           |
| -n   | 定义字符数（限制变量的长度）                               |
| -s   | 不显示（不显示用户输入的内容）                             |
| -t   | 定义超时时间，默认单位为秒（限制用户输入变量值的超时时间） |

举例说明：

```
[root@vm1 dir1]# read name
harry
[root@vm1 dir1]# echo $name
harry


[root@vm1 dir1]# read -p "please enter name: " name
please enter name: harry
[root@vm1 dir1]# echo $name
harry

[root@vm1 dir1]# read -s  name
[root@vm1 dir1]# echo $name
ytchen5
[root@vm1 dir1]# 

[root@vm1 dir1]# read -n 3  name
mer[root@vm1 dir1]# echo $name
mer
[root@vm1 dir1]# 

[root@vm1 dir1]# read -t 5  name
[root@vm1 dir1]# 
[root@vm1 dir1]# echo $name

[root@vm1 dir1]#  
```

