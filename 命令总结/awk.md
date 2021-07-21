# awk
###### 文本处理 awk  
一 awk简介:  
awk是一种编程语言,用于在linux或者unix系统下对文本或者数据进行处理, 数据可以来自标准输入,一个或者多个  
文件,或者其他命令输出,他支持用户自定义函数和动态正则表达式功能,是linux和unix下强大的编程工具,可以在命  
令中使用但是更多的是作为脚本来使用  
awk处理文本和数据的方式是这样的,它逐行扫描文件,送第一行到最后一行,寻找匹配特定模式的行,并在这些行上面  
进行你想要的操作,如果没有指定处理动作,则把匹配的行显示在标准输出(屏幕),如果没有指定模式,则操作所有行,  
awk分别代表作者姓氏的地一个字母,gawk是awk的GNU版本,他提供了Bell实验室和GNU的一些扩展

二 awk的两种形式的语法格式  
awk \[options\] 'commands' filenames  
awk \[options\] -f 'awk-script-file' filenames默认为换行符号回车

\==options  
\-F 定义输入字段分割符号,默认的分割符是空格或者制表符(tab)  
\==commands  
 BEGIN{} 行处理前  
 {}  行处理中  
 END{} 行处理后  
awk 'BEGIN{FS=":";OFS=":"} {print $1,$2} END{print "------------"}' /etc/passwd

\==awk命令格式  
1 awk '/pattern/' filename   
示例: awk '/^root/' /etc/passwd

2 awk '{action}' fiename   
示例: awk -F: '{print $1}' /etc/passwd

3 awk '/pattern/ {action}' filename   
示例: awk '/^r..t/ {print $1}' /etc/passwd  
  awk 'BEGIN{FS=":"}/^root/ {print $1,$2}' /etc/passwd  
4 command | awk '/pattern/ {action}'   
示例: cat /etc/passwd | awk '/^root/ {print $1}'

\===记录与字段相关的内部变量  
$0 保存当前记录的内容,整行内容  

NR　全部记录的行号, 多个输入文件记录的行号相加  
FNR 当前记录的行号，仅为当前文件而非全部输入的文件  
NF    当前记录的字段个数  
FS    输入字段分割符,默认为空格  
OFS 输出字段分割符,默认为空格  
RS   输入记录分割符号(默认为换行符号回车)  
ORS 输出记录分割符号(默认为换行符号回车)

###### CONVFMT 用于数字的字符串转换格式(默认格式　%.6g)  
ENVIRON 环境变量的关联数组

###### OFMT 数字的输出格式(默认为%.6g)

###### ARGC 命令行中的参数个数  
 ARGV 包含命令行参数的数组

###### awk格式话输出

###### print函数

###### date | awk '{print "Month: "$2 "\\nYear: "$NF}'

![](awk/4_image.png)

###### awk -F: '{print "username:"$1"\\tuid is:"$3}' /etc/passwd

awk -F: '{print "\\tusername and uid:" $1,$3 "!"}' /etc/passwd

###### printf函数

###### %s 字符类型

###### %d 数值类型

###### %f   浮点类型

###### \-15s 代表 占用15个字符, -代表左对齐, 默认是右面对齐,printf默认不会在尾部加\\n

awk -F: '{printf "%-15s %-10s %-15s\\n",$1,$2,$3}' passwd

![](awk/image.png)

######  awk -F: '{printf "|%-15s|%-10s|%-15s|\\n",$1,$2,$3}' passwd

![](awk/1_image.png)

awk的模式和动作

  任何awk语句都是由模式和动作组成,模式部分决定动作语句何时触发及触发语句,处理即对数据进行的操作,如果省略模式部分,动作将时刻保持执行状态.模式可以是任何条件语句或复合语句或者正则表达式,模式包括两个特殊字段BEGIN和END.使用BEGIN语句设置计数和打印头,BEGIN语句可以使用在任何文本动作之前,之后文本浏览动作依据输入文本开始执行,END语句用来在awk完成文本浏览之后打印输出文本总数和结尾状态.

### awk模式:

#### \====正则表达式

######  1 匹配记录整行内容

###### awk '/alice/{print $0}' /etc/passwd

###### awk '$0 ~ /alice/' /etc/passwd 

