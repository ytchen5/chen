mount命令常用参数

-l	显示系统所有挂载的设备信息

-t	指定设备文件系统类型，如果不指定，mount自动选择挂载的文件系统类型

-o	添加挂载功能选项，用的很多

-r	read 挂载后的设备是只读的

-w	读写参数，-o	rw权限，允许挂载后读写操作



```
cyt:~$ mount | egrep ^\/dev\/* 
/dev/sdb5 on / type ext4 (rw,relatime,errors=remount-ro)
/dev/sdb1 on /boot/efi type vfat (rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
/dev/sda1 on /data1 type ext4 (rw,relatime)
/dev/fuse on /run/user/1000/doc type fuse (rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)
```

mount -o 参数详解 就是后面（）内的参数

async	以异步的方式处理文件系统IO，加速写入，数据不会同步写到磁盘，先写入到缓冲区，提高系统性			  能，可能有数据丢失的风险

sync	所有的IO操作同步处理，数据同步写入到磁盘，性能较弱，提高数据写入的安全性

atime/noatime 文件被访问的时候是否修改时间戳，能够提升磁盘IO速度

auto/noauto	可以通过-a参数自动挂载，或者不自动挂载

defaults	默认参数，涵盖了，（rw,suid,dev,exec,auto,nouser,async）

exec/noexec	是否运行挂载点内的可执行命令，如果使用了 noexec可以提升磁盘安全性

ro	只读

rw	读写

对于centos7新出现的mount选项有

attr2	在磁盘上存储一个内连扩展属性，提升磁盘性能

inode64	允许在文件系统的任意位置创建inode

noquota	强制关闭文件系统的限额功能



#mount挂载案例#





