# xargs
xargs 命令的作用，是将标准输入转为命令行参数

    echo "hello word" | xargs echo

上面的代码将管道左侧标准输入，转换为命令参数，传递给第二个echo命令

xargs命令的语法如下：

    # xargs [options] command
    option[d,t,p]

xargs作用在于大多数命令（比如 rm mkdir ls）与管道一起配合使用，需要xargs将标准输入转为命令行参数

    # echo "one two three" | xargs mkdir 等同与  mkdir {one,two,three}

xargs的单独使用

xargs后面的命令默认就是echo

输入xargs按下回车后，命令行会等待用户输入，作为标准输入，你可以输入任意内容，然后按下ctrl+d表示输入结束，这时echo会把输入的内容打印输出

\-d参数与分隔符

默认情况下，xargs将换行符和空格作为分隔符号，把标准输入的分割成一个个命令行参数

    echo -e "a\nb\nc" | xargs mkdir 等同于 echo -e "d e f" | xargs mkdir

如上两个代码都能实现创建三个目录，

\-d参数可以指定其他分割符号，

    echo -en "a,b,c,d,e,f" | xargs -d "," mkdir      # echo -n 需要加上否则会多创建出来一个？的目录

\-p 打印出要执行的命令，询问用户是否要执行

\-t 只打印出要执行的命令，不询问用户是否要执行，直接运行

    [root@vm1 chen1.1]# ls
    1.txt  a  b  c  d  e  f
    [root@vm1 chen1.1]# echo -en "a,b,c,d,e,f" | xargs -d "," -p rmdir
    rmdir a b c d e f ?...yes
    [root@vm1 chen1.1]# ls
    1.txt
    [root@vm1 chen1.1]# echo -en "a,b,c,d,e,f" | xargs -d "," -t mkdir
    mkdir a b c d e f 
    [root@vm1 chen1.1]# ls
    1.txt  a  b  c  d  e  f
    [root@vm1 chen1.1]# 

\-0参数与find的 -print0 搭配使用 解决文件名带空格的问题

由于xargs默认将空格作为分隔符号，所以不太适合处理文件名，因为文件名可能包含空格

find命令有一个特别的参数-print0 将输出的文件列表以null分割，然后xargs 命令使用-0参数表示用null作为分割符号。

    find ./ -type d -print0 | xargs  -0 rmdir

上面命令列出./路径下面的所有文件，由于分隔符号是null，所以处理包含空格的文件名，也不会报错

还有一个原因，xargs特别适合find命令，有些命令比如rm一旦参数过多会报错 参数列表过长，而无法执行，改用xargs就没有这个问题，因为他对每个参数执行一次命令

7  -L 参数

如果标准输入包含多行，-L 可以指定多行作为一个命令参数

8 -n参数

指定每次将多项或者多个参数作为一个命令参数

9 -I 参数

每一项命令参数的替代字符串

    [root@vm1 chen1]# ls
    chen.txt
    [root@vm1 chen1]# cat chen.txt 
    a
    b
    c
    d
    [root@vm1 chen1]# cat chen.txt | xargs -I ff sh -c "echo ff;mkdir ff"    # -F ff（相当占位码） sh -c "命令1；命令2；命令3"
    a
    b
    c
    d
    [root@vm1 chen1]# ls
    a  b  c  chen.txt  d
    [root@vm1 chen1]# 

10 --max-procs 参数

xargs默认只用一个进程执行命令，如果命令要执行多次，必须等上一次执行完，才能执行下一次，--max-procs 参数指定同时用多个进程执行命令，--max-procs 0 表示不限制进程数

    docker ps -q | xargs -n 1 --max-procs 0 docker kill

上面的命令表示，同时关闭尽可能多的docker容器，这样运行速度会很快。