###### awk '!/alice/' /etc/passwd

###### awk '$0 !~ /alice/' /etc/passwd

######   2 匹配字段 匹配操作符(~ !~)

###### $ awk -F":" '$1 ~ /alice/ {print $0}' /etc/passwd

###### $ awk -F":"  '$NF ~ /\\/bin\\/bash/' /etc/passwd

$ awk -F":"  '$NF !~ /bash$/' /etc/passwd

#### \====比较表达式

###### 比较表达式采用对文本进行比较,只有当条件为真,才执行指定的动作,比较表达式使用关系运算符号,用于比较数字与字符串

关系运算符号

| 运算符号 | 含义 | 示例 |
| --- | --- | --- |
| < | 大于 | x<y |
| <= | 小于等于 | x<=y |
| \== | 等于 | x==y |
| != | 不等于 | x!=y |
| \>= | 大于等于 | x>=y |
| \> | 大于 | x>y |

举例子:

###### awk -F: '$3 > 0 {print $0}' passwd

###### awk '$3 == 0 {print $0}' passwd

###### awk -F: '$NF == "/bin/bash" {print $0}' /etc/passwd

![](awk/3_image.png)

#### \===条件表达式

$ awk '$3 >300 {print $0}' /etc/passwd  # 判断UID大于300的用户有那些

$ awk '{if($3 >300){print $0}}' /etc/passwd    #if(条件表达式){执行的指令}

$ awk -F: '{if($3 < 100){print $0}else{print $2}}' /etc/passwd

#### \===算数运算: + - \* / % ^

可以在模式中执行计算,awk都按浮点数方式执行算数运算

$ awk -F":" '$3 \* 10 >300{print $0}' passwd 

$ awk -F":" '{if ($3 \*10 <300){print $0}}' /etc/passwd

#### \===逻辑操作符和符合模式

###### && 逻辑与 a&&b

###### ||    逻辑或  a||b

###### !     逻辑非  !a

###### $ awk -F":" '$1 ~/r..t/&&$3 <15{print $0}' passwd   #  ‘条件1 && 条件2’

###### $ awk -F":" '$1 ~/r..t/||$3 <15{print $0}' passwd   # ‘条件1 || 条件2’

###### $ awk -F":" '!($1 ~/r..t/||$3 <15){print $0}' /etc/passwd   #   !(条件)

#### \===模式范围

$ awk -F":" '/^w+/,/al\[a-z\]ce/{print $0}' /etc/passwd   # '/范围1/,/范围2/'

$ awk -F":" '/r..t/,/m\[a-z\]\*/{print $0}' passwd  

\===支持三目运算:

$  awk -F":" '{print($7>19?"hight: "$7 : "low: "$7)}' passwd    # a?b:c

$  awk -F":" '$1=="sys" {$1="system";print $1}' passwd  # 匹配到了可以赋值

$ awk -F":" '/n.w/{$3+=$3+100;print $0}' passwd    # $3+=$3+100

\[awk脚本编程\]
-----------

#### \==条件判断

###### if语句

###### 格式: {if(){语句1;语句2;….}}

###### ‘{if(){}}’ 语句

###### $ awk -F":" '{if($3==0){print $1,"is administrator"}}' /etc/passwd

###### $ awk -F":" '{if($3>0&&$3<1000){count++}}END{print "系统用户: "count"个"}' /etc/passwd    //统计系统用户个数

###### ‘{if(){}else{}}’ 语句

###### $ awk -F":" '{if($3==0||$3<1000){count++}else{i++}}END{print "系统用户: "count"个\\n""普通用户: "i}' /etc/passwd  
系统用户: 47个  
普通用户: 7  


###### ‘{if(){}else if(){}else{}}’

###### $ awk -F":" '{if($3==0){count++}else if($3<100){i++}else{j++}}END{print "root用户: "count"\\n""系统用户: "i;print "普通用户: "j}' /etc/passwd

###### root用户: 1  
系统用户: 16  
普通用户: 37

\===循环语句

#### **while循环语句**

**‘{i=1;while(){循环体;i++}}’**

**$ awk 'BEGIN{i=1;while(i<=10){print i;i++}}'**

###### **$ awk -F":" '/^root/{i=1;while(i<=NF){print $i;i++}}' /etc/passwd** 

