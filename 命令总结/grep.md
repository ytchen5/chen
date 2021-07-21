# grep
grep是行过滤工具，用于根据关键字进行过滤

grep 家族  
grep 在文本中全局查找制定的正则表达式, 并打印包含该正则表达式的行  
egrep 扩展的grep, 支持更多的正则表达式元字符  
fgrep  固定的grep(fixed grep),有时候也被称作快速(fast grep),它按照字面解释所有字符  

语法和选项：

**语法：**

```
grep [选项] '关键字'	文件名
```

***常见选项：***

```
OPTIONS
-i	不区分大小写
-v	查找不包含指定内容的行，反向选择
-w	按单词搜索
-o	打印匹配关键字
-c	统计匹配到的次数
-n	显示行号
-r	逐层遍历目录查找
-A	显示匹配到的行及后面多少行
-B	显示匹配到的行及前面多少行
-C	显示匹配到的行及前后多少行
-l	列出匹配的文件名
-L	列出不匹配的文件名
-e	使用正则表达式
-E	使用扩展正则表达式
-q --quiet,--silent 静默 --quiet --silent  
^key	以关键字开头
key$	以关键字结尾
^$		匹配空行
--color=auto	可以将找到的关键字加上颜色显示
```

***grep 返回状态码***

找到: 	grep 返回退出状态为0  
没找到:	grep返回退出状态为1  
找不到指定文件:	grep返回退出状态为2  
grep 程序的输入可以来自标准输入或者 管道, 而不仅是文件, 例如:

***grep使用的基本元字符*** 

 使用基本元字符 ^ $ . \* \[\] \[^\] \\< \\> \\(\\) \\{\\}  

***grep使用的扩展元字符*** 

 使用扩展元字符 \\+ \\|  

egrep(或grep -E)  
 使用扩展元字符 ? + {} | ()  
\\w   所有字母与数字  称为字符 \[a-zA-Z0-9\]  l\[a-zA-Z9-0\]\*ve  等价于 l\\w\*ve  
\\W   所有字母与数字之外的字符 称为非字符  love\[^a-zA-Z0-9\]+ 等价于 love\\W+  
\\b   词边界        \\<love\\>    等价于 \\blove\\b

grep示例:  
grep -E 或者 egrep

egrep 'NW' datafile  
egrep 'NW' d\*  
egrep '^n' datafile  
egrep '4$' datafile  
egrep '5\\..' datafile  
egrep '\\.5' datafile  
egrep '^\[we\]' datafile  
egrep '^n\\w\*\\W' datafile   

***过滤配置文件的注释行和空行***

```
[root@vm1 ~]# egrep -v '(^#|^$)' /etc/vsftpd/vsftpd.conf  #过滤掉注释行和空行
anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
```

***过滤出本机网卡的ip地址，子网掩码和广播地址***

```
[root@vm1 scripts]# ifconfig eth0 | egrep -o [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} | grep -v :
192.168.100.155
255.255.255.0
192.168.100.255
```

