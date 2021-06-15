问题：在linux中误删除分区怎么恢复呢？

在我们日常运维中，频繁的操作，可能命令写入错误导致磁盘分区被误删除，那么这种情况怎么恢复磁盘分区呢？

前提在机器没有重启的情况下，

如下我们准备了个分区

```
[root@vm1 ~]# fdisk /dev/sda 
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p

Disk /dev/sda: 5368 MB, 5368709120 bytes, 10485760 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000a1770

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048    10485759     5241856   83  Linux
```

2 删除分区/dev/sda1，重启服务器

```
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048    10485759     5241856   83  Linux

Command (m for help): d
Selected partition 1
Partition 1 is deleted

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@vm1 ~]# ll /dev/sda*
brw-rw---- 1 root disk 8, 0 Jun 15 07:09 /dev/sda  没有sda1分区了
```

3 安装epel-release和testdisk

```
yum install epel-release.noarch testdisk -y
```

4 使用testdisk打开

```
[root@vm1 ~]# testdisk 
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org
```

① 选择Create

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org


TestDisk is free data recovery software designed to help recover lost
partitions and/or make non-booting disks bootable again when these symptoms
are caused by faulty software, certain types of viruses or human error.
It can also be used to repair some filesystem errors.

Information gathered during TestDisk use can be recorded for later
review. If you choose to create the text file, testdisk.log , it
will contain TestDisk options, technical information and various
outputs; including any folder/file names TestDisk was used to find and
list onscreen.

Use arrow keys to select, then press Enter key:
>[ Create ] Create a new log file     选择 Create
 [ Append ] Append information to log file
 [ No Log ] Don't record anything


```



② 选择要修复的磁盘，/dev/sda,选择下面的proceed 回车

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org

  TestDisk is free software, and
comes with ABSOLUTELY NO WARRANTY.

Select a media (use Arrow keys, then press Enter):
>Disk /dev/sda - 5368 MB / 5120 MiB - QEMU QEMU HARDDISK
 Disk /dev/mapper/centos-root - 18 GB / 16 GiB
 Disk /dev/mapper/centos-swap - 2147 MB / 2048 MiB
 Disk /dev/dm-0 - 18 GB / 16 GiB
 Disk /dev/dm-1 - 2147 MB / 2048 MiB
 Disk /dev/vda - 21 GB / 20 GiB
 
>[Proceed ]  [  Quit  ]

Note: Disk capacity must be correctly detected for a successful recovery.
If a disk listed above has an incorrect size, check HD jumper settings and BIOS
detection, and install the latest OS patches and disk drivers.


```

![](/home/chenyantao/桌面/2021-06-15 19-37-25屏幕截图.png)

③ 选择分区表类型（Linux/Windows就选［Intel］），这里选intel 回车

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org


Disk /dev/sda - 5368 MB / 5120 MiB - QEMU QEMU HARDDISK

Please select the partition table type, press Enter when done.
>[Intel  ] Intel/PC partition
 [EFI GPT] EFI GPT partition map (Mac i386, some x86_64...)
 [Humax  ] Humax partition table            
 [Mac    ] Apple partition map (legacy)
 [None   ] Non partitioned media
 [Sun    ] Sun Solaris partition
 [XBox   ] XBox partition
 [Return ] Return to disk selection

Note: Do NOT select 'None' for media with only a single partition. It's very
rare for a disk to be 'Non-partitioned'.


```

![](/home/chenyantao/桌面/2021-06-15 19-47-53屏幕截图.png)

④ 选择Analyse 回车

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org


Disk /dev/sda - 5368 MB / 5120 MiB - QEMU QEMU HARDDISK
     CHS 1018 166 62 - sector size=512

>[ Analyse  ] Analyse current partition structure and search for lost partitions
 [ Advanced ] Filesystem Utils
 [ Geometry ] Change disk geometry
 [ Options  ] Modify options
 [ MBR Code ] Write TestDisk MBR code to first sector
 [ Delete   ] Delete all data in the partition table
 [ Quit     ] Return to disk selection

Note: Correct disk geometry is required for a successful recovery. 'Analyse'
process may give some warnings if it thinks the logical geometry is mismatched.

```

![](/home/chenyantao/桌面/2021-06-15 19-52-30屏幕截图.png)

⑤ 在弹出的界面选择快速查找，[Quick Search] 回车

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org

Disk /dev/sda - 5368 MB / 5120 MiB - CHS 1018 166 62
Current partition structure:
     Partition                  Start        End    Size in sectors

No partition is bootable

*=Primary bootable  P=Primary  L=Logical  E=Extended  D=Deleted
>[Quick Search]

```

![](/home/chenyantao/桌面/2021-06-15 19-55-58屏幕截图.png)

⑥ 弹出的界面选择Continue 继续

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org

Disk /dev/sda - 5368 MB / 5120 MiB - CHS 1018 166 62

Warning: the current number of heads per cylinder is 166
but the correct value may be 255.
You can use the Geometry menu to change this value.
It's something to try if
- some partitions are not found by TestDisk
- or the partition table can not be written because partitions overlap.


[ Continue ]

```

![](/home/chenyantao/桌面/2021-06-15 19-57-43屏幕截图.png)

⑦ 接下来选择 查看到查找到的分区 然后按下 enter键继续

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org

Disk /dev/sda - 5368 MB / 5120 MiB - CHS 1018 166 62
     Partition               Start        End    Size in sectors
>* Linux                    0  33  3  1018 137 10   10483712


Structure: Ok.  Use Up/Down Arrow keys to select partition.
Use Left/Right Arrow keys to CHANGE partition characteristics:
*=Primary bootable  P=Primary  L=Logical  E=Extended  D=Deleted
Keys A: add partition, L: load backup, T: change type,
     Enter: to continue
XFS CRC enabled, blocksize=4096, 5367 MB / 5119 MiB

```

![](/home/chenyantao/桌面/2021-06-15 20-00-42屏幕截图.png)

⑧ 按右键 选择下方的 write 将原有分区表信息写会到磁盘中，

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org

Disk /dev/sda - 5368 MB / 5120 MiB - CHS 1018 166 62

     Partition                  Start        End    Size in sectors

 1 * Linux                    0  33  3  1018 137 10   10483712


 [  Quit  ]  [ Return ]  [Deeper Search] >[ Write  ]
                       Write partition structure to disk

```

![](/home/chenyantao/桌面/2021-06-15 20-04-00屏幕截图.png)

⑨ 根据如下提示 输入Y 按下回车

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org

Write partition table, confirm ? (Y/N)
```

![](/home/chenyantao/桌面/2021-06-15 20-06-01屏幕截图.png)

如下提示需要重启才能生效，回车ok即可

```
TestDisk 7.1, Data Recovery Utility, July 2019
Christophe GRENIER <grenier@cgsecurity.org>
https://www.cgsecurity.org


You will have to reboot for the change to take effect.

>[Ok]

```

![](/home/chenyantao/桌面/2021-06-15 20-08-44屏幕截图.png)

然后按下esc 选择 两次 quit  退出软件

5 我们看到分区、/dev/sda1 已经恢复回来了，

```
[root@vm1 ~]# fdisk /dev/sda 
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p

Disk /dev/sda: 5368 MB, 5368709120 bytes, 10485760 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000a1770

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048    10485759     5241856   83  Linux

Command (m for help): 
```

```
[root@vm1 ~]# ll /dev/sda*
brw-rw---- 1 root disk 8, 0 Jun 15 08:11 /dev/sda
brw-rw---- 1 root disk 8, 1 Jun 15 08:11 /dev/sda1
```

