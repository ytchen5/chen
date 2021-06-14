# 索引inode及block

1 Linux中的文件
1.1 文件属性概述
Linux系统中的文件或目录的属性主要包括：索引节点（inode）、文件类型、权限属性、链接数、所归属的用户和用户组、最近修改时间等内容。

```text-plain
[root@oldboy ~]# ls -lhi
total 36K 
390149 -rw-r--r--. 1 root root 22K Nov 16 11:33 install.log 
390150 -rw-r--r--. 1 root root 5.8K Nov 16 11:30 install.log.syslog
```

2 索引节点inode

理解inode，要从文件储存说起。
文件储存在硬盘上，硬盘的最小存储单位叫做"扇区"（Sector）。每个扇区储存512字节（相当于0.5KB）。

操作系统读取硬盘的时候，不会一个个扇区地读取，这样效率太低，而是一次性连续读取多个扇区，即一次性读取一个"块"（block）。这种由多个扇区组成的"块"，是文件存取的最小单位。"块"的大小，最常见的是4KB，即连续八个 sector组成一个 block。

文件数据都储存在"块"中，那么很显然，我们还必须找到一个地方储存文件的元信息，比如文件的创建者、文件的创建日期、文件的大小等等。这种储存文件元信息的区域就叫做inode，中文译名为"索引节点"。

linux中所有的东西都是文件，不管是目录还是命令，**Inode就是帮助linux系统快速定位到指定文件而创建的额特殊的文件**

操作系统读取磁盘文件的流程是这样的：
根据dictionary的对应关系找到该文件的inode（dictionary简单理解就是一张表，存储文件到inode号的映射）。根据inode，找到inodeTable，根据inodeTable中的对应关系，找到对应的block。
读取文件大致过程如图：
 



## **inode的内容**


inode 中文意思是索引节点（index node）。在每个Linux存储设备或存储设备的分区（存储设备可以是硬盘、软盘、U盘…）被格式化为文件系统，一般生成两部分：第一部分是Inode数据（），第二部分是Block数据。

Block 是用来存储实际数据用的，例如：照片、视频等普通文件数据。

而Inode就是用来存储这些数据属性信息的（也就是ls -l的结果），inode属性信息包括不限于问价大小、属主（用户）、归属的用户组、文件权限、文件类型、修改时间，还包含指向文件实体的指针的功能（inode节点–block的对应关系）等，但是，inode里面唯独不包含文件名，文件名一般在上级目录的block里。

Inode除了记录文件属性的信息外，还会为每个文件进行信息索引，所以就有了inode的数值。操作系统根据指令，即可通过inode的值最快的找到相对应的文件实体。文件，inode,block 之间的关系见下图:

## **inode的内容**

inode包含文件的元信息，具体来说有以下内容：

- 文件的字节数
- 文件拥有者的User ID
- 文件的Group ID
- 文件的读、写、执行权限
- 文件的时间戳，共有三个：ctime指inode上一次变动的时间，mtime指文件内容上一次变动的时间，atime指文件上一次打开的时间。
- 链接数，即有多少文件名指向这个inode
- 文件数据block的位置

可以用stat命令，查看某个文件的inode信息：

```text-plain
stat example.txt
```

总之，除了文件名以外的所有文件信息，都存在inode之中。至于为什么没有文件名，下文会有详细解释。

## **inode的大小**

inode也会消耗硬盘空间，所以硬盘格式化的时候，操作系统自动将硬盘分成两个区域。一个是数据区，存放文件数据；另一个是inode区（inode table），存放inode所包含的信息。
每个inode节点的大小，一般是128字节或256字节。inode节点的总数，在格式化时就给定，一般是每1KB或每2KB就设置一个inode。假定在一块1GB的硬盘中，每个inode节点的大小为128字节，每1KB就设置一个inode，那么inode table的大小就会达到128MB，占整块硬盘的12.8%。

查看每个硬盘分区的inode总数和已经使用的数量，可以使用df命令。

```text-plain
df -i
```

查看每个inode节点的大小，可以用如下命令：

```text-plain
sudo dumpe2fs -h /dev/hda | grep "Inode size"
```

由于每个文件都必须有一个inode，因此有可能发生inode已经用光，但是硬盘还未存满的情况。这时，就无法在硬盘上创建新文件。

