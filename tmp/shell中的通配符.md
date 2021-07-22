### 常用的快捷键

| 符号       | 含义                       |
| ---------- | -------------------------- |
| ^c         | 终止前台运行的程序         |
| ^z         | 将前台运行的程序放到后台   |
| ^d         | 退出，等价于exit           |
| ^l         | 清屏                       |
| ^a \| home | 光标移动到命令行的前最前端 |
| ^e \| end  | 光标移动到命令行的最后端   |
| ^u         | 删除光标前所有字符         |
| ^k         | 删除光标后所有字符         |
| ^r         | 搜索历史命令               |

### 常用的通配符

| **\***                | **匹配0个或者多个字符任意字符 ls in*、rm-fr *.pdf、find / -iname "\*-eth0"** |
| --------------------- | ------------------------------------------------------------ |
| ?                     | 匹配任意单个字符                                             |
| [list]                | 匹配list中任意单个字符                                       |
| [a-z]                 | 匹配a-z之间的一组字符                                        |
| [!list]               | 匹配除list中的任意单个字符                                   |
| {string1,string2,...} | 匹配string1 string2或更多的字符串                            |
| {1..10}               | 匹配1-10之间的任意数字                                       |

### bash中的引号（重点）

- 双引号""	会把引号内部的内容当成整体看待

- 单引号''      会把引号内部的内容当成整体看待，禁止引用其他变量值shell中的特殊字符都被视为普通字符

- 反撇号``   返撇号和$()一样，引号或者括号里的命令会被优先执行，如果存在嵌套，返撇号不能用

  

```
chenyantao@cyt:~$ echo "${HOSTNAME}"
cyt
chenyantao@cyt:~$ echo '${HOSTNAME}'
${HOSTNAME}

chenyantao@cyt:~$ echo `date +%F`
2021-07-22
chenyantao@cyt:~$ echo 'date +%F'
date +%F
chenyantao@cyt:~$ echo "date +%F"
date +%F

```



## 正则表达式（元字符）





| 元字符 | 解释                                 |
| :----: | :----------------------------------- |
|   ^    | 行首定位符 ^love                     |
|   $    | 行位定位符love$                      |
|   .    | 匹配单个字符                         |
|   *    | 匹配前导符0次或者多次                |
|   .*   | 任意多个字符                         |
|   []   | 匹配指定范围内的一个字符 [Ll]ove     |
|  [-]   | 匹配指定范围内的一个字符 [a-z0-9]ove |
|  [^]   | 匹配在指定组内的字符                 |
|        | 、acc                                |

表示的不是字符本身的含义

```
*	 匹配任意多个字符
ls in\*, rm -fr \*,find /etc/sysconfig/network-scripts/ -iname \*eth0,  
+	匹配它前面字符一次或者多次
    [root@server ~]#  egrep 'f+' 1.sh 一个至多个f
    stuf
    stuff
    stufff

?	 	匹配任意一个字符，只匹配一个

\[\] 	匹配括号里面的任意一个字符，方括号里面的尖括号^ 代表取反，
		例如 \[abc\], \[a-z\]\[0-9\],\[a-zA-Z0-9\], ll l\[io\]ve, ll l\[^a-z\]ve,  ll 		/dev/sd\[a-z\]

()	在子shell中执行（cd /boot; ls）(umask 077;touch file1000)

{}	集合 touch file{1..9}

      cp -rv /etc/sysconfig/network-scripts/ifcfg-eth0{,.old}

      cp -rv /etc/sysconfig/network-scripts/{ifcfg-eth0,ifcfg-eth0.old}

\\	转义字符，让元字符回归本意echo \*, echo \\\*,

 touch cjdscjkdsn\\  
\> jdfkdjf

mkdir \\\\

echo -e atb

echo -e a\\tb

echo -e a\\\\tb
```



***扩展元字符***

