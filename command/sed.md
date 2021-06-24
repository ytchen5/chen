# sed
一. sed工作流程

sed是一种在线的,非交互式的编辑器,它一次处理一行内容,处理时把当前处理的行存储在缓冲区中,称为模式空间(pattern space)  
接着用sed处理缓冲区中的内容,处理完成后把缓冲区的内容送往屏幕,接着处理下一行, 这样不断重复,直到文件尾部,文件  
内容并没有改变,除非你用重定向存储输出, sed主要用来自动编辑一个或者多个文件,简化对文件的反复操作,编写转换程序

二. 命令格式  
sed \[options\] 'command' file(s)  
sed \[options\] -f scriptfile file(s)  
注意:  
 sed和grep不一样不管是否找到指定的模式, 它的推出状态都是0  
 只有当命令存在语法错误时,sed的退出状态才为非0  
三. 支持正则表达式  
与grep一样, sed在文件中查找模式时候也可以使用正则表达式(RE)和各种元字符,正则表达式是括在斜杠间的  
模式, 用于查找和替换, 一下是sed支持的元字符

基本元字符: ^ $ . \* \[\] \[^\] \\< \\> \\(\\) \\{\\}  
扩展元字符: ? + {} | ()

使用扩展元字符的方式  
\\+  
sed -r  
:~$ sed --help | grep '\\-r'  
  -E, -r, --regexp-extended  
四. sed的基本用法  
~$ sed -r '' /etc/passwd  
~$ sed -r 'p' /etc/passwd  
~$ sed -r -n 'p' /etc/passwd  
~$ sed -r -n '/^root/p' /etc/passwd 或者 sed -rn  '\\#r..t#p' passwd  
~$ sed -r 's/root/alice@/' /etc/passwd  
~$ sed -r 's/root/alice@/g' /etc/passwd  
~$ sed -r  's/R..t/alice@/gi' passwd  g 全部替换 i 忽略大小写  
五. sed扩展  
\=====地址(定址)  
地址用于决定对那些进行编辑,地址形式可以是数字 正则表达式 或者是二者的结合,如果没有指定地址,sed将处理文本  
中的所有行.  
sed -r '3d' passwd  
sed -r '1,3d' passwd  
sed -r '/root/d' passwd  
sed -r '/root/,5d' passwd

   
$ sed -r '/^bin/,5d' passwd   
 #找到bin开始的行 然后删除到第5行, 如果bin开头所在行数大于第五行,则只删除bin所在的行.  
   
$ sed -r '/^bin/,+5d' passwd   
 # 找到bin开头的行,然后往后删除5行,包括bin所在的行 总共删除6行. +5d 带表从当前行算起往后数5行  
   
$ sed -r '/^daemon/,$d' passwd  
 # 找到daemon开头的行 然后开始删除删除到最后 $d 代表删除到最后一行  
$ sed -r '/root/!d' passwd  
 # 删除除包含root的行,   !表示取反的意思.

$ sed -r '0~2d' passwd  
 # 删除偶数行 ~2 代表步长  
$ sed -r '1~2d' passwd  
 # 删除奇数行 ~2 代表步长

\=====子命令

子命令  功能  
a   在当前行后添加一行或者多行  
c   用新文本修改(替换)当前行中文本  
d   删除行  
i   在当前行之前插入文本  
l   列出非打印字符  
p   打印行  
n   读入下一输入行,并从下一条命令而不是第一条命令开始对其的处理  
q   结束或者退出sed  
!  对所选行已外的所有行应用命令  
s   用于一个字符串替换另外一个  
  s 替换标志 g 在行内进行全局替换  i 忽略大小写  
r   从文件中读取  
w   将行写入文件  
y   将字符串转换为另一字符(不支持正则表达式)

h   把模式空间里面的内容复制到暂存缓存区(覆盖)  
H   把模式空间里面的内容追加到暂存缓冲区  
g   取出暂存缓存区里面的内容,将其复制到模式空间(覆盖模式空间原有的内容)  
G   取出暂存缓存区里面的内容,将其追加到模式空间(追加到原有内容后面)  
x   交换暂存缓冲区与模式空间的内容

\=====选项

\-e   允许多项编辑  
\-f   指定sed脚本文件名  
\-n   取消默认输出  
\-i   inplace 直接编辑源文件  
\-r   支持扩展元字符

\=====sed命令示例

删除命令:

替换命令 :s  
sed -r '3,5s/^/#/' passwd   #实现第3行-第5行加上注释  
sed -r '3,5s/.\*/#&/' passwd #实现第3行-第5行加上注释  &表示前面匹配到的内容  
sed -r '3,5s@(.\*)@#\\1@' passwd #实现第3行-第5行加上注释  使用() 和\\1表示前面匹配到的内容

sed -r 's/(.)(.)(.\*)/\\1yyyy\\2\\3/' passwd  实现在每一行第二个字符前面加上yyyy  
ryyyyoot:x:0:0:root:/root:/bin/bash  
dyyyyaemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin  
byyyyin:x:2:2:bin:/bin:/usr/sbin/nologin  
syyyyys:x:3:3:sys:/dev:/usr/sbin/nologin  
syyyyync:x:4:65534:sync:/bin:/bin/sync  
gyyyyames:x:5:60:games:/usr/games:/usr/sbin/nologin  
myyyyan:x:6:12:man:/var/cache/man:/usr/sbin/nologin  
lyyyyp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin  
myyyyail:x:8:8:mail:/var/mail:/usr/sbin/nologin  
nyyyyews:x:9:9:news:/var/spool/news:/usr/sbin/nologin  
chenyantao@cyt:~$

读取文件命令 :r  
sed -r '/r..t/r /etc/hosts' passwd  
sed -r '2r /etc/hosts' passwd   
sed -r '/2/r /etc/hosts' passwd

保存文件命令 w  
sed -r '/root/w /tmp/1.txt' passwd  
sed -r '5,$w /tmp/1.txt' passwd  将第5行-最后一行保存到另外一个文件

插入命令 a在匹配行后面插入 i在匹配行前面 c 替换匹配行  
sed -r '2a1111111' passwd   
sed -r '2a1111111\\n22222222222\\n33333333333333' passwd  添加多行内容  
sed -r '2i1111111' passwd   
sed -r '2c1111111' passwd

获取下一行命令

sed '/man/{n;d}' passwd  #对匹配到的行下一行执行删除命令  
sed '/man/{n;s/lp/&pppp/}' passwd  
sed '/man/{n;n;s/mail/&pppp/}' passwd n可以用多次 处理下下一行

\===sed常见操作  
1 删除配置文件内部的#开头的注释行  
sed -ri '/^\[ \\t\]\*#/d' test.txt   ^\[ \\t\]\* 代表以0个到多个空格或者tab开头的行

2 删除配置文件中//号注释的行  
sed -ri '\\Y^\[ \\t\]\*//Yd' test.txt  当出现需要匹配的对象和/ 冲突的时候 我们可以使用 \\Y..Y 组合代替原来的分割符号

3 删除无内容的空行  
sed -ri '/^\[ \\t\]\*$/d' test.txt