## **inode号码**

每个inode都有一个号码，操作系统用inode号码来识别不同的文件。

这里值得重复一遍，Unix/Linux系统内部不使用文件名，而使用inode号码来识别文件。对于系统来说，文件名只是inode号码便于识别的别称或者绰号。表面上，用户通过文件名，打开文件。实际上，系统内部这个过程分成三步：

1. 首先，系统找到这个文件名对应的inode号码
2. 其次，通过inode号码，获取inode信息
3. 最后，根据inode信息，找到文件数据所在的block，读出数据。

使用`ls -i`命令，可以看到文件名对应的inode号码：

```text-plain
ls -i example.txt
```

## **目录文件**

Unix/Linux系统中，目录（directory）也是一种文件。打开目录，实际上就是打开目录文件。

目录文件的结构非常简单，就是一系列目录项（dirent）的列表。每个目录项，由两部分组成：所包含文件的文件名，以及该文件名对应的inode号码。

`ls -i` 命令列出整个目录文件，即文件名和inode号码：

![img](http://127.0.0.1:37840/api/images/TzFPYwKWJ2aa/image.png)

如果要查看文件的详细信息，就必须根据inode号码，访问inode节点，读取信息。`ls -l`命令列出文件的详细信息。

\#stat 查看文件属性

```text-plain
[root@vm1 test]# stat chen1
  File: 'chen1'
  Size: 21        	Blocks: 0          IO Block: 4096   directory
Device: fd00h/64768d	Inode: 55404427    Links: 3
Access: (0775/drwxrwxr-x)  Uid: ( 1000/chenyantao)   Gid: ( 1000/chenyantao)
Access: 2021-06-12 21:33:59.190767842 -0400
Modify: 2021-06-12 20:41:43.311262441 -0400
Change: 2021-06-12 20:41:43.311262441 -0400
 Birth: -
因为inode 要存放文件的属性信息，所以每个inode 本身是有大小的，Centos5系列inode的默认大小是128 字节，而Centos6系列inode 的默认大小是256 字节，inode的大小在分区被格式化创建文件系统之后定下来，被格式化之后就无法更改inode的大小了，格式化前可以通过参数指定inode大小。
```

dumpe2fs /dev/sda*：可以查看指定分区inoode 和block信息 、

```
inode和block块的大小
inode和block数量
root@cyt:~# dumpe2fs /dev/sda1 | egrep -i "inode size|block size"
dumpe2fs 1.45.5 (07-Jan-2020)
Block size:               4096
Inode size:	          256


root@cyt:~# dumpe2fs /dev/sda1 | egrep -i "inode count|block count"
dumpe2fs 1.45.5 (07-Jan-2020)
Inode count:              30531584
Block count:              122096390
Reserved block count:     6104819
```

 

查看文件系统inode总量以及剩余量

```text-plain
root@cyt:~# df -i
文件系统         Inodes 已用(I)  可用(I) 已用(I)% 挂载点
udev            2006278     590  2005688       1% /dev
tmpfs           2014320    1219  2013101       1% /run
/dev/sdb5       7299072  277747  7021325       4% /
tmpfs           2014320     188  2014132       1% /dev/shm
tmpfs           2014320       7  2014313       1% /run/lock
tmpfs           2014320      18  2014302       1% /sys/fs/cgroup
磁盘空间是否满了，是由两项参数决定的：第一个是inode是否满了，第二个block是否满了，任何一项满了，磁盘就不能再放东西了。
```

2.1 有关inode的小结
磁盘被分区并格式化为ext4 文件系统后会生成一定数量的inode 和block。
inode 称为索引节点，它的作用是存放文件的属性信息以及作为文件的索引(指向文件的实体)。
ext3/ext4文件系统的block 存放的是文件的实际内容。
inode 是磁盘上的一块存储空间，Centos6 非启动分区inode默认大小256 字节，Centos5 是128 字节。
inode 的表现形式是一串数字，不同的文件对应的inode(一串数字) 在文件系统里是唯一的。
inode 节点号相同的文件，互为硬连接文件，可以认为是一个文件的不同入口。
ext3/ext4文件系统下，一个文件在创建后至少要占用一个inode和一个block。
ext3/ext4文件系统下，正常情况下一个文件占用且只能占用一个indoe（人和身份证）
block是用来存储实际数据的，它的大小一般有1k，2k，3k几种。其中引导分区多为1k，其他普通分区多为4k（Centos6）
如果一个文件很大（4G），可能站多个block；如果文件很小（0.01k），至少占一个block，并且这个block的剩余空间浪费了，即无法再存储其它数据默认一般情况下Block数量大于inode数量


如何生成及制定inode大小
格式化命令：mkfs.ext4 -b 2048 -I 256 /dev/sdb

2.2 有关Block的知识小结
磁盘读取数据是按block 为单位读取的。
一个文件可能占用多个block。但是每读取一个block就会消耗一次磁盘I/O。
如果要提升磁盘IO 性能，那么就要尽可能一次性读取数据尽量的多。
一个block 只能存放一个文件的内容，无论内容有多小。如果block 4K,那存放1K 的文件，剩余3K就浪费了。
Block 并非越大越好。Block 太大对于小文件存放就会浪费磁盘空间，例如:1000K的文件，BLOCK 大小为4K，占用250 个BLOCK；若BLOCK 为IK，要占1000个BLOCK。访问效率谁更高? 消耗IO 分别为250 次和1000 次。
根据业务需求，确定默认的block 大小，如果是大文件( 大于16K)一般设置block 大一点，小文件(小于1K)一般设置block小一点。
BLOCK 太大，例如4K，文件都是0.1K的，大量浪费磁盘空间，但是访问性能高。
BLOCK 太小，例如1K，文件都是1000K，消耗大量磁盘IO。
BLOCK 的设置也是格式化分区的对候，mkfs.ext4-b 2048-I 256 /dev/sdb
文件较大时，block 设置大一些会提升磁盘访问效率。
企业里的文件都会比较大（一般都会大于4K），block设置大一些会提升磁盘访问效率。
ext3/ext4文件系统（Centos5和6），一般都设置为4K。


2.3 可以用inode删除文件

```text-plain
[root@vm1 chen1]# echo "今天天气阴天" >>chen.txt 
[root@vm1 chen1]# ls
chen1.1  chen.txt
[root@vm1 chen1]# ls -i chen.txt 
55404461 chen.txt
[root@vm1 chen1]# find /tmp/ -inum 55404461           # inum 指定根据inode查找文件
/tmp/test/chen1/chen.txt
[root@vm1 chen1]# find /tmp/ -inum 55404461 | xargs rm
[root@vm1 chen1]# ls
chen1.1
```

2.4 企业面试题1


一个100M（100000K）的磁盘分区，分别写入1K的文件或写入1M的文件，分别可以写都少个？

假设B 4K 写入1k文件的数量基本上就是block数量
假设 inode 数量够多的时候，就是BLOCK的数量。浪费3/4的容量。
假设 inode 数量小于block的数量，就是inode的数量。浪费3/4的容量。
假设B 4K 写入1M的文件
总block数量/250block=存放1M的数量
硬盘空间多大，基本上就可以写入100/1M数量，一般情况inode和block都是做够。

正确答案：

默认分区常规情况下，对大文件来讲inode是够的。而block数量消耗的会更快，BLOCK为4K的情况，1M的文件不会有磁盘浪费情况，所以文件数量大概为100/1=100 个。
对于小文件0.1k,inode会消耗的更快。默认分区的时候block数量是大于inode数量的。每个小文件都会占用一个inode和一个block.所以最终文件的数量:Inode会先消耗完，文件总量是inode的数量。


a.上面的考试题考察的是文件系统inode和block的知识。
b.Inode是存放文件属性信息的(也包含指向文件实体的指针).默认大小128byte(c58),256byte(c64).
c.Block 是存放文件实际内容的，默认大小1K （boot）或4K（非系统分区默认给4K）,一般企业多用4K 的 block.
d.一个文件至少要占用一个inode及一个block。
e.默认较大分区常规企业真实场景情况下，inode数量是足够的。而block数量消耗的会更快。


2.5 企业面试题2

如果向磁盘写入数据提示如下错误：No space left on device，通过df -h查看磁盘空间，发现没满，请问可能是什么原因？企业场景什么情况下会导致这个问题发生呢？

解答：可能是inode数量被消耗尽了。发生的原因就是小文件特别多导致

3 Linux文件类型及扩展名
3.1 文件类型介绍
Linux系统不同于windows系统，两者之间的文件类型和文件扩展名也有很大的差异，两者之间所代表的含义不同。

例如：

windows下文件扩展名：.jpg、.txt、.doc、.pdf、.gif、.exe、.bat等等。

Linux下的文件类型却和扩展名没什么关系。

3.2 文件类型
在Linux系统中，可以说是一切（包括目录、普通文件）皆为文件。文件类型包含有普通文件（-）、目录（d）、字符设备文件（c）、块设备文件（b）、符号链接文件（l）、管道文件（p）等等。

tar、.tar.gz、.tgz、.zip、.tar.bz表示压缩文件，创建命令一般为tar,gzip,unzip等
sh 表示shell 脚本文件，通过shell 语言开发的程序。
pl 表示perl 语言文件，通过perl 语言开发的程序。
py 表示python 语言文件，通过python 语言开发的程序。
html、.htm、.php、.jsp、.do 表示网页语言的文件。
conf 表示系统的配置文件。
rpm 表示rpm安装包文件。
可用ls -l 来查看。

[root@oldboy test]# ls -l 
total 4 
crw-rw-rw-. 1 root root 1, 5 Nov 21 09:53 character 
drwxr-xr-x. 2 root root 4096 Dec 15 07:31 dir
-rw-r--r--. 1 root root 0 Dec 15 16:34 file 
lrwxrwxrwx. 1 root root 4 Dec 15 16:34 link -> file
1
2
3
4
5
6
3.2.1 普通文件（-）
创建： touch、cp、tar、echo、cat、>、>>等工具。
删除： 可用rm命令。

按照内容，有大致可分为三种

纯文本（ascii）：文件内容可以直接督导数据，例如：字母、数字、特殊字符串等。可以用cat命令读文件，比如配置文件几乎都是这种类型的。
二进制文件（binary）：Linux中的命令程序都是属于这种格式。例如cat命令就是一个二进制文件。
数据格式文件(data)
有些程序在运行的过程中会读取某些特定格式的文件，那些特定格式的文件可以被称为数据文件。
例如:linux 在用户登录时，都会将登录的数据记录在/var/1og/wtmp（last命令的数据库文件）那个文件内，该文件是一个数据文件。通过last命令读出来。cat命令会读出乱码。因为他属于一种特殊格式的文件。lastlog（/var/log/lastlog）
PS：通过file命令可以查看文件类型。

通过file命令可以查看文件类型

[root@oldboy test]# file file 
file: ASCII text

[root@oldboy test]# file /var/log/lastlog 
/var/log/lastlog: data
1
2
3
4
5
3.2.2 目录文件（directory）
创建： mkdir、cp
删除： rmdir、rm -r

ls -F或ls -p来区分目录

[root@oldboy test]# ls -F
character dir/ file link@ 
[root@oldboy test]# ls -p 
character dir/ file link
1
2
3
4
3.2.3 字符设备或块设备文件（character/block）
进入/dev目录下查看一个字符文件

[root@oldboy dev]# ll tty 
crw-rw-rw-. 1 root tty 5, 0 Nov 21 09:53 tty
1
2
进入/dev目录下查看一个块设备文件

[root@oldboy dev]# find /dev/ -type b | xargs ls -l 
brw-rw----. 1 root disk 8, 1 Nov 22 06:31 sda1 
brw-rw----. 1 root disk 8, 2 Nov 21 09:53 sda2
1
2
3
字符设备和块设备一般都在/dev/目录下，块设备就是存放数据的，如/dev/sda等创建字符文件和块设备文件（不重要，了解即可）

[root@oldboy test]# mknod oldboy c 5 1 
[root@oldboy test]# mknod oldboy1 b 5 1 
[root@oldboy test]# ll oldboy * 
crw-r--r--. 1 root root 5, 1 Dec 15 17:46 oldboy 
brw-r--r--. 1 root root 5, 1 Dec 15 17:46 oldboy1
1
2
3
4
5
3.2.4 套接字文件（socket）
套接字文件也是一类特殊的文件，这类文件通常用在网络之间进行数据连接，如：我们可以启动一个城西来监听客户端的请求，客户端可以通过套接字来进行数据通信。简单了解即可。

查找一个套接字文件

[root@oldboy ~]# find / -type s | xargs ls -l 
srw-rw-rw-. 1 root root 0 Nov 21 09:53 /dev/log
1
2
3.2.5 符号链接文件（link）
符号链接文件也被称之为软连接文件

查找链接文件

[root@oldboy test]# ll link 
lrwxrwxrwx. 1 root root 4 Dec 15 16:34 link -> file 
\#/etc/rc.d/init.d和/etc/init.d这两个文件是一个文件 
[root@oldboy test]# ll /etc/rc.d/init.d /etc/init.d -d 
lrwxrwxrwx. 1 root root 11 Nov 16 11:27 /etc/init.d -> rc.d/init.d
drwxr-xr-x. 2 root root 4096 Dec 15 06:31 /etc/rc.d/init.d
1
2
3
4
5
6
可用ln -s创建软连接文件

[root@oldboy test]# ln -s file link
1
3.2.6 管道文件（FIFO.pipo）
FIFO也是一个特殊的文件类型，主要是解决多个程序同时访问一个文件所造成的错误，第一个字符为p。FIFO是fifo–>first-in first-out的缩写。

[root@oldboy ~]# find / -type p | xargs ls -l 
prw--w--w-. 1 postfix postfix 0 Dec 15 17:59 /var/spool/postfix/public/pickup 
prw--w--w-. 1 postfix postfix 0 Dec 15 17:57 /var/spool/postfix/public/qmgr

4 Linux文件的权限
r read（读） 4 
w write （写） 2 
x execute （执行） 1
\-  没有权限 0

这9个，三位一组，第一组为属主的权限，用户权限位、第二组为属组权限位、第三组为其他用户的权限位。

 

#### [软硬链接及inode](http://127.0.0.1:37840/#ZrEAGAhlTo5a)

##  **硬链接**

一般情况下，文件名和inode号码是"一一对应"关系，每个inode号码对应一个文件名。但是，Unix/Linux系统允许，多个文件名指向同一个inode号码。这意味着，可以用不同的文件名访问同样的内容；对文件内容进行修改，会影响到所有文件名；但是，删除一个文件名，不影响另一个文件名的访问。这种情况就被称为"硬链接"（hard link）。

ln命令可以创建硬链接：

```
ln 源文件 目标文件
```

运行上面这条命令以后，源文件与目标文件的inode号码相同，都指向同一个inode。inode信息中有一项叫做"链接数"，记录指向该inode的文件名总数，这时就会增加1。反过来，删除一个文件名，就会使得inode节点中的"链接数"减1。当这个值减到0，表明没有文件名指向这个inode，系统就会回收这个inode号码，以及其所对应block区域。

这里顺便说一下目录文件的"链接数"。创建目录时，默认会生成两个目录项：".“和”…"。

前者的inode号码就是当前目录的inode号码，等同于当前目录的"硬链接"；后者的inode号码就是当前目录的父目录的inode号码，等同于父目录的"硬链接"。所以，任何一个目录的"硬链接"总数，总是等于2加上它的子目录总数（含隐藏目录）,这里的2是父目录对其的“硬链接”和当前目录下的".硬链接“。

## **软链接**

除了硬链接以外，还有一种特殊情况。文件A和文件B的inode号码虽然不一样，但是文件A的内容是文件B的路径。读取文件A时，系统会自动将访问者导向文件B。因此，无论打开哪一个文件，最终读取的都是文件B。这时，文件A就称为文件B的"软链接"（soft link）或者"符号链接（symbolic link）。

这意味着，文件A依赖于文件B而存在，如果删除了文件B，打开文件A就会报错：
“No such file or directory”。

这是软链接与硬链接最大的不同：文件A指向文件B的文件名，而不是文件B的inode号码，文件B的inode"链接数"不会因此发生变化。

`ln -s`命令可以创建软链接。

```text-plain
ln -s 源文文件或目录 目标文件或目录
```

## **inode的特殊作用**

由于inode号码与文件名分离，这种机制导致了一些Unix/Linux系统特有的现象。

1. 有时，文件名包含特殊字符，无法正常删除。这时，直接删除inode节点，就能起到删除文件的作用。
2. 移动文件或重命名文件，只是改变文件名，不影响inode号码。
3. 打开一个文件以后，系统就以inode号码来识别这个文件，不再考虑文件名。因此，通常来说，系统无法从inode号码得知文件名。

第3点使得软件更新变得简单，可以在不关闭软件的情况下进行更新，不需要重启。因为系统通过inode号码，识别运行中的文件，不通过文件名。更新的时候，新版文件以同样的文件名，生成一个新的inode，不会影响到运行中的文件。等到下一次运行这个软件的时候，文件名就自动指向新版文件，旧版文件的inode则被回收。

## **实际问题**

在一台配置较低的Linux服务器（内存、硬盘比较小）的`/data`分区内创建文件时，系统提示磁盘空间不足，用`df -h`命令查看了一下磁盘使用情况，发现`/data`分区只使用了66%，还有12G的剩余空间，按理说不会出现这种问题。 后来用df -i查看了一下/data分区的索引节点(inode)，发现已经用满(IUsed=100%)，导致系统无法创建新目录和文件。

**查找原因：**
`/data/cache`目录中存在数量非常多的小字节缓存文件，占用的Block不多，但是占用了大量的inode。
**解决方案：**

1. 删除`/data/cache`目录中的部分文件，释放出`/data`分区的一部分inode。
2. 用软连接将空闲分区`/opt`中的`newcache`目录连接到`/data/cache`，使用`/opt`分区的inode来缓解`/data`分区inode不足的问题：

```text-plain
ln -s /opt/newcache /data/cache 
```

 

 

 

 


5.3 软链接知识小结
软链接类似Windows的快捷方式（可以通过readlink查看其指向）
软链接类似一个文本文件，里面存放的是源文件的路径，指向源文件实体。
删除源文件，软连接文件依然存在，但是无法访问指向的源文件路径内容了。
软链接失效的时候一般是白色红底闪烁提示。
执行命令“ln -s 源文件 软链接文件”，即可完成创建软链接（目标不能存在）。
软链接和源文件是不同类型的文件，也是不同的文件。inode号也不相同。
软链接文件的文件类型为（l），可以用rm命令删除。


5.4 有关文件链接的小结
删除软链接文件对源文件及硬链接文件无任何影响。
删除硬链接文件对源文件及软连接文件无任何影响。
删除源文件，对应链接文件没有影响，但是会导致软连接文件失效，白字红底闪烁。
同时删除源文件和硬链接文件，整个文件会真正的被删除。
很多硬件设备中的快照功能，就是利用了硬链接的原理。
源文件和硬链接文件具有相同的索引节点，可以认为是同一文件或一个文件的多个入口。
源文件和硬链接文件索引节点号不同，是不同的文件，软链接相当于源文件的快捷方式，含有源文件的位置指向。


5.5 有关目录链接的小结
对于目录，不可以创建硬链接，但是可以创建软链接,其系统默认在目录下创建“.”硬链接，但是用户不能用ln命令给目录创建硬链接
对于目录的软链接是生产场景中常用的技巧，即把一个很深层次的目录给做一个软链接，就相当于整一个快捷方式。
目录的硬链接不能跨文件系统（从硬链接原理理解）
每个目录下面都有一个硬链接“.”号，和对应上级目录的硬链接“…”。
在父目录里创建一个子目录，父目录的链接数增加1（每个子目录里都有…来指向父目录）。但是在父目录里创建文件，父目录的链接数不会增加。
为什么说“.”代表当前目录，因为“.”和oldboy的inode号相同


5.6 描述linux下软链接和硬链接的区别
默认不带参数的情况下，ln命令创建的是硬链接，带 -s参数的ln命令创建的是软链接。
硬链接文件与源文件的inode节点号相同，而软连接文件的inode节点号与源文件不同。
ln命令不能目录创建硬链接，但是可以创建软链接，对目录的软链接会经常被用到。
删除软链接文件，对源文件及硬链接文件无任何影响。
删除文件的硬链接文件，对源文件及软链接文件无任何影响
删除链接文件的源文件对硬链接文件无影响，会导致其软链接失效（红底白字闪烁状）
同时删除源文件及其硬链接文件，整个文件才会被真正的删除
很多硬件设备中的快照功能，使用的就类似硬链接的原理
软链接可以跨文件系统，硬链接不可以跨文件系统

 


6 Linux下文件删除的原理
linux的文件名是存在父目录的bolck里面，并指向这个文件的inode节点，这个文件的inode节点再标记指向存放这个文件的bolck的数据块。我们删除一个文件，实际上并不清除inode 节点和block
的数据。只是在这个文件的父目录里面的bolck中，删除这个文件的名字，从而使这个文件名消失，并且无法指向这个文件的inode节点，当没有文件名指向这个inode 节点的时候，会同时释放inode节点和存放这个文件的数据块，并更新inode MAP和block MAP今后让这些位置可以用于放置其他文件数据。


企业案例1：Web服务器磁盘满故障深入解析

参考博客：http://oldboy.blog.51cto.com/2561410/612351

企业案例2：磁盘满的另外的故障（inode满）

小文件：sendmail产生的日志文件，很小

7 Linux文件属性之用户和组
Linux/Unix是一个多用户、多任务的操作系统。

7.1 Linux系统中用户角色划分
在linux系统中用户是分角色的，在Linux系统中，由于角色不同，权限和所完成的任务也不同;
值得注意的是，对于linux系统来说，用户的角色是通过UD和GID识别的；特别是UID,在linux系统运维工作中，一个UID是唯一标识一个系统用户的帐号(相当于我们的身份证)。用户系统帐号的名称(如oldboy)其实给人(管理员)看的，linux系统能够识别的仅仅是UID和GID这样的数字。用户的UID就相当于我们的身份证一样，用户名就相当于我们的名字。

UID（User Identify） 中文：用户ID，相当于我们的身份证，在系统里是唯一的

GID（Group Identity）中文：组ID，相当于我们的家庭或我们学校的ID。

用户分为三类：

（1）超级用户：

默认是root用户，其UID和GID均为0.root用户在每台unix/Linux操作系统重都是唯一且真是存在的，通过它可以登录系统，可以操作系统中任何文件和命令，拥有最高的管理权限。在生产环境中，一般会禁止root账号通过ssh远程连接服务器（保护好皇帝），当然，也会更改默认的ssh端口（保护好皇宫），以加强系统安全。
企业工作中：没有特殊需求，应尽量在普通用户下操作任务，而不是root。
在Linux系统中，uid为0的用户就是超级用户，但是通常不这么做，而是使用sudo管理提权，可以细到每个命令权限分配。

（2）普通用户

这类用户一般是由具备系统管理员rpot的权限的运维或系统管理人员添加的。例如:oldboy
这类用户可以登录系统,但仅具备操作自己家目录中的文件及目录的权限，除此之外，还可以进入、或浏览相关目录(/etc,/var/log),但是无法创建、修改和删除;
普通用户: 比喻皇帝的臣民，干坏事时，国家有法律管束你。为普通用户授权(sudo),封官。布衣也可以提权。
su - root，角色切换，农民起义，推翻皇帝，自己当皇帝。
sudo ls 授权、风管，尚方宝剑。可以为皇帝办事，有一定权限，但还是自己。

（3）虚拟用户

与真实普通用户区分开来，这类用户最大的特点是安装系统后默认就会存在，且默认情况大多数不能登录系统，但是，他们是系统正常运行不可缺少的，它们的存在主要是方便系统管理，满足相应的系统进程对文件属主的要求。例如:系统默认的bin、adm、nobody、mail用户等。由于服务器业务角色的不同，有部分用不到的系统服务被禁止开机执行，因此，在做系统安全优化时，被禁止开机启动了的服务对应的虚拟用户也是可以处理掉的(删除或注释)

Linux安全优化

安装系统后可以删除用不到的虚拟用户，但最好不删除而是注释掉，万一出问题可以恢复过来。
我们自己部署服务的时候，也会创建虚拟用户，满足服务的要求！例如：apache、nginx、mysql、nfs、rsync、nagios、zabbix、redis。
7.2 Linux系统中不同用户角色对应的UID说明
超级用户： 0
虚拟用户： 1-499
普通用户： 500-65535

7.3 用户和组的配置文件
Linux系统下的账户文件主要有/etc/passwd、/etc/group、/etc/shadow、/etc/gshadow四个文件。

/etc/passwd #->用户的配置文件
/etc/shadow #->用户影子口令文件
密码文件/etc/passwd: