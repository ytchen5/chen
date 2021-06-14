parted

针对超过2TB的磁盘分区

parted命令

-l 显示所有分区信息

注意：小于2T的硬盘都可以使用fdisk 分区，但是大于2T的硬盘只能使用parted命令进行分区且需要转换磁盘的GPT格式

```text-plain
root@cyt:~# parted -l
Model: ATA ST500LT012-1DG14 (scsi)
Disk /dev/sda: 500GB
Sector size (logical/physical): 512B/4096B
Partition Table: msdos
Disk Flags: 

Number  Start   End    Size   Type     File system  Flags
 1      1049kB  500GB  500GB  primary  ext4


Model: ATA kingSSD_JSY-M100 (scsi)
Disk /dev/sdb: 120GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End    Size   Type      File system  Flags
 1      1049kB  538MB  537MB  primary   fat32        boot
 2      539MB   120GB  119GB  extended
 5      539MB   120GB  119GB  logical   ext4


root@cyt:~# 
```

如下使用新添加的5G的硬盘作为演示parted创建分区的步骤

```shell
1、查看到系统识别了此块硬盘
[root@vm1 ~]# parted -l
Error: /dev/sda: unrecognised disk label
Model: QEMU QEMU HARDDISK (scsi)                                          
Disk /dev/sda: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: unknown
Disk Flags: 
[root@vm1 ~]# parted /dev/sda           # 使用parted 开始分区
GNU Parted 3.1
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) help  # 输入help查看功能区                                                        
  align-check TYPE N                        check partition N for TYPE(min|opt) alignment
  help [COMMAND]                           print general help, or help on COMMAND
  mklabel,mktable LABEL-TYPE               create a new disklabel (partition table)
  mkpart PART-TYPE [FS-TYPE] START END     make a partition
  name NUMBER NAME                         name partition NUMBER as NAME
  print [devices|free|list,all|NUMBER]     display the partition table, available devices, free space, all found partitions, or a particular partition
  quit                                     exit program
  rescue START END                         rescue a lost partition near START and END
  
  resizepart NUMBER END                    resize partition NUMBER
  rm NUMBER                                delete partition NUMBER
  select DEVICE                            choose the device to edit
  disk_set FLAG STATE                      change the FLAG on selected device
  disk_toggle [FLAG]                       toggle the state of FLAG on selected device
  set NUMBER FLAG STATE                    change the FLAG on partition NUMBER
  toggle [NUMBER [FLAG]]                   toggle the state of FLAG on partition NUMBER
  unit UNIT                                set the default unit to UNIT
  version                                  display the version number and copyright information of GNU Parted

(parted) mktable gpt  #创建gpt格式的分区表，此命令很危险，容易导致原有数据丢失，慎重使用，只能对新的硬盘进行使用
(parted)  p           #输入p打印以下分区表类型                                                         
Model: QEMU QEMU HARDDISK (scsi)
Disk /dev/sda: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt    #这里看到已经变成gpt格式了，MBR的分区表类型这里显示的是msdos
Disk Flags: 

Number  Start  End  Size  File system  Name  Flags

(parted) mkpart primary 0 500   # mkpart PART-TYPE [FS-TYPE] START END  f分区类型有（primary和logical两种）
Warning: The resulting partition is not properly aligned for best performance.
                                                        
Ignore/Cancel? ignore   # 这里选择Ignore忽略                                                  
(parted) p                                                                
Model: QEMU QEMU HARDDISK (scsi)
Disk /dev/sda: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End    Size   File system  Name     Flags
 1      17.4kB  500MB  500MB               primary         #我们发现已经创建了一个主分区
 
(parted) mkpart logical 501 4000   还可以继续创建逻辑分区，parted不存在扩展分区操作
(parted) p                                                                
Model: QEMU QEMU HARDDISK (scsi)
Disk /dev/sda: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name     Flags
 1      17.4kB  500MB   500MB                primary
 2      501MB   4000MB  3499MB               logical

(parted) q  # 退出parted        
                       
查看创建的区  
[root@vm1 ~]# ll /dev/sda                                                 
sda   sda1  sda2  
[root@vm1 ~]# ll /dev/sda*
brw-rw---- 1 root disk 8, 0 Jun 13 07:25 /dev/sda
brw-rw---- 1 root disk 8, 1 Jun 13 07:25 /dev/sda1
brw-rw---- 1 root disk 8, 2 Jun 13 07:25 /dev/sda2
                                       
```

