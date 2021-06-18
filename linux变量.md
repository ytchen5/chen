# linux变量

##### 一、变量的类型

#####   1、自定义变量

```text-x-sh
 定义变量：变量名= 变量值 变量名必须以字母或者下划线开头，区分大小写
 引用变量：$变量名 或 ${变量名}
 查看变量：echo $变量名，set（所有变量：包括自定义变量和环境变量）
 取消变量：unset 变量名
 作用范围：仅在当前shell中生效
```

######   2、环境变量

```text-plain
 定义环境变量：方法1 export back_dir2=/home/backup 
                          方法2 export backup_dir1 将已经定义好的变量转换成环境变量
 引用环境变量：$变量名 或着 ${变量名}
 查看环境变量：echo $变量名 使用env查看所有环境变量 例如 env | grep USERNAME
 变量作用范围：当前shell和子shell有效
```

######   3、位置变量

```text-plain
 $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10}
```

######   4、预定义变量

```text-plain
 $0 脚本名
 $* 所有参数
 $@ 所有参数
 $# 参数的个数
 $$ 当前进程的PID
 $! 上一个后台进程的PID
 $? 上一个命令的返回值 0表示成功
```

#####   二、变量的赋值：

1、显示赋值

```text-plain
变量名=变量值
例如：
ip1=192.168.1.100
school="BeJing"
today=`date +%F`
today2=$(date +%F)
```

2、read从键盘读入值

```text-plain
read 变量名
read -p “提示信息: ” 变量名
read -t 5 -p “提示信息: ” 变量名  #-t 超时时间，单位为秒
read -n 2 变量名                 #-n 代表位数 多余的位数不会被赋值
read ip1 ip2 ip3 ip4            #read 后面可以加多个变量来接收变量的值
举例子
root@cyt:~# read ip1 ip2 ip3 ip4
1.1.1.1 2.2.2.2 3.3.3.3 4.4.4.4
root@cyt:~# echo $ip1
1.1.1.1
root@cyt:~# echo $ip2
2.2.2.2
root@cyt:~# echo $ip3
3.3.3.3
root@cyt:~# echo $ip4
4.4.4.4
```

##### 三、扩展知识

###### 1、了解$*和$@的区别

在shell中,$@和$*都表示命令行所有参数(不包含$0),但是$*将命令行的所有参数看成一个整体，而$@则区分各个参数

```text-x-sh
eg:
for i in "$@"
do
  echo $i   #会经历$#次循环
done

for i in "$*"
do
  echo $i  #只会进行一次循环,如果$*没有加双引号则会进行$#次循环
done

二、在命令行中输入 sh tt6.sh 1 2 3 4 5 6 
这时候的运行结果是
1
2
3
4
5
6
7
1 2 3 4 5 6 7
————————————————
```