###### **root**  
**x**  
**0**  
**0**  
**root**  
**/root**  
**/bin/bash**

###### **for循环语句**

###### **‘{for(i=1;i<=NF;i++){循环体}}’                                                  //C风格的for循环**

**‘{for(i in 数组){print 数组\[i\];i++}}’                                                      //数组的遍历**

###### **$ awk -F":" '/^root/{for(i=1;i<=NF;i++){print $i}}' passwd**

###### **root**  
**x**  
**0**  
**0**  
**root**  
**/root**  
**18**

###   
\[awk数组\]

    awk -F":" '{uasername[++i]=$1}END{for(j=1;j<=i;j++){print uasername[j]}}' /etc/passwd
    
    awk -F":" '{uasername[++i]=$1}END{for(j in uasername){print j"\t"uasername[j]}}' /etc/passwd

**练习题**

**1 统计/etc/passwd中各种shell的数量** 

    awk -F":" '{type[$NF]++}END{for(i in type){print i":"type[i]}}' /etc/passwd 
    /bin/sh:2
    /bin/false:6
    /bin/bash:4
    /bin/sync:1
    /usr/sbin/nologin:41

###### **2 网站访问状态统计当前实时状态**

    $ netstat -ant | awk -F"[ \t]+" '/^tcp/{TYPE[$6]++}END{for(i in TYPE){print i":"TYPE[i]}}'
    FIN_WAIT1:1
    LISTEN:13
    ESTABLISHED:7

#### \[awk使用外部变量\] 

##### 1 在双引号情况下使用的方法

######  awk 使用 外面使用" " 然后里面 配合 \\"变量名\\" 方式 可以引用外面的变量 

######  sub是一个awk内置函数 用于替换字符串 语法: sub(/原字符串/,替换的字符串)

    $ vir=bash
    $ echo "unix scripts" | awk "sub(/unix/,\"$vir\")"
    bash scripts

![](awk/5_image.png)

##### 2 在单引号的情况下使用方法

 // awk 使用外面使用单引号 然后里面 配合 "'"$变量名"'" 方式 可以引用外面的变量 就是一对爽引号套一个单引号

    echo "unix scripts" | awk 'sub(/unix/,"'"$vir"'")'

