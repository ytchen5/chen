### tr工具

tr用于字符串转换，替换和删除，主要用于`删除文件中的控制字符`或进行`字符转换`

***语法和选项***

***语法***

用法1：命令的执行结果交给tr处理，其中`string1`用于查询的字符串，`string2`用于转换的字符串

```
# commands| tr 'string1' 'string2'
```



用法2：tr处理的内容来自与文件，需要使用`<`标准输入

```
# tr 'string1' 'string2' < filename
```



用法3：匹配到`string1`进行相应的操作，如删除操作

```
# tr options 'string1' < filename
```



***常用选项***

```
-d	删除字符串1中的所有输入字符串
-s	删除所有重复的出现的字符串序列，只保留第一个，即将重复出现的字符串压缩成为一个字符串
```



***常用匹配字符串***

| 字符串         | 含义                   | 备注                                                         |
| -------------- | ---------------------- | ------------------------------------------------------------ |
| a-z或[:lower:] | 匹配所有的小写字母     |                                                              |
| A-Z或[:upper:] | 匹配所有的大写字母     |                                                              |
| 0-9或[:digit:] | 匹配所有的数字         |                                                              |
| [:alnum:]      | 所有字母和数字         |                                                              |
| [:alpha:]      | 所有的字母             |                                                              |
| [:blank:]      | 所有的水平空白         |                                                              |
| [:punct:]      | 匹配所有标点符号       |                                                              |
| [:space:]      | 所有的水平或者垂直空格 |                                                              |
| [:cntrl:]      | 所有的控制字符         | \f   Ctrl-L 走行换页<br>\n  Ctrl-J 换行<br> \r  Ctrl-M 回车<br> \t  Ctrl-l   Tab键 |

***举例说明***

1、准备测试文件

```
[root@vm1 scripts]# cat filename.txt 
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
[root@vm1 scripts]# 
```

2、将这个文件中的所有的小写字母替换成为大写字母

```
[root@vm1 scripts]# tr '[:lower:]' '[:upper:]' < filename.txt >>finename.txt
[root@vm1 scripts]# cat finename.txt 
ROOT:X:0:0:ROOT:/ROOT:/BIN/BASH
BIN:X:1:1:BIN:/BIN:/SBIN/NOLOGIN
DAEMON:X:2:2:DAEMON:/SBIN:/SBIN/NOLOGIN
ADM:X:3:4:ADM:/VAR/ADM:/SBIN/NOLOGIN
LP:X:4:7:LP:/VAR/SPOOL/LPD:/SBIN/NOLOGIN
SYNC:X:5:0:SYNC:/SBIN:/BIN/SYNC
SHUTDOWN:X:6:0:SHUTDOWN:/SBIN:/SBIN/SHUTDOWN
HALT:X:7:0:HALT:/SBIN:/SBIN/HALT
MAIL:X:8:12:MAIL:/VAR/SPOOL/MAIL:/SBIN/NOLOGIN
OPERATOR:X:11:0:OPERATOR:/ROOT:/SBIN/NOLOGIN
```

3、将这个文件中的所有数字成@符号

```
[root@vm1 scripts]# tr '[:digit:]' '@' < filename.txt
root:x:@:@:root:/root:/bin/bash
bin:x:@:@:bin:/bin:/sbin/nologin
daemon:x:@:@:daemon:/sbin:/sbin/nologin
adm:x:@:@:adm:/var/adm:/sbin/nologin
lp:x:@:@:lp:/var/spool/lpd:/sbin/nologin
sync:x:@:@:sync:/sbin:/bin/sync
shutdown:x:@:@:shutdown:/sbin:/sbin/shutdown
halt:x:@:@:halt:/sbin:/sbin/halt
mail:x:@:@@:mail:/var/spool/mail:/sbin/nologin
operator:x:@@:@:operator:/root:/sbin/nologin
```

4、将这个文件中`:`和`/` 都替换成`#`

```
[root@vm1 scripts]# tr ':/' '#' < filename.txt
root#x#0#0#root##root##bin#bash
bin#x#1#1#bin##bin##sbin#nologin
daemon#x#2#2#daemon##sbin##sbin#nologin
adm#x#3#4#adm##var#adm##sbin#nologin
lp#x#4#7#lp##var#spool#lpd##sbin#nologin
sync#x#5#0#sync##sbin##bin#sync
shutdown#x#6#0#shutdown##sbin##sbin#shutdown
halt#x#7#0#halt##sbin##sbin#halt
mail#x#8#12#mail##var#spool#mail##sbin#nologin
operator#x#11#0#operator##root##sbin#nologin
```

5、将这个文件内部的所有的换行符号替换成`空格`或者`,`

```
[root@vm1 scripts]# tr '[:cntrl:]' ',' < filename.txt
[root@vm1 scripts]# tr '[:cntrl:]' ' ' < filename.txt
```



6、删除这个文件中的所有的小写字母

```
[root@vm1 scripts]# tr -d '[:lower:]'  < filename.txt
::0:0::/://
::1:1::/://
::2:2::/://
::3:4:://://
::4:7::///://
::5:0::/://
::6:0::/://
::7:0::/://
::8:12::///://
::11:0::/://
```

7、将一个文件内部的连续的字母压缩成单个，慎用

```
[root@vm1 scripts]# cat filename.txt 
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
aaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbcccccccccccccccdddddddddddddd
abcdabcdabcd
[root@vm1 scripts]# tr -s '[:lower:]' <  filename.txt 
rot:x:0:0:rot:/rot:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spol/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spol/mail:/sbin/nologin
operator:x:11:0:operator:/rot:/sbin/nologin
abcd
abcdabcdabcd
```

8、过滤出本机的ip地址

```
[root@vm1 scripts]# ifconfig eth0| grep -w inet | tr -s '[:blank:]' | cut -d" " -f2,3
inet 192.168.100.155
[root@vm1 scripts]# ifconfig eth0| grep -w inet | tr -s '[:blank:]' | cut -d" " -f4,5
netmask 255.255.255.0
[root@vm1 scripts]# ifconfig eth0| grep -w inet | tr -s '[:blank:]' | cut -d" " -f6,7
broadcast 192.168.100.255
[root@vm1 scripts]# 
```



