yum

***1 、yum回滚操作（及删除软件包本身及所附带安装的依赖包） 可以看到安装操作ID为39***

```
[root@vm1 pxe]# yum history list system-config-kickstart
Loaded plugins: fastestmirror
ID     | Command line             | Date and time    | Action(s)      | Altered
-------------------------------------------------------------------------------
    39 | install system-config-ki | 2021-07-01 08:26 | I, U           |  130   
history list

```

然后执行

```
Loaded plugins: fastestmirror
Undoing transaction 39, from Thu Jul  1 08:26:30 2021
    Dep-Install ModemManager-glib-1.6.10-4.el7.x86_64           @base
    Dep-Install adwaita-cursor-theme-3.28.0-1.el7.noarch        @base
    Dep-Install adwaita-icon-theme-3.28.0-1.el7.noarch          @base
    Dep-Install at-spi2-atk-2.26.2-1.el7.x86_64                 @base
    Dep-Install at-spi2-core-2.28.0-1.el7.x86_64                @base
    Dep-Install atk-2.28.1-2.el7.x86_64                         @base
    Dep-Install avahi-glib-0.6.31-20.el7.x86_64                 @base
    Updated     avahi-libs-0.6.31-19.el7.x86_64                 @anaconda
    Update                 0.6.31-20.el7.x86_64                 @base
    Dep-Install cairo-1.15.12-4.el7.x86_64                      @base
    Dep-Install cairo-gobject-1.15.12-4.el7.x86_64              @base
    Dep-Install cdparanoia-libs-10.2-17.el7.x86_64              @base
    Dep-Install colord-libs-1.3.4-2.el7.x86_64                  @base
    Dep-Install cups-libs-1:1.6.3-51.el7.x86_64                 @base
    Dep-Install dconf-0.28.0-4.el7.x86_64                       @base
    Dep-Install dejavu-fonts-common-2.33-6.el7.noarch           @base
   。。。。
```

***2、使用yum 匹配安装适合自己系统的软件包***

```
[root@vm1 home]# yum install --downloadonly --downloaddir=/home tcpdump
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
Resolving Dependencies
--> Running transaction check
---> Package tcpdump.x86_64 14:4.9.2-4.el7_7.1 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================================================================================================================
 Package                              Arch                                Version                                          Repository                         Size
===================================================================================================================================================================
Installing:
 tcpdump                              x86_64                              14:4.9.2-4.el7_7.1                               base                              422 k

Transaction Summary
===================================================================================================================================================================
Install  1 Package

Total download size: 422 k
Installed size: 1.0 M
Background downloading packages, then exiting:
tcpdump-4.9.2-4.el7_7.1.x86_64.rpm                                                                                                          | 422 kB  00:00:01     
exiting because "Download Only" specified



[root@vm1 home]# ll /home/tcp*.rpm
-rw-r--r-- 1 root root 431688 Dec  3  2019 /home/tcpdump-4.9.2-4.el7_7.1.x86_64.rpm

```

***3、使用yum查询某个文件是由那个文件装起来的***

```
[root@vm1 home]# which systemctl 
/bin/systemctl

## 用于找出哪个包提供了某些特性或文件。只需使用特定的名称或文件-全局语法通配符来列出包
[root@vm1 home]# yum provides /bin/systemctl 
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
systemd-219-78.el7.x86_64 : A System and Service Manager
Repo        : base
Matched from:
Filename    : /bin/systemctl



systemd-219-62.el7.x86_64 : A System and Service Manager
Repo        : @anaconda
Matched from:
Filename    : /bin/systemctl



[root@vm1 home]# 

或者：
[root@vm1 home]# yum search tcpdump
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
====================================================================== N/S matched: tcpdump =======================================================================
tcpdump.x86_64 : A network traffic monitoring tool

  Name and summary matches only, use "search all" for everything.
[root@vm1 home]# 

## search当您知道某个包的一些信息，但不确定它的名称时，它用于查找包。默认情况下，搜索将尝试搜索只是

```

***4 使用yum查询适合自己系统的软件包并且安装***

```
[root@vm1 home]# yum install system-config-kickstart --showduplicates
```

***5 使用yum设置在本地缓存软件包***

```
[root@vm1 home]# sed -i '/^keep*./s/keepcache=0/keepcache=1/' /etc/yum.conf 
[root@vm1 home]# sed -n '/^keep*./p' /etc/yum.conf 
keepcache=1
```

***6 使用yum分析软件包的依赖关系***

```
[root@vm1 home]# yum deplist tcpdump
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
package: tcpdump.x86_64 14:4.9.2-4.el7_7.1
  dependency: /bin/sh
   provider: bash.x86_64 4.2.46-34.el7
  dependency: /usr/bin/getent
   provider: glibc-common.x86_64 2.17-317.el7
  dependency: libc.so.6(GLIBC_2.14)(64bit)
   provider: glibc.x86_64 2.17-317.el7
  dependency: libcap-ng.so.0()(64bit)
   provider: libcap-ng.x86_64 0.7.5-4.el7
  dependency: libcrypto.so.10()(64bit)
   provider: openssl-libs.x86_64 1:1.0.2k-19.el7
  dependency: libcrypto.so.10(OPENSSL_1.0.2)(64bit)
   provider: openssl-libs.x86_64 1:1.0.2k-19.el7
  dependency: libcrypto.so.10(libcrypto.so.10)(64bit)
   provider: openssl-libs.x86_64 1:1.0.2k-19.el7
  dependency: libpcap >= 14:1.5.3-10
   provider: libpcap.x86_64 14:1.5.3-12.el7
   provider: libpcap.i686 14:1.5.3-12.el7
  dependency: libpcap.so.1()(64bit)
   provider: libpcap.x86_64 14:1.5.3-12.el7
  dependency: rtld(GNU_HASH)
   provider: glibc.x86_64 2.17-317.el7
   provider: glibc.i686 2.17-317.el7
  dependency: shadow-utils
   provider: shadow-utils.x86_64 2:4.6-5.el7

```

