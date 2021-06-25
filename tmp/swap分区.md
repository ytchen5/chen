我们在安装系统的时候已经建立了 swap 分区。swap 分区通常被称为交换分区，这是一块特殊的硬盘空间，即当实际内存不够用的时候，操作系统会从内存中取出一部分暂时不用的数据，放在交换分区中，从而为当前运行的程序腾出足够的内存空间。

也就是说，当内存不够用时，我们使用 swap 分区来临时顶替。这种“拆东墙，补西墙”的方式应用于几乎所有的操作系统中。

使用 swap 交换分区，显著的优点是，通过操作系统的调度，应用程序实际可以使用的内存空间将远远超过系统的物理内存。由于硬盘空间的价格远比 RAM 要低，因此这种方式无疑是经济实惠的。当然，频繁地读写硬盘，会显著降低操作系统的运行速率，这也是使用 swap 交换分区最大的限制。

相比较而言，Windows 不会为 swap 单独划分一个分区，而是使用分页文件实现相同的功能，在概念上，Windows 称其为虚拟内存，从某种意义上将，这个叫法更容易理解。因此，初学者将 swap 交换分区理解为虚拟内存是没有任何问题的。

具体使用多大的 swap 分区，取决于物理内存大小和硬盘的容量。一般来讲，swap 分区容量应大于物理内存大小，建议是内存的两倍，但不超过 2GB。但是，有时服务器的访问量确实很大，有可能出现 swap 分区不够用的情况，所以我们需要学习 swap 分区的构建方法。

建立新的 swap 分区，只需要执行以下几个步骤。

1. 分区：不管是 fdisk 命令还是 parted 命令，都需要先区。
2. 格式化：格式化命令稍有不同，使用 mkswap 命令把分区格式化成 swap 分区。
3. 使用 swap 分区。


下面我们来逐一实现。

## 建立swap分区第一步：分区

命令如下：

[root@localhost ~]# fdisk /dev/sdb
\#以/dev/sdb分区为例
WARNING: DOS-compatible mode is deprecated.It's strongly recommended to switch off the mode (command 'c') and change display units to sectors (command 'u').
Command (m for help): n
\#新建
Command action e extended p primary partition (1-4)
P
\#主分区
Partition number (1-4): 1
\#分区编号
First cylinder (1-2610, default 1):
\#起始柱面
Using default value 1
Last cylinder, +cylinders or +size{K, M, G} (1-2610, default 2610): +500M
\#大小
Command (m for help): p
\#查看一下
Disk /dev/sdb: 21.5GB, 21474836480 bytes
255 heads, 63 sectors/track, 2610 cylinders
Units = cylinders of 16065 *512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes 1512 bytes
Disk identifier: OxOOOOOebd
Device Boot Start End Blocks Id System
/dev/sdb1 1 65 522081 83 Linux
\#刚分配的分区ID是83，是Linux分区，我们在这里要分配swap分区
Command (m for help): t
\#修改分区的系统ID
Selected partition 1
\#只有一个分区，所以不用选择分区了
Hex code (type L to list codes): 82
\#改为swap分区的ID
Changed system type of partition 1 to 82 (Linux swap / Solaris)
Command (m for help): p
\#再查看一下
Disk /dev/sdb: 21.5 GB, 21474836480 bytes
255 heads, 63 sectors/track, 2610 cylinders
Units = cylinders of 16065 *512 = 8225280 bytes Sector size (logical/physical): 512 bytes / 512 bytes I/O size (minimum/optimal): 512 bytes 1512 bytes Disk identifier: OxOOOOOebd
Device Boot Start End Blocks Id System
/dev/sdb1 1 65 522081 82 Linux swap / Solaris
\#修改过来了
Command (m for help): w
\#记得保存退出
The partition table has been altered!
Calling ioctl() to re-read partition table.
Syncing disks.

仍以 /dev/sdb 分区作为实验对象。不过，如果分区刚刚使用 parted 命令转变为 GPT 分区表，则记得转换回 MBR 分区表，fdisk 命令才能识别，否则干脆新添加一块硬盘做实验。

## 建立 swap 分区第二步：格式化

因为要格式化成 swap 分区，所以格式化命令是 mkswap。命令如下：

[root@localhost ~]# mkswap /dev/sdb1
Setting up swapspace version 1, size = 522076 KiB
no label, UUID=c3351 dc3-f403-419a-9666-c24615e170fb

## 使用swap分区

在使用 swap 分区之前，我们先来说说 free 命令。命令如下：

[root@localhost ~]#free
total used free shared buffers cached
Mem: 1030796 130792 900004 0 15292 55420
-/+ buffers/cache: 60080 970716
Swap: 2047992 0 2047992

free 命令主要是用来查看内存和 swap 分区的使用情况的，其中：

- total：是指总数；
- used：是指已经使用的；
- free：是指空闲的；
- shared：是指共享的；
- buffers：是指缓冲内存数；
- cached：是指缓存内存数，单位是KB；


我们需要解释一下 buffers（缓冲）和 cached（缓存）的区别。简单来讲，cached 是给读取数据时加速的，buffers 是给写入数据加速的。cached 是指把读取出来的数据保存在内存中，当再次读取时，不用读取硬盘而直接从内存中读取，加速了数据的读取过程；buffers 是指在写入数据时，先把分散的写入操作保存到内存中，当达到一定程度后再集中写入硬盘，减少了磁盘碎片和硬盘的反复寻道，加速了数据的写入过程。

我们已经看到，在加载进新的 swap 分区之前，swap 分区的大小是 2000MB，接下来只要加入 swap 分区就可以了，使用命令 swapon。命令格式如下：

[root@localhost ~]# swapon 分区设备文件名

例如：

[root@localhost ~]# swapon /dev/sdb1
swap分区已加入，我们查看一下。
[root@localhost ~]#free
total used free shared buffers cached
Mem: 1030796 131264 899532 0 15520 55500
-/+ buffers/cache: 60244 970552
Swap: 2570064 0 2570064

swap 分区的大小变成了 2500MB，加载成功了。如果要取消新加入的 swap 分区，则也很简单，命令如下：

[root@localhost ~]# swapoff /dev/sdb1

如果想让 swap 分区开机之后自动挂载，就需要修改 /etc/fstab 文件，命令如下：

[root@localhost ~]#vi /etc/fstab
UUID=c2ca6f57-b15c-43ea-bca0-f239083d8bd2 / ext4 defaults 1 1
UUID=0b23d315-33a7-48a4-bd37-9248e5c443451 boot ext4 defaults 1 2
UUID=4021be19-2751-4dd2-98cc-383368c39edb swap swap defaults 0 0
tmpfs /dev/shm
tmpfs defaults 0 0
devpts /dev/pts
devpts gid=5, mode=620 0 0
sysfs /sys
sysfs defaults 0 0
proc /proc
proc defaults 0 0
/dev/sdb1 swap swap
defaults 0 0
\#加入新swap分区的相关内容，这里直接使用分区的设备文件名，也可以使用UUID。