![](awk/6_image.png)

    $ i=5
    $ df -TH | awk -F"[ \t]+" '{if(int($6)<'''$i'''){print $7"  "$6}}'     
    //int()函数用来将6% 这样的数字转换成6整数, 这种情况可以使用''' ''' 三对单引号使用外部变量

##### 3  awk 自带参数 

\-v 变量名=变量值

     $ awk  -F":" -v USER="root" '{if($1==USER){print $0}}' /etc/passwd

4 作业:

1 取得网卡ip除去ipv6以外的所有ip

    $  ifconfig | awk -F"[ \t]+" '{if($2=="inet"){print $3}}' 

2 获得当前系统内存使用情况

    $ free -k | awk -F"[ \t]+" '$1 == "Mem:" {print "MemToral: "$2" kB""\nMemUsed: "$3" kB""\nMemAvailable: "$6+$4 " kB"}'
    
    MemToral: 16115180 kB
    MemUsed: 2698840 kB
    MemAvailable: 13416340 kB

3 获得硬盘使用情况

4 清空本机arp缓存

    方法1 arp -n | awk -F"[ \t]+" '/^[0-9]/{print "arp -d "$1}' |bash
    方法2 arp -n | awk -F"[ \t]+" '/^[0-9]/{print $1}' | xargs -I {} arp -d {}

5 打印出/etc/hosts文件的最后一个字段(按照空格分开)

6 打印执行目录下面的目录名字

  


######   


######   



《字段分割》  
awk 用$1 $2 $3等的顺序形式表示files中每行以间隔符号分割的各列不同字段  
awk　默认以空格符号为间隔符号将每行分割为单独得字段，也可以使用ａｗｋ内置变量定义间隔符号  
awk 'BEGIN { FS="\[:\\t \]" };{ print $5 }' file.2  # 使用　FS="\[:\\t \]"　表达式指定多个字符分割符号   
awk 使用option中得-F 参数定义默认间隔符号  
NF 变量表示当前记录得字段数  
《定址》  
关键字  
 BEGIN: 表示在程序开始之前执行  
 END: 表示所有文件处理完后执行  

正则表达式  
 参见　正则表达式部分　需要使用　/正则表达式/　格式  
 . 匹配除去新行之外的任意单个字符，在awk中可以匹配空行  
 × 匹配任何个或者０个它之前的字符，之前的字符可以是一个正则表达式，因为 . 可以表示任意单个字符，那么　.\* 代表任意字符　任意个数了  
 ^ 在一行或者一个字符串开始匹配之后的字符串　表示在行首  
 $ 匹配行尾  
 \\ 转义字符  
 \[\] 匹配任何一个用括号扩着的字符　连接使用　- 表示连续的一个字符范围，^代表匹配到的额外的字符串，  
 {m,n} 匹配之前字符串出现的范围， 之前的字符串也可以是元字符，{m} 匹配正好出现m次，｛m,｝表示至少出现m次，｛m,n｝表示至少出现m次，最多出现n次，m　n　取值范围必须是大于0小于255的数  
 \\(\\) 把在\\(和\\)　之间的变量存放在一个特殊的存储空间，在后面可以使用\\1到\\9引用，最多引用９次  
 \\n  引用由\\(变量\\)　的变量  
 \\< \\> 匹配以\\<变量 开始　或者 变量\\>　结尾的字符串  
 + 匹配一个或者多个前面正则表达式的实例  
 ? 匹配0个或者一个前面的正则表达式  
  | 匹配在之前或者在之后指定的正则表达式  
  () 一个括起来的一组正则表达式  
 POSIX字符集  
  \[:alnum:\] 文字数字字符  
  \[:alpha:\] 字符字符  
  \[:blank:\] 空格或者TAB  
  \[:cntrl:\] 控制字符  
  \[:digit:\] 十进制数字  
  \[:graph:\] 非空格字符  
  \[:lower:\] 小写字符  
  \[:print:\] 可打印的字符  
  \[:space:\] 空格字符  
  \[:upper:\] 大写字符  
  \[:xdigit:\] 十六进制数字  
 《变量》  
 awk的系统变量  

 例如　bash$ awk 'BEGIN { print "ARGC="ARGC; for ( i in ARGV ) { print i"="ARGV\[i\] } }' file.2 file.5   
   ARGC=3  
   0=awk  
   1=file.2  
   2=file.5  

操作符  
 = += -= /= ^= \*\*=  赋值操作符号  
 ? : Ｃ语言条件表达式  
 || 逻辑或  
 && 逻辑与  
 ~  !~  匹配正则表达式，不匹配正则表达式  
 < <= > >= != == 关系操作符号  
 $ 字段引用  
 x==y x等于ｙ?  
 x!=y x不等于ｙ?  
 x>y x大于y ?  
 x<y  
 x~\[0-9\]\[3,\] x是否为３位以上的数字？  

运算符号  
 + - 加减法  
 \* / % 乘除取模  
  ^ \*\* 求幂  
  ++ - 递增或者递减，作为前缀或者后缀  

转义字符  
 \\a 报警字符通常是ASCII BEL字符  
 \\b 退格符号  
 \\f 走纸符号  
 \\n 换行符号  
 \\r 回车符号  
 \\t 水平制表符号　ｔａｂ  
 \\v 垂直制表符号  
 \\ddd 讲字符表示为1-3位八进制  
 \\xbex 讲字符表示为十六进制  
 \\c 任何需要字面表示的字符ｃ(例如　\\"if")  
条件语句  
 if ( 测试条件 )  
  执行语句1  
 else  
  执行语句2  
 实例：   
  awk 'BEGIN { if (1) print "ok"; else print "fail" }'  
  awk 'BEGIN { if (0) print "ok"; else print "fail" }'  
-------------------
 if ( 测试条件 ){  
  执行语句1  
  执行语句2  
  }              #  语句多的情况下使用｛｝将其括起来  
 实例  
  awk 'BEGIN { if (0) { print "ok";print "begin" } else { print "fail";print "end" } }'  
  awk 'BEGIN { if (1) { print "ok";print "begin" } else { print "fail";print "end" } }'  
  需求：找到/etc/passwd 里面uid小于100的，并且shell类型是/bin/bash的  
  awk -F":" '/bin\\/bash$/ { if ( $3 < 100 ) print $1,$NF }' /etc/passwd  
  或者  
  awk -F":" ' { if ( $3 < 100 && $NF ~ /\\/bin\\/bash/ ) print $1,$NF }' /etc/passwd  
    
------------------
 if ( 测试条件１ ) # 多分支语句  
  语句1  
 elif ( 测试条件２ )  
  语句２  
 elif ( 测试条件３ )  
  语句３  
 else  
  语句４  
------------------
 expr ? action1:action2  
  例如：grade = ( $2 >=50 )? "Pass" : "Fail"  
循环语句  
 while ( condition ){  
  action  
 }  
--------------------
 do {  
  action  
 } while ( condition )  
-----------------------------------------------------
 for ( set\_counter; test\_counter; increment\_counter){  
  action  
 }  
 例如：  
  for ( i=NF;i>=1;i-- ){  
   print $i  
  }  
  实例  
   awk 'BEGIN { FS=":"}; { for ( i=NF;i>=1;i-- ) printf $i" ";print"\\n" }' /etc/passwd  
   将/etc/passwd　文件连的记录位置调过来显示  
-----------------------------------------------------
跳转语句  
 break  终止或者跳出整个循环  
  例如: 当条件满足的情况下使用break 跳出循环，这样就不在执行后续的循环动作  
  for ( x=1;x < NF;++x )  
   if ("abc" == $x ) {  
    print x,$x  
    break  
   }  
   print  
 continue 终止当前循环，进入下一个循环  
  例如:  
  for (x=1;x < NF; ++x)  
   if ( x == 3 ){  
    continue  
    print x,$x  
   }  
 next 读入下一个输入行，同时返回到脚本顶部，这样可以避免对当前输入行执行其他操作  
 exit 使主输入循环退出，并将控制移动到END规则，终止脚本执行  
函数  
 close()       # 在大多数的awk的实现中，只能打开一定数量的句柄，如果你的语句中打开的句柄达到了这个基数，你可以使用  
 close(filename-expr)　# close()关闭之前打开的句柄，但是要注意的是close()中的语句必须和原有语句一模一样，包括空格  
 close(command-expr)  
-------------------------------------------------------------------------------------------------------------------
 sin(x)       # 返回x的正弦值和反弦值　x的单位为弧度  
 cos(x)  
-------------------------------------------------------------------------------------------------------------------
 gsub(r,s,t) #全局替换字符串　s中的字符串　t中的的正则表达式　r匹配所有字符串，返回替换次数，如果ｔ没有输出默认为$0  
 index(str,substr) # 返回字符串substr在字符串str中的位置，起始位置为1  
 int(x) 取整函数  
 length(str) 返回str字符串的长度，如果没有参数返回$0的长度  
 rand()  生成0-1之间的随机数，每次执行脚本时这个幻术返回相同的数据，除非使用srand()函数设置发生器种子  
  例如：awk 'BEGIN {print rand();print rand(); srand(); print rand(); print rand() }'  
 srand(expr) 使用expr生成随机发生器种子，默认值为当天时间，返回值为旧的种子数  
 sub(r,s,t) 替换字符串　"s" 中的字符串　t中正则表达式　r匹配所有字符串，如果成功返回1 否则返回为0 为设置字符串t默认$0  
 substr(r,s,t) 字符串截取，返回部分字符串  
   awk 'BEGIN {phone=substr(123456789,5);print phone}'　返回　56789  
   awk 'BEGIN {phone=substr(123456789,3,4);print phone}' 返回　3456  
 toupper(str) 讲字符串转换为大写字母  
  例如：awk -F: '{ print $1,toupper($1) }' /etc/passwd　将小写字符转换为大写  
       　awk -F" " '/\[A-Z\]/ { print $1,tolower($1) }' file.1　讲大写字符转换为小写  
 system(command) 执行系统命令，并返回它的状态



***统计系统中不同用户的个数***

```
对于 CentOS5,6 来说 ，用 awk 统计普通用户的个数：
awk -F: '$3>500{a++}END{print a}' /etc/passwd

对于 CentOS7 来说 ，用 awk 统计普通用户的个数：
awk -F: '$3>1000{a++}END{print a}' /etc/passwd
```