![img](http://127.0.0.1:37840/api/images/NJxxFO8BHk2T/image.png)




######  

######   

######  

######  

######  

###### ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

##### 4、脚本举例

```text-x-sh
 1 for i in {100..200};do echo 192.168.0.$i>>ip.txt;done 创建一个包含100个ip地址的ip文件
 2 编写脚本如下
#!/bin/bash
if [  $# -eq 0 ]
then
        echo -e "\033[31musage: $(basename $0) file!\033[0m"
        exit
fi
if [ ! -f $1 ]
then
        echo -e "\033[31merr file!\033[0m"
        exit
fi
for ip in $(cat $1)
do
        ping -c1 $ip &>/dev/null && echo -e "\033[32m$ip up\033[0m" || echo -e "\033[31m$ip down\033[0m"
done
5、变量的运算
1 整数运算
方法一 ：expr 
 expr 2 + 3
 expr $num1 + $num2  中间必须有空格
方法二：$(())
 echo $((2+3))
 echo $(($num1+$num2))或者 echo $((num1+num2))
 echo $(((6-3)*2))
 num3=$((1+3));echo $num3方法三：$[]
 echo $[(1+4)*4]
 num3=$[1+3];echo $num3
方法四：let
 let sum4=1+2
 let sum5=1+4;echo $sum5
 let sum5=(1+4)*2 ;echo $sum5
 
2 小数运算 

方法一：bc
 echo "scale=2;6/4" | bc

方法二：awk
 awk 'BEGIN {print 5/8}'
 
方法三：python

6、变量内容的删除

左 --> 右
$ url=www.sine.com.cn
$ echo ${url#*.}                      # 从左到右面 最短匹配 删除使用#*. 删掉最短匹配到.之前的内容
sine.com.cn
$ echo ${url##*.}                     # 从左到右面 最长匹配
cn

右 --> 左：
$ echo ${url%.*}                      # 从右到左面 最短匹配
www.sine.com
$ echo ${url%%.*}                     # 从右到左面 最长匹配
www

变量内容的长度
$ echo ${#url}
15

变量内容的切片
$ echo ${url}
www.sine.com.cn_www.baidu.com.cn
$ echo ${url:0:5}
www.s
$ echo ${url:5}
ine.com.cn_www.baidu.com.cn
```

变量内容的替换==
$ url=www.sine.com.cn_www.baidu.com.cn

$ echo ${url/www/123}                 # 将www替换为123 从左到右最短匹配 替换了第一次匹配到的
123.sine.com.cn_www.baidu.com.cn

$ echo ${url//www/123} # 将www替换为123，从左到右面最长匹配 替换了所有
123.sine.com.cn_123.baidu.com.cn

 


==变量”替代“===
\------------------------------------------------------------------------
一 - 
chenyantao@cyt:~/shell/ping$ vir1=
chenyantao@cyt:~/shell/ping$ vir2=vir2
chenyantao@cyt:~/shell/ping$ 
chenyantao@cyt:~/shell/ping$ 
chenyantao@cyt:~/shell/ping$ echo ${vir1-aaa}

chenyantao@cyt:~/shell/ping$ echo ${vir2-aaa}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3-aaa}
aaa
chenyantao@cyt:~/shell/ping$ echo ${vir1}

chenyantao@cyt:~/shell/ping$ echo ${vir2}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3}

chenyantao@cyt:~/shell/ping$

${变量名-新的变量值}
变量没有定义--返回值：新变量值，是否赋值：否
变量有被赋值--返回值：旧变量值，是否赋值：否
变量值为空的--返回值：空值，是否赋值：否

chenyantao@cyt:~$ echo ${ip3-aaaa}
aaaa
chenyantao@cyt:~$ echo ${ip3}
\---------------------------------------------------------------------
二 :-

chenyantao@cyt:~$ ip1=
chenyantao@cyt:~$ ip2=ip2
chenyantao@cyt:~$ echo ${ip1:-ip1}
ip1
chenyantao@cyt:~$ echo ${ip2:-ip22}
ip2
chenyantao@cyt:~$ echo ${ip3:-ip3}
ip3
chenyantao@cyt:~$ echo ${ip1}

chenyantao@cyt:~$ echo ${ip2}
ip2
chenyantao@cyt:~$ echo ${ip3}

chenyantao@cyt:~$
${变量名:-新的变量值} 
变量没有定义--返回值：新变量值，是否赋值：否
变量有被赋值--返回值：旧变量值，是否赋值：否
变量值为空的--返回值：新变量值，是否赋值：否 


\----------------------------------------------------------------------- 
三 +
chenyantao@cyt:~$ ip1=
chenyantao@cyt:~$ ip2=ip2
chenyantao@cyt:~$ echo ${ip1+aaa}
aaa
chenyantao@cyt:~$ echo ${ip2+bbb}
bbb
chenyantao@cyt:~$ echo ${ip3+ccc}

chenyantao@cyt:~$ echo ${ip1}

chenyantao@cyt:~$ echo ${ip2}
ip2
chenyantao@cyt:~$ echo ${ip3}

chenyantao@cyt:~$ 
${变量名+新的变量值}
变量没有定义--返回值：空值，   是否赋值：否
变量有被赋值--返回值：新变量值，是否赋值：否
变量值为空的--返回值：新变量值，是否赋值：否 

\----------------------------------------------------------------------
四 :+
chenyantao@cyt:~/shell/ping$ vir1=
chenyantao@cyt:~/shell/ping$ vir2=vir2
chenyantao@cyt:~/shell/ping$ 
chenyantao@cyt:~/shell/ping$ 
chenyantao@cyt:~/shell/ping$ echo ${vir1:+aaa}