4 删除注释行及空行  
sed -ri '\\Y^\[ \\t\]\*//Yd;/^\[ \\t\]\*#/d;/^\[ \\t\]\*$/d' test.txt   使用 ; 分开三段写  
sed -ri '\\Y^\[ \\t\]\*(//|#|$)Yd' test.txt            (#|//|$)代表三者中的一个

5 修改相关配置文件  
sed -ri '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config  
sed -r '\\Y^\[ \\t\]\*(#|$)Yd;$achroot\_local\_user=YES' /etc/vsftpd/vsftpd.conf  
sed -ri '/UseDNS/cUseDNS no' /etc/ssh/sshd\_config

6 将配置文件里面已多个#开头的行换做为#开始的行  
sed -r 's/^#+/#/' test.txt

  
案例: 删除带//的行 删除空行 将多个#开头的行换成#开头的行  
$ cat test.txt

YANG DUPPDCNDLKSNC  
#JDKJDSNCKDSNCKDS  
//dfdsfkdsjfjd  
   //dsnkdsnmvdsnrv  
 //dnfdksnfkd  
 #NVKNFDKVMFDLMVFD  
   #CDSLFDSJVKJFS

    
   

##DKVKFDNVKMV  
 #fdldgklfd  
   ########vcfdnvkjfdl  
eof

$ sed -r '\\Y^\[ \\t\]\*($|//)Yd;s/^\[ \\t\]\*#+/#/' test.txt  
YANG DUPPDCNDLKSNC  
#JDKJDSNCKDSNCKDS  
#NVKNFDKVMFDLMVFD  
#CDSLFDSJVKJFS  
#DKVKFDNVKMV  
#fdldgklfd  
#vcfdnvkjfdl  
eof

7 sed中使用外部变量  
\# var1=1111  
sed -r "3a$var1" test.txt 需要使用""  
添加在最后面一行需要使用如下方法

sed -r '$a'"$var1" test.txt 或者  
sed -r "\\$a$var1" test.txt  或者

《替换字符的特殊字符》  
  
& 代表前面模式中匹配到的字符  
\\n n为一位1-9的数字，被替换为第ｎ个模式中由\\(\\)匹配的字符串  
\\l　下一个字符转换为小写  
\\L 下一个字符转换为小写，直到出现\\U 或者\\E为止  
\\u 下一个字符转换为大写  
\\U 下一个字符转换为大写，直到出现\\L或者\\E为止  
\\E 停止\\L 或者\\U 转换  
\# grep DNS passwd  
avahi:x:111:120:Avahi mDNS daemon,,,:/var/run/avahi-daemon:/bin/false

\# sed -n 's/DNS/\\L&/p' passwd------------------->>将前面查找到的字符串　替换为小写字符串  
avahi:x:111:120:Avahi mdns daemon,,,:/var/run/avahi-daemon:/bin/false

  
命令：  
   g  代表替换所有  
   p  打印成功替换的行  
   w  把正确替换的写入一个文件    
《保存和读取》  
h 把模式空间的内容复制到缓存区中  
H 把模式空间里面的内容追加复制到缓冲区  
g 取出缓冲区的内容将其复制到模式空间，覆盖模式空间原有内容  
G 取出缓冲区的内容将其复制到模式空间，追加在原有内容以后  
x 交换暂存在缓冲区和模式空间的内容  
《输入输出》  
p　打印行  
r　从文件中读取输入行　例如　sed '/kevien/r /etc/hosts' file  
w 讲行写入文件　sed '/kevien/w /tmp/kevien' file  
《简单控制流》  
i 命令取反　例如　sed '/kevien/!d' file  
  
{} 组合多个命令    
 1 组合命令作为一个整体被执行  
 2 函数命令之间使用；分割　sed -e '/kevien/{H;d}' -e '$G' file  
 3 组合命令可以嵌套 sed '/kevien/{s/1/2/;/3/d}' file  
n 读取下一输入行，从下一条命令而非第一条命令开始操作　例如　sed '/kevien/{n;d}' file 删除字符串kevien行的下一行  
《其他操作》  
\= 向标准输出原始行号  
q 结束或者推出sed脚本  
l　输出非打印的字符串  
《常见命令使用sed如何表达》  
cat file.1　等同　sed ':' file.1　或者　sed -n 'p' file.1  
tac file.1 等同　sed '1!G;h;$!d' file.1　  
grep 1 file.1 等同　sed -n '/1/p' file.1　或者　sed '/1/!d' file.1  
grep -v 1 file 等同　sed '/1/d' file1  
head -5 file.1 等同　sed -n '1,5p' file.1　或者　sed '5q' file.1  
tail file.1 等同　sed  -e ':a' /etc/passwd -e '$q;N;11,$D;ba' /etc/passwd

sed 常用举例子  
sed -n '1p' data5/file.out  
sed -n '1,2p' data5/file.out  
sed -n "1,$NUM p" data5/file.out #有变量的情况下，需要使用 "" ,并且变量和函数之间有空格分开。  
sed -n "$NUM,4s/2/b/p" data5/file.out  
sed -n "$NUM,4s/2/b/gp" data5/file.out  
sed -ne '1,3d' -e '4,5p' data5/file.out   
sed -i '1,2s/1/a/' file.out  
sed -i '1,2s/1/a/g' file.out   
sed -n /11/s/10/A/p file.out------------>> 定位所有包含11的行　并对这些行内的10替换成为A g表示替换全部  
sed -n '/127/,/fix/p' hosts------------->> 定位包含127的行　到fix 之间的所有行，并对其执行操作  
sed -n '/^20/,/^32/p' file.out---------->> 定位以20开头的行到以30开头的行，并对其执行后面命令  
sed -n '1,/^4/p' file.out--------------->> 定位第一行到以４开头的行，并对其执行操作  
sed -n '/^1/,2p' hosts------------------>> 找到以１开头的行，并对其执行到第二行的内容  
sed -n '/^1/,+2p' file.out ------------->> 找到以１开头的行，和它后面的两行，并对其进行操作  
sed -n '/ytchen5/,+5p' passwd----------->> 找打ytchen5的行，和它后面的５行内容，并对其操作  
sed -n '1,~10p' file.out---------------->> 对第一行和其后面的10行进行操作  
sed -n '1~5p' file.out------------------>> 每隔５行执行一次后面的函数比如　打印  
sed -n '/127\\|ip6/p' hosts-------------->> 匹配包含127或者ip6的行   
sed -n '$s/100/---/p' file.out---------->> $代表对最后一行操作  
sed -n '/\[^A-JL-Za-jm-z\]evin/p' passwd-->> 匹配kvien  
sed -i 's/\\(192\\.168\\)\\.0\\.254/\\1\\.1\\.254/g' hosts ----->> 将192.168.0.254 修改为 192.168.1.254  
sed -n 's/ytchen5/&chen/p' passwd--------->> &代表前面查找到的ytchen5  
sed -i '2a2222222222222' hosts---------->> 定位第一行到第二行使用　a命令　添加字符串2222222222222  
sed -i '1,2a2222222222222' hosts-------->> 在匹配到的每一行后面加入这一行内容  
sed -n '1,2aabc\\nabc\\nabc\\n' hosts------>> 添加多行　灵活　使用\\n换行添加多行  
sed -n '/ytchen5/cchenyantao' passwd---->> 找到包含ytchen5的行将其替换为chenyantao c　命令　替换匹配到的行  
sed -i '/192.168.1.254/i192.168.0.254' hosts--->> 在匹配到的当前行上面添加内容　与a 正好相反  
sed -i '/127/!d' hosts------------------>> 查找包换127字段的行，并删除其他的行  
sed -n 's/\\/etc/\\/mnt&/p' passwd.out --> 将/etc/ 替换为/mount/etc/ 输出  
sed -n 's/^/\\/mnt/p' passwd.out--------> 直接讲开头替换为/mnt　此方法更简单  
sed -i '/^guest/s/$/\\/bin\\/false/g' passwd-->找到以guest开头的行，并在其结尾加上/bin/false  
sed -i '/^$\\|^#/d' smi.conf----------->> 找到一个文件内部的全部注释行和空行，对其进行删除  
sed -i '/0.0.0.0/r /etc/rc.local' hosts-->>在hosts 里面找到0.0.0.0 后面，然后将/etc/rc.local的内容读入  0.      　0.0.0　后面  
sed '/root/w ./file.2' passwd------------>> 在passwd 里面找到root　然后将找到的结果插入到当前目录下面的f         ile.2  
sed '/root/!w ./file.2' passwd----------->>命令取反　！将查询到的内容以外的内容插入到file2  
sed   '1{n;s/2/b/}' file.1--------->>找到第一行，然后调到下一行，执行替换操作  
sed   'n;s/.\*/b/' file.1------->>隔一行做一次替换  
sed -n 'l' file.1------->>打印非可见字符，比如换行符号  
sed -n '=' /etc/hosts--->>打印行号　"="