chenyantao@cyt:~/shell/ping$ echo ${vir2:+aaa}
aaa
chenyantao@cyt:~/shell/ping$ echo ${vir3:+aaa}

chenyantao@cyt:~/shell/ping$ echo ${vir1}

chenyantao@cyt:~/shell/ping$ echo ${vir2}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3}

chenyantao@cyt:~/shell/ping$


${变量名:+新的变量值}
变量没有定义--返回值：空值，   是否赋值：否
变量有被赋值--返回值：新变量值，是否赋值：否
变量值为空的--返回值：空值，   是否赋值：否
\---------------------------------------------------------------------
五 =
chenyantao@cyt:~/shell/ping$ vir1=
chenyantao@cyt:~/shell/ping$ vir2=vir2

chenyantao@cyt:~/shell/ping$ echo ${vir1=aaa}

chenyantao@cyt:~/shell/ping$ echo ${vir2=aaa}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3=aaa}
aaa
chenyantao@cyt:~/shell/ping$ echo ${vir1}



 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

chenyantao@cyt:~/shell/ping$ echo ${vir2}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3}
aaa
chenyantao@cyt:~/shell/ping$ 

${变量名=新的变量值}
变量没有定义--返回值：新变量值，是否赋值：是
变量有被赋值--返回值：原变量值，是否赋值：否
变量值为空的--返回值：空值，    是否赋值：否
\-----------------------------------------------------------------------------
六 :=
chenyantao@cyt:~/shell/ping$ vir1=
chenyantao@cyt:~/shell/ping$ vir2=vir2


chenyantao@cyt:~/shell/ping$ echo ${vir1:=aaa}
aaa
chenyantao@cyt:~/shell/ping$ echo ${vir2:=aaa}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3:=aaa}
aaa


chenyantao@cyt:~/shell/ping$ echo ${vir1}
aaa
chenyantao@cyt:~/shell/ping$ echo ${vir2}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3}
aaa
chenyantao@cyt:~/shell/ping$ 
${变量名:=新的变量值}
变量没有定义--返回值：新变量值，是否赋值：是
变量有被赋值--返回值：原变量值，是否赋值：否
变量值为空的--返回值：新变量值，是否赋值：是 
\-------------------------------------------------------------------------------
七 ?


















${变量名?新的变量值}
变量没有定义--返回值：bash: vir3: ccc，是否赋值：否
变量有被赋值--返回值：原变量值，     是否赋值：否
变量值为空的--返回值：空值，         是否赋值：否
\-----------------------------------------------------------------------
八 :?
chenyantao@cyt:~/shell/ping$ vir1=
chenyantao@cyt:~/shell/ping$ vir2=vir2

chenyantao@cyt:~/shell/ping$ echo ${vir1:?aaa}
bash: vir1: aaa
chenyantao@cyt:~/shell/ping$ echo ${vir2:?aaa}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3:?aaa}
bash: vir3: aaa
chenyantao@cyt:~/shell/ping$ echo ${vir1}

chenyantao@cyt:~/shell/ping$ echo ${vir2}
vir2
chenyantao@cyt:~/shell/ping$ echo ${vir3}
${变量名:?新的变量值}
变量没有定义--返回值：bash: vir3: aaa，是否赋值：否
变量有被赋值--返回值：原变量值，是否赋值：否
变量值为空的--返回值：bash: vir1: aaa，   是否赋值：否
常用案例
${var}
变量本来的值

${var:-word}
如果变量 var 为空或已被删除(unset)，那么返回 word，但不改变 var 的值。

${var:=word}
如果变量 var 为空或已被删除(unset)，那么返回 word，并将 var 的值设置为 word。

${var:?message} 
如果变量 var 为空或已被删除(unset)，那么将消息 message 送到标准错误输出，可以用来检测变量 var 是否可以被正常赋值。
若此替换出现在Shell脚本中，那么脚本将停止运行。

${var:+word} 
如果变量 var 被定义，那么返回 word，但不改变 var 的值。