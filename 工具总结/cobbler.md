

### 目录

- PXE简介
- kickstart简介
- Cobbler简介
- 功能实现

## 一、PXE简介

PXE，就是预启动执行环境，是一种引导启动的方式。这种协议一般由两部分构成，一部分是服务器端，一个是客户端。简单来说，我们通过这种方式可以自己创建一个“安装源”，在安装系统的时候只要能找到这个“源”便可以实现系统的安装。

在实现无人值守的安装前，我们必须要搭建一些服务，来实现“安装源”的建立，例如ftp、http、tftp、dhcp等。当一台主机启动时，标准输入输出会将PXE客户端调入我们的内存中进行相关的操作，并提示相关的选项，在这里我们可以进行选择。PXE的客户端通过网络下载(download)启动文件到本地运行。具体过程是，PXE客户端通过网卡向局域网内发送ip请求，然后DHCP服务器会提供给给它一个ip地址和系统安装所需要的文件，接下使用接收到的文件进行系统安装。而安装的过程又需要其他服务器提供的资源，例如：yum源，内核文件等，当主机拿到这些资源，便可以顺利的安装了。最终结果是：任意一台主机在选着网络启动时会获取DHCP服务器分发的ip，通过通过获取到的ip地址与局域网内的TFTP服务器通信并获取启动文件，与FTP或者HTTP通信并获取yum源文件及内核文件等。之后开始自动安装，而这个过程不需要人在做任何操作。

PXE安装优点，这种安装系统的方式可以不受光驱，光盘以及一些外部设备的限制，还可以做到无人值守，大大减轻了运维人员的工作负荷，像在一些主机数量庞大的机房进行批量安装，PXE将是你不二的选择。 1

PXE安装方案总体如下（DHCP/TFTP/HTTP服务器可以设置在同一个服务器内）：

![](https://img-blog.csdnimg.cn/20190308174936147.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

## 二、kickstart简介

KickStart是一种无人职守安装方式。KickStart的工作原理是通过记录典型的安装过程中所需人工干预填写的各种参数，并生成一个名为ks.cfg的文件；在其后的安装过程中(不只局限于生成KickStart安装文件的机器)当出现要求填写参数的情况时，安装程序会首先去查找KickStart生成的文件，当找到合适的参数时，就采用找到的参数，当没有找到合适的参数时，才需要安装者手工干预。这样，如果KickStart文件涵盖了安装过程中出现的所有需要填写的参数时，安装者完全可以只告诉安装程序从何处取ks.cfg文件，然后去忙自己的事情。等安装完毕，安装程序会根据ks.cfg中设置的重启选项来重启系统，并结束安装。

<img src="https://img-blog.csdnimg.cn/2019030816491629.jpg" style="zoom:150%;" />



## 三、Cobbler简介

#### 3.1、Cobbler简介

Cobbler是一个免费开源系统安装部署软件，用于自动化网络安装操作系统。Cobbler 集成了 DNS, DHCP, 软件包更新，带外管理以及配置管理，方便操作系统安装自动化。Cobbler 可以支持PXE启动, 操作系统重新安装,以及虚拟化客户机创建，包括Xen, KVM or VMware. Cobbler透过koan程序以支持虚拟化客户机安装。Cobbler可以支持管理复杂网路环境，如建立在链路聚合以太网的桥接环境。

该工具使用python开发，小巧轻便（才15k行python代码），使用简单的命令即可完成PXE网络安装环境的配置，同时还可以管理DHCP、DNS、以及yum仓库、构造系统ISO镜像。

Cobbler支持命令行管理，web界面管理，还提供了API接口，可以方便二次开发使用。Cobbler客户端Koan支持虚拟机安装和操作系统重新安装，使重装系统更便捷。

Cobbler提供以下服务集成：

- PXE服务支持
- DHCP服务管理
- DNS服务管理
- 电源管理
- Kickstart服务支持
- yum仓库管理
- TFTP (PXE启动时需要)
- Apache（提供kickstart 的安装源，并提供定制化的kickstart配置)

同时，它和apache做了深度整合。通过 cobbler，可以实现对RedHat/Centos/Fedora系统的快速部署，同时也支持Suse 和Debian(Ubuntu)系统。3

注1：通过pxe+kickstart已可简单实现了自动化安装，但只能实现单一版本安装，当需要部署不同版本或不同引导模式（BIOS、EFI）时，此种方式就不够灵活。而Cobbler正是为了解决此问题而设计的。如果只是用pxe+kickstart方式推荐阅读参考文献11

注2：这是对pxe的二次封装，在pxe当中，我们还需要手动的去部署dhcp和tftp等相关服务。在cobbler中，相关的配置、软件、服务等都被集成在了一起，管理起来能够更简单。4

注3：cobbler装机系统是较早前kickstart的升级版，优点比较容易配置，还自带web界面比较易于管理，不足在于中文资料较少。和 Kickstart不同的是，使用cobbler不会因为在局域网中启动了dhcp而导致有些机器因为默认从pxe启动在重启服务器后加载tftp内容导 致启动终止。通过配置cobbler自动部署DHCP、TFTP、HTTP，在安装过程中加载kiskstart无人值守安装应答文件实现无人值守。从客户端使用PXE引导启动安装。

#### 3.2 Cobbler工作流程

<img src="https://img-blog.csdnimg.cn/20190308172051178.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70"  />



***流程解释***

1. client裸机配置了从网络启动后，开机后会广播包请求DHCP服务器（cobbler server）发送其分配好的一个IP
2. DHCP服务器（cobbler server）收到请求后发送responese，包括其ip地址
3. client裸机拿到ip后再向cobbler server发送请求OS引导文件的请求
4. cobbler server告诉裸机OS引导文件的名字和TFTP server的ip和port
5. client裸机通过上面告知的TFTPserver地址通信，下载引导文件
6. client裸机执行该引导文件，确定加载信息，`选择要安装的os，`期间会再向cobbler server请求kickstart文件和os image
7. cobbler server发送请求的kickstart和os iamge.
8. client裸机加载kickstart文件 .client裸机接收os image，安装该os image

***主要服务***

1. DHCP服务分配IP地址
2. Client（获取IP地址、Next_server IP地址）
3. Next_server（获取启动内核、initrd等文件）
4. tftp （PXE引导文件、启动Cobbler选择界面）
5. kickstart （确定加载项，根据NFS，httpd，ftp等共享）

#### 3.3 Cobbler各组件之间关系

![](https://img-blog.csdnimg.cn/20190308172131162.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

#### 3.4 Cobbler安装包介绍

```
软件包：
cobbler          #cobbler程序包
cobbler-web      #cobbler的web服务包
pykickstart      #cobbler检查kickstart语法错误
httpd            #Apache web服务
dhcp             #Dhcp服务
tftp             #tftp服务
xinetd			 #超级守护进程服务

配置文件：
/etc/cobbler                        # 配置文件目录
/etc/cobbler/settings               # cobbler主配置文件
/etc/cobbler/dhcp.template          # DHCP服务的配置模板
/etc/cobbler/tftpd.template         # tftp服务的配置模板
/etc/cobbler/rsync.template         # rsync服务的配置模板
/etc/cobbler/iso                    # iso模板配置文件目录
/etc/cobbler/pxe                    # pxe模板文件目录
/etc/cobbler/power                  # 电源的配置文件目录
/etc/cobbler/users.conf             # Web服务授权配置文件
/etc/cobbler/users.digest           # web访问的用户名密码配置文件
/etc/cobbler/dnsmasq.template       # DNS服务的配置模板
/etc/cobbler/modules.conf           # Cobbler模块配置文件
/var/lib/cobbler                    # Cobbler数据目录
/var/lib/cobbler/config             # 配置文件
/var/lib/cobbler/kickstarts         # 默认存放kickstart文件
/var/lib/cobbler/loaders            # 存放的各种引导程序
/var/www/cobbler                    # 系统安装镜像目录
/var/www/cobbler/ks_mirror          # 导入的系统镜像列表
/var/www/cobbler/images             # 导入的系统镜像启动文件
/var/www/cobbler/repo_mirror        # yum源存储目录
/var/log/cobbler                    # 日志目录
/var/log/cobbler/install.log        # 客户端系统安装日志
/var/log/cobbler/cobbler.log        # cobbler日志
```

#### 3.5 Cobbler设计模式

- 发行版(distro) : 表示一个操作系统。它承载了内核和initrd的信息，以及内核参数等其他数据。
- 存储库(repository) : 保存一个yum或rsync存储库镜像信息。
- 配置文件(profile) :包含一个发行版(distro)、一个kickstart文件以及可能的存储库(repository)还包含更多特定的内核参数及其他数据。
- 系统(system) : 表示要配给的机器，它包含一个配置文件或一个镜像，还包含IP和MAC地址、电源管理(地址、凭据、类型)以及更专业的数据等信息。
- 镜像(image) : 可替换一个包含不属于此类别的文件发行版对象，(例如: 无法分为内核和initrd的对象)

#### 3.6 Cobbler Units 软件包及配置流程

- cobbler
- cobbler-web

**大体配置流程如下：**

1. 安装cobbler,依据cobbler check检查结果，对settings主配置文件，进行相关修正设置；
2. 启动依赖服务:httpd、cobbler服务，使用cobbler sync同步配置
3. 配置cobbler所依赖的服务:
   ** dhcp : ISC dhcpd dnsmasq（必需服务，选其中一种管理即可）
   ** dns : bind dnsmqsq(可选)
   ** rsync : rsync（必需服务）
   ** tftp : in.tftpd(tftp-server) cobbler自带的tftp（必需服务，选其中一种管理即可）
4. 配置cobbler组件

#### 3.7 Cobbler命令简介

```
cobbler check 核对当前设置是否有问题
cobbler list 列出所有的cobbler元素
cobbler report列出元素的详细信息
cobbler sync 同步配置到数据目录,更改配置最好都要执行下
cobbler reposync 同步yum仓库
cobbler distro 查看导入的发行版系统信息
cobbler system 查看添加的系统信息
cobbler profile查看配置信息
```

## 四、服务选型及介绍

###### 4.1 DHCP服务

由于我们是实现自动化批量安装部署，所以，能够与其他主机通信是前提，而要想获取IP并实现通信，我们必须要有DHCP服务器为大量的主机提供ip地址才行。

DHCP就是动态主机设置协议，主要是为客户端分发IP，并且是自动分发IP的，一台主机通过DHCP获取的地址是动态的，每次获取的地址都有可能不同，改地址是DHCP服务器暂时分配给用户使用的，当主机关机之后则会返回这个ip地址，此时如果有其他用户请求，DHCP服务器则会将该IP地址分配给他。局域网中的每台主机都可以充当DHCP服务器，只要我们安装DHCP服务，并做相应的配置即可，这里的配置主要是子网的配置，配置其他主机能使用IP地址的范围，例如：配置子网为192.168.14.0，该子网内主机获取IP的范围为192.168.14.1~192.168.14.100。

那么我们就可以打开DHCP的配置文件/etc/dhcp/dhcpd.conf做如下配置：

```
subnet 192.168.14.0 netmask 255.255.255.0 {
        range 192.168.25.50 192.168.25.100;
        next-server 192.168.25.107;     # 指明tftp服务器的地址
        filename "pxelinux.0";          # 指定PXE文件
}
```

###### 4.2 HTTP服务

由于我们要获取安装系统服务的yum源以及内核文件，虚拟根文件，这些文件都是大文件，在传输时我们必须保证其能够安全传输，所以我们选择了HTTP服务，当然了，选择FTP服务也是可以的。

HTTP是Hyper Text Transfer Protocol(超文本传输协议)的缩写。是互联网上广泛试用的协议。是用于从WWW服务器传输超文本到本地浏览器的传输协议。它可以使浏览器更加高效，使网络传输减少。它不仅保证计算机正确快速地传输超文本文档，还确定传输文档中的哪一部分等。HTTP包含命令和传输信息，不仅可用于Web访问，也可以用于其他因特网/内联网应用系统之间的通信，从而实现各类应用资源超媒体访问的集成。

###### 4.3 TFTP服务

TFTP是一种文件传输服务，用于服务器与客户端进行文件的传输，不过他只能进行简单的文件传输，这个服务开销不大，所以并不能进行大文件的传输，多用于小文件的传输。他没有FTP那么强大，但是TFTP使用UDP协议传输数据，有些时候比FTP更加方便，它所监听的端口为69。由于我们是在局域网中，系统相对安全，而提供的数据也不是很大，所以TFTP是实现PXE的不二选择。


## 五、功能实现

#### 5.1 环境准备

1台linux服务器作为Server服务器端
1台新客户端服务器或者虚拟机新分配服务器作为Client客户端（待装系统）

```
# 查看系统版本
[root@vm1 ks_mirror]# cat /etc/redhat-release   
CentOS Linux release 7.6.1810 (Core)

# 查看内核版本
[root@vm1 ks_mirror]# uname -r 					
3.10.0-957.el7.x86_64

# selinux处于关闭状态

 sed -i 's/SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
 setenforce 0

# 防火墙处于关闭状态
[root@vm1 ks_mirror]# systemctl status firewalld.service  
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
 
 # 本机IP地址    
[root@vm1 ks_mirror]# hostname -i  
192.168.10.2 

 # yum源说明：
 如果你的机器可以链接互联网（选用此种方法）
# curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

如果你的机器不能上外网，可以选用部署nexus yum源私服，或者自己上传软件包，然后使用createrepo 工具创建本地yum源。
nexus私服部署参考：https://blog.csdn.net/chenyantao566/article/details/118369197
```

***注意：Server端因为也承担DHCP服务，由于做DHCP服务的主机的IP地址必须固定，所以我们要先配置服务器的IP地址（IP为示例IP）***

```
[root@vm1 ks_mirror]# cat /etc/sysconfig/network-scripts/ifcfg-eth1
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
IPADDR=192.168.10.2
NETMASK=255.255.255.0
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
NAME=eth1
UUID=2daced69-97f9-32b7-8143-72a4a8f69e51
DEVICE=eth1
ONBOOT=yes
[root@vm1 ks_mirror]# 
```

#### 5.2 服务器端部署

###### 5.2.1 安装EPEL源

```
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum install epel-release
yum repolist
yum makecache
```

以上需联网环境，如果没有可以自行下载拷贝过来后安装

###### 5.2.3 安装Cobbler并修改Setting主配置文件

首先安装Cobbler units和所需要的服务

```
yum install cobbler cobbler-web pykickstart httpd dhcp tftp xinetd --showduplicates
```

然后再改配置文件，主要是修改配置文件中默认的值：

- 修改默认的Server IP

- 修改默认的next_server IP

- 配置dhcp\dns由cobbler管理

- 将pxe_just_once改为1，防止误重装系统
  该选项作用:
  *防止机器循环安装配置始终从网络引导
  *激活此选项，机器回传Cobbler安装完成
  *Cobbler将系统对象的netboot标志更改为false，强制要求机器从本地磁盘引导。

- 设置Cobbler系统默认密码

- 配置rsync、tftp服务，由cobbler管理，并要保证xinetd服务为开机自启动状态，因rsync、tftp服务由xinetd服务统一管理
  备注：

  （1）默认情况下，Cobbler安装完成后，会自己去管理tftp服务，因manage_tftp和managed_tftpd的值默认为1，所以不需要手动设置；

  （2）要想让Cobbler来管理rsync、tftp服务，只要保证各自服务已安装，并设置为开机自启动即可；

  （3）此外，需要保证xinetd服务为开机自启动状态，因rsync、tftp服务由xinetd服务统一管理。

  ```
  cp /etc/cobbler/settings{,.bak}
  
  sed -i "/^ServerName.*/s/^ServerName.*/ServerName 192.168.10.2/" /etc/httpd/conf/httpd.conf
  
  sed -i 's/server: 127.0.0.1/server: 192.168.10.2/' /etc/cobbler/settings
  
  sed -i 's/next_server: 127.0.0.1/next_server: 192.168.10.2/' /etc/cobbler/setting
  
  sed -i 's/manage_dhcp: 0/manage_dhcp: 1/' /etc/cobbler/settings
  #DNS管理可选，看需求
  sed -i 's/manage_dns: 0/manage_dns: 1/' /etc/cobbler/settings
  
  sed -i 's/pxe_just_once: 0/pxe_just_once: 1/' /etc/cobbler/settings
  
  #设置系统密码 （加密）
  # sed -ri "/default_password_crypted/s#(.*: ).*#\1\"`openssl passwd -1 -salt 'root' 'root'`\"#" /etc/cobbler/settings
  
  # cat /etc/cobbler/settings.bak | grep default_password_crypted
  default_password_crypted: "$1$root$9gr5KxwuEdiI80GtIzd.U0"
  
     # openssl passwd -1 -salt 'root' 'root' （以root为填充字符）
     
  sed -i '/diable/ s/yes/no/' /etc/xinetd.d/rsync
  sed -i '/diable/ s/yes/no/' /etc/xinetd.d/tftp 
  
  #设置开机自启动
   systemctl start httpd
   systemctl enable httpd
   systemctl start cobblerd
   systemctl enable cobblerd
   systemctl start tftp
   systemctl enable tftp
   systemctl start xinetd
   systemctl enable xinetd
   systemctl status xinetd
  ```

  ###### 5.2.5 Cobbler自检

  检查还有哪些步骤需要做，按提示逐一解决即可，需要注意的就是：需要在cobblerd和httpd启动的情况下检查，所以上述5.2.4需要先做。
  为显示更多的错误内容做示范，我找了其他博主的检查记录[7](https://blog.csdn.net/arnolan/article/details/88357188?ops_request_misc=%7B%22request%5Fid%22%3A%22162505445116780357268962%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=162505445116780357268962&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_v2~rank_v29-1-88357188.pc_search_result_cache&utm_term=自动化装机服务详细介绍&spm=1018.2226.3001.4187#fn7)，我们逐一来看（*实际上如果你按照本文的操作顺序做的话其中一些问题是不会出现的*）：

  ```
  # 执行Cobbler check 检查目前环境还缺少哪些东西
  [root@localhost ~]#cobbler check
  The following are potential configuration items that you may want to fix:
  1 : The 'server' field in /etc/cobbler/settings must be set to something other than localhost, or kickstarting features will not work.  This should be a resolvable hostname or IP for the boot server as reachable by all machines that will use it.
  
  2 : For PXE to be functional, the 'next_server' field in /etc/cobbler/settings must be set to something other than 127.0.0.1, and should match the IP of the boot server on the PXE network.
  
  3 : change 'disable' to 'no' in /etc/xinetd.d/tftp
  
  4 : some network boot-loaders are missing from /var/lib/cobbler/loaders, you may run 'cobbler get-loaders' to download them, or, if you only want to handle x86/x86_64 netbooting, you may ensure that you have installed a *recent* version of the syslinux package installed and can ignore this message entirely.  Files in this directory, should you want to support all architectures, should include pxelinux.0, menu.c32, elilo.efi, and yaboot. The 'cobbler get-loaders' command is the easiest way to resolve these requirements.
  
  5 : enable and start rsyncd.service with systemctl
  
  6 : debmirror package is not installed, it will be required to manage debian deployments and repositories
  
  7 : The default password used by the sample templates for newly installed machines (default_password_crypted in /etc/cobbler/settings) is still set to 'cobbler' and should be changed, try: "openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'" to generate new one
  
  8 : fencing tools were not found, and are required to use the (optional) power management features. install cman or fence-agents to use them
  
  Restart cobblerd and then run 'cobbler sync' to apply changes.
  ```

  ***错误1-2：都是提示要修改配置文件/etc/cobbler/settings，在配置文件中的server 字段、next_server不能是localhost或者127.0.0.1，需要你具体的服务器IP地址。故我们修改配置文件即可，修改配置有三种方式，具体用哪种看个人习惯，改之前可以备份一下***

  ```
  cp /etc/cobbler/settings{,.ori} *#备份*
  ```

  （1）直接vim打开配置文件修改保存即可；

  ```
  vim /etc/cobbler/settings 
  #将272行改为 next_server: 192.168.134.132（你的ip地址）
  #将384行改为 server: 192.168.134.132
  ```

  （2）使用sed命令修改配置并查看；

  ```
  sed -i 's/server: 127.0.0.1/server: 172.16.8.240/' /etc/cobbler/settings && grep -n 'server' /etc/cobbler/settings
  sed -i 's/next_server: 127.0.0.1/next_server: 172.16.8.240/' /etc/cobbler/settings  && grep -n 'next_server' /etc/cobbler/settings
  ```

  （3）命令动态更新配置

  从Cobbler 2.4开始，有一个重要的功能，就是让你不需要手工编辑配置setting配置文件，直接使用命令修改相关配置，默认这个功能是不启用，启用需要进行一下配置：

  ```
  # cd /etc/cobbler/
  # cp -af settings{,.default}
  # sed -i '/^allow_dynamic_settings:/ s/0/1/' settings
  # service cobblerd restart
  ```

  *建议采用修改/etc/cobbler/settings配置文件的方式修改配置选项*
  *在采用命令方式动态更新配置时，Cobbler会将配置文件中带"#"注释的行全部删除*
  然后再开始修改配置：

  ```
  # cobbler setting edit --name=server --value=172.16.100.7
  # cobbler setting edit --name=next_server --value=172.16.100.7
  ```

  ***错误3：修改配置文件/etc/xinetd.d/tftp，关闭禁用，即开启tftp服务。同上，找到这个配置文件修改即可，这里我们采用sed命令方式***

  ```
  sed -i '/disable/ s/yes/no/' /etc/xinetd.d/tftp
  ```

  ***错误4: 找不到network boot-loaders引导文件（启动菜单），需要下载。如果当前节点可以访问互联网，执行“cobbler get-loaders”命令即可；***

  ```
  cobbler get-loaders
  #拷贝一份 可选
  tar xfP cobbler_load_for_CentOS7.tar.gz
  ```

  如果无法联网，需要安装syslinux程序包，此处我们安装cobbler时已经安装好了syslinux，直接复制/usr/share/syslinux/{pxelinux.0,memu.c32}等文件至/var/lib/cobbler/loaders/目录中；

  ```
  cp /usr/share/syslinux/{pxelinux.0,menu.c32} /var/lib/cobbler/loaders/
  ```

  不过需要注意的就是，不连internet，只复制menu.c32,pxelinux.0两个文件的话，只支持安装x86/x86_64架构的系统，所以建议还是执行cobbler get-loaders，将所需的文件都下载到 /var/lib/cobbler/loaders来

  ***错误5：需要开启rsyncd.service服务***

  ```
  systemctl restart rsyncd
  systemctl enable rsyncd
  ```

  ***错误6：未安装debmirror包***

  ```
  yum -y install debmirror cman
  ```

  ***错误7：密码没改，按照提示方式"openssl passwd -1 -salt ‘random-phrase-here’ ‘your-password-here’"创建一个新密码，然后以命令方式动态修改密码***

  ```
  # openssl passwd -1 -salt `openssl rand -hex 4` 'redhat'
  $1$fe4c277f$tbAmxXGSIA7cc/AXLsQVd.
  # cobbler setting edit --name=default_password_crypted --value='$1$fe4c277f$tbAmxXGSIA7cc/AXLsQVd.'
  ```

  当然，也可以用sed命令修改密码，就是匹配写起来费劲

  ```
  sed -ri "/default_password_crypted/s#(.*: ).*#\1\"`openssl passwd -1 -salt 'openssl rand -hex 4' 'redhat'`\"#" /etc/cobbler/settings
  ```

  ***错误8：电源管理工具fencing tools没找到，如果需要电源管理特性的话，则需要安装cman及fence-agents包***

  ```
  # yum -y install cman fence-agents
  ```

  ***错误9：file /etc/xinetd.d/rsync does not exist #没有这个文件***

  ls命令检查下该文件是否真的不在，实际上/etc/xinetd.d/rsync文件存在，此条忽略，应是个程序BUG，可以忽略

  ***错误10：comment ‘dists’ on /etc/debmirror.conf for proper debian support；comment ‘arches’ on /etc/debmirror.conf for proper debian support，这是错误6中安装debmirror包后衍生出的错误，根据提示，在 /etc/debmirror.conf配置文件中注释掉这两行选项即可***

   

  ```
  # vim /etc/debmirror.conf
  ....
  #@dists="sid"
  .... 
  #@arches="i386
  ....
  
  ```

  ***错误11：change ‘disable’ to ‘no’ in /etc/xinetd.d/rsync***

  ```
  sed -i '/disable/ s/yes/no/' /etc/xinetd.d/rsync && grep -n 'disable' /etc/xinetd.d/rsync
  systemctl enable rsync
  ```

  ***错误12：selinux未禁用的话也会报错，不过因方案准备时我们已经关闭，所以不会遇到，如果遇到报错则按如下关闭即可***

  ***错误13：ksvalidator was not found , install pykickstart
  需要安装ks文件验证支持包***

  ```
  # yum -y install pykickstart
  ```

  检查更新完配置后重启下服务，并同步cobbler数据

  ```
  systemctl restart httpd.service		# 即service httpd restart   
  systemctl restart cobblerd.service	# 即service cobblerd restart
  systemctl restart dhcpd.service
  systemctl restart rsyncd.service
  systemctl restart tftp.socket      
  cobbler sync
  ```

######       5.2.6 配置DHCP

 

```
vim /etc/cobbler/dhcp.template
subnet 192.168.10.0 netmask 255.255.255.0 {
     option routers             192.168.10.2;
     option domain-name-servers 192.168.10.2;
     option subnet-mask         255.255.255.0;
     range dynamic-bootp        192.168.10.100 192.168.10.254;
     default-lease-time         21600;
     max-lease-time             43200;
     next-server                $next_server;
     class "pxeclients" {
          match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
          if option pxe-system-type = 00:02 {
                  filename "ia64/elilo.efi";
          } else if option pxe-system-type = 00:06 {
                  filename "grub/grub-x86.efi";
          } else if option pxe-system-type = 00:07 {
                  filename "grub/grub-x86_64.efi";
          } else if option pxe-system-type = 00:09 {
                  filename "grub/grub-x86_64.efi";
          } else {
                  filename "pxelinux.0";
          }
     }

}
....
```

完了再重启下服务并检查端口、同步数据：

```
systemctl restart cobblerd
ss -luntp|grep dhcp	# 检查下端口，局域网内只能有1台DHCP服务器
cobbler sync
```

至此，我们就已经完成cobbler的安装，接下来我们要开始配置自动化装机的标准了

##### 5.3 服务器端配置

这部分的配置可以使用Cobbler的web界面进行配置，也可以继续在shell中使用命令行进行配置。我们逐一来说，具体用哪个看个人习惯：

5.3.1 方式一：web界面配置
5.3.1.1 打开WEB登录页面
在刚配置完的服务器端打开：https://192.168.10.2/cobbler_web/
用户名：cobbler 密码：cobbler
注意：CentOS7中cobbler只支持https访问。

![](https://img-blog.csdnimg.cn/20190313095019249.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)



cobbler web 主界面说明

![](https://img-blog.csdnimg.cn/20190313115554478.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

这一步可能会出现内部错误：Internal Server Error

![](https://img-blog.csdnimg.cn/20190314153426324.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

可以检查下错误日志：

```
[root@Cobbler ~]# tail -f /var/log/httpd/ssl_error_log
[Mon Jan 07 16:24:53.363029 2019] [:error] [pid 3383] [remote 10.0.0.1:212]     mod = importlib.import_module(self.SETTINGS_MODULE)
[Mon Jan 07 16:24:53.363032 2019] [:error] [pid 3383] [remote 10.0.0.1:212]   File "/usr/lib64/python2.7/importlib/__init__.py", line 37, in import_module
[Mon Jan 07 16:24:53.363084 2019] [:error] [pid 3383] [remote 10.0.0.1:212]     __import__(name)
[Mon Jan 07 16:24:53.363089 2019] [:error] [pid 3383] [remote 10.0.0.1:212]   File "/usr/share/cobbler/web/settings.py", line 89, in <module>
[Mon Jan 07 16:24:53.363097 2019] [:error] [pid 3383] [remote 10.0.0.1:212]     from django.conf.global_settings import TEMPLATE_CONTEXT_PROCESSORS
[Mon Jan 07 16:24:53.363124 2019] [:error] [pid 3383] [remote 10.0.0.1:212] ImportError: cannot import name TEMPLATE_CONTEXT_PROCESSORS
```

这部经过网友排查是Django的版本问题，排查过程详见参考文献10[10](https://blog.csdn.net/arnolan/article/details/88357188?ops_request_misc=%7B%22request%5Fid%22%3A%22162505445116780357268962%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=162505445116780357268962&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_v2~rank_v29-1-88357188.pc_search_result_cache&utm_term=自动化装机服务详细介绍&spm=1018.2226.3001.4187#fn10): [Cobbler 登录web界面提示报错“Internal Server Error”](https://blog.51cto.com/12643266/2339793?source=dra)

https://blog.51cto.com/u_12643266/2339793

但是比较操蛋的就是：对于我而言通过上面的操作之后依然没有解决这个问题，后面经不断排查发现是python版本的问题，我的linux服务器默认是用的python 3.6的版本，需要切换Python版本，并重新在2.7版本下又重新安装了一次pip包，然后再安装django，才解决了这个问题。希望大家注意，具体过程可参考我的这边博客：https://blog.csdn.net/arnolan/article/details/88555865

##### 5.3.1.2 导入镜像

这一步，我们要先在虚拟机设置中选择镜像并挂载
（1）首先，我们在VMware虚拟机上添加上镜像

![](https://img-blog.csdnimg.cn/20190313144626260.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

（2）然后挂载上镜像

（3）在Cobbler web中导入镜像

选择Import DVD 输入Prefix(文件前缀)，Arch（版本），Breed（品牌），Path(要从什么地方导入)
在导入镜像的时候要注意路径，防止循环导入。
信息配置好后，点击run，即可进行导入。

![](https://img-blog.csdnimg.cn/20190313100145814.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

导入过程使用rsync进行导入，我们可以用以下命令查看进展，这三个进程消失表示导入完毕：

```
[root@Cobbler mnt]# ps -ef |grep rsync
root      25266   1582 15 17:30 ?        00:00:06 rsync -a /mnt/ /var/www/cobbler/ks_mirror/CentOS6.8-x86_64 --progress
root      25267  25266  0 17:30 ?        00:00:00 rsync -a /mnt/ /var/www/cobbler/ks_mirror/CentOS6.8-x86_64 --progress
root      25268  25267 11 17:30 ?        00:00:05 rsync -a /mnt/ /var/www/cobbler/ks_mirror/CentOS6.8-x86_64 --progress

```



```
我们也可以在web界面的events菜单下查看具体日志，可以发现有running进程

```

![](https://img-blog.csdnimg.cn/20190313100723254.png)

可以查看下导入完成后生成的文件夹：

```
[root@Cobbler ks_mirror]# pwd
/var/www/cobbler/ks_mirror

[root@Cobbler ks_mirror]# ls
CentOS7.4-x86_64  config

```



##### 5.3.1.3 编写kickstart文件

![](https://img-blog.csdnimg.cn/20190313103338818.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)



![](https://img-blog.csdnimg.cn/20190313103346996.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

创建并编辑完成后点击Save进行保存，kickstart内容视不同的操作系统不同，每种类型保存一种kickstart文件。kickstart文件的生成可以直接修改模板文件，也可以运行system-config-kickstart命令后图形化界面中设置，详见附录1



##### 5.3.1.4 系统及网络设置

（1）首先，创建一个新的系统system

![](https://img-blog.csdnimg.cn/20190313104317573.png)

（2）定义新系统的配置，
先在General选项卡中设置系统名、选择镜像、选择环境、选择kickstart文件

![](https://img-blog.csdnimg.cn/20190313104918454.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

再在Netwarking（Global）中配置全局网络信息，包括主机名、网关、DNS

![](https://img-blog.csdnimg.cn/2019031310535138.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

再配置网卡信息，eth0，eth1，需要注意，选择static静态

![](https://img-blog.csdnimg.cn/20190313105722665.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20190313114835518.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

PS：内网网卡不要设置网关，否则会导致无法上网

以上的所有配置完成后，点击Save进行保存

另外注意MAC地址不要填错了，VMware workstation中查看虚拟机mac地址的方法如下：在虚拟机设置中

![](https://img-blog.csdnimg.cn/20190313115416111.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

##### 5.3.1.5 检查与同步

![](https://img-blog.csdnimg.cn/20190313120003124.png)

##### 5.3.1.6 修改PXE菜单（可选，根据需求）

默认的情况下PXE的启动项是Local（如下图）

![](https://img-blog.csdnimg.cn/20190314174838244.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

由于根据无人值守安装的需求，无需人工干预，需要自动安装，这时候就要需要将local从启动项删除即可。修改方法如下:

首先找到PXE加载的菜单选项在哪，路径"/var/lib/tftpboot/pxelinux.cfg"下找到"default"文件，内容如下:

```
[root@cobbler-node ~]# cd /var/lib/tftpboot/pxelinux.cfg/
[root@cobbler-node pxelinux.cfg]# cp default default.bak
[root@cobbler-node pxelinux.cfg]# cat default
DEFAULT menu
PROMPT 0
MENU TITLE Cobbler | http://cobbler.github.io/
TIMEOUT 200
TOTALTIMEOUT 6000
ONTIMEOUT local
 
LABEL local
        MENU LABEL (local)
        MENU DEFAULT
        LOCALBOOT -1
 
LABEL centos7.2-Minimal-x86_64
        kernel /images/centos7.5-x86_64/vmlinuz
        MENU LABEL centos7.5-x86_64
        append initrd=/images/centos7.5-x86_64/initrd.img ksdevice=bootif lang=  text biosdevname=0 net.ifname=0 kssendmac  ks=http://172.16.60.222/cblr/svc/op/ks/profile/centos7.5-x86_64
        ipappend 2
 
MENU end

```

如上，可以看出MENU菜单有俩个选项。这里删除“LABEL local”的内容，并修改“ONTIMEOUT”值为我们想要的启动项即可，如下:

```
[root@cobbler-node pxelinux.cfg]# vim default
DEFAULT menu
PROMPT 0
MENU XXXXXXXX | Cloud Of XXXXXX
TIMEOUT 200
TOTALTIMEOUT 6000
ONTIMEOUT centos7.2-Minimal-x86_64
 
LABEL centos7.2-Minimal-x86_64
        kernel /images/centos7.5-x86_64/vmlinuz
        MENU LABEL centos7.5-x86_64
        append initrd=/images/centos7.5-x86_64/initrd.img ksdevice=bootif lang=  text biosdevname=0 net.ifname=0 kssendmac  ks=http://172.16.60.222/cblr/svc/op/ks/profile/centos7.5-x86_64
        ipappend 2
 
 
MENU end

```

如上图，只留下了"LABELcentos7.2-Minimal-x86_64"这一个启动项，"ONTIMEOUT “改为了"centos7.2-Minimal-x86_64”，"MENUTITLE"可以修改成自定义内容。修改后保存即可，不要重启cobblerd服务，也不要执行"cobbler sync"同步。修改后的PXE启动页面如下:
![](https://img-blog.csdnimg.cn/20190314175021244.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

默认的20秒超时一过就可以进入该选项进行自动安装。这样就可以做到了无人工干预的自动无人值守安装需求。

对于单一操作系统的可以这样操作哈，一般多操作系统可选的没必要~

##### PS：如何让cobbler下载yum源？

可通过cobbler web页面导入本地或者公网yum源

![](https://img-blog.csdnimg.cn/20190313143525231.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20190313143545594.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

然后检查下：

```
[root@CentOS6 ~]# cd /var/www/cobbler/repo_mirror/
[root@CentOS6 repo_mirror]# ls
oldboyedu

```

如使用公网yum源：

![](https://img-blog.csdnimg.cn/20190313143720218.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

最后，装系统的时候如何关联到本地yum源呢？在Profiles中选择好可用的yum源并保存即可

![](https://img-blog.csdnimg.cn/20190313143831792.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

至此，WEB方式部署完成

##### 5.3.2 方式二：命令行方式部署

以上很多web界面操作也可以通过命令行方式执行，部署完成后打开web界面即可使用~

###### 5.3.2.1 挂载镜像

distro（发行版本）：可使用distro命令或者import导入发行版镜像
Cobbler上，distro可以有多个；同一个distor之上可定义同个profile,每个profile使用不同的kicstart文件

```
# mkdir -p /mnt/CentOS/6.5
# mount -o loop /root/CentOS-6.5-x86_64-bin-DVD1.iso /mnt/CentOS/6.5/
# cobbler import --name=CentOS-6.5-x86_64 --path=/mnt/CentOS/6.5
```

###### 5.3.2.2 准备kickstart文件

1、通过工具制作

```
yum install system-config-kickstart --showduplicate  
```



```
system-config-kickstart
```

![](https://img-blog.csdnimg.cn/20190313152018395.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20190313152038326.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20190313152126144.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)



![](https://img-blog.csdnimg.cn/20190313152137316.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20190313152150868.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

![](https://img-blog.csdnimg.cn/20190313152203380.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2Fybm9sYW4=,size_16,color_FFFFFF,t_70)

在所有选项设置完成后，点击左上角的“文件”选项就可生成一个文件。将该文件移动到已共享出去的目录里，供他人读取。或者直接拷贝到Cobbler web界面中。

2、手动编写

```
vim /var/lib/cobbler/kickstarts/CentOS-7-x86_64.cfg  #保证和前面的系统名称相同
```

可以复制/root目录下的anaconda-ks.cfg文件加以修改，找一台安装按照你的需求安装好的机器。 

```
[ root@vinsent html ]#cp /root/anaconda-ks.cfg ksdir/ks7.cfg
[ root@vinsent html ]#vim ksdir/ks7.cfg
....
[ root@vinsent html ]#chmod +r ksdir/ks7.cfg    # "这里的文件需要加读权限，非常重要"
[ root@vinsent html ]#cat ksdir/ks7.cfg         # centos 7的kickstart文件
```

这是自己手动修改，也可以从网上复制模板看实际情况自己修改后直接拿来用，下面附上CentOS 7和CentOS 6的版本供参考

##### CentOS-7-x86_64.cfg参考模板

```
#CentOS7的ks文件 CentOS-7-x86_64.cfg
# Cobbler for Kickstart Configurator for CentOS 7 by yao zhang
install
url --url=$tree
text
lang en_US.UTF-8
keyboard us
zerombr
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
#Network information
$SNIPPET('network_config')
#network --bootproto=dhcp --device=eth0 --onboot=yes --noipv6 --hostname=CentOS7
timezone --utc Asia/Shanghai
authconfig --enableshadow --passalgo=sha512
rootpw  --iscrypted $default_password_crypted
clearpart --all --initlabel
part /boot --fstype xfs --size 1024
part swap --size 1024
part / --fstype xfs --size 1 --grow
firstboot --disable
selinux --disabled
firewall --disabled
logging --level=info
reboot
%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end
%packages
@^minimal
@compat-libraries
@core
@debugging
@development
bash-completion
chrony
dos2unix
kexec-tools
lrzsz
nmap
sysstat
telnet
tree
vim
wget
%end
%post
systemctl disable postfix.service
%end
```

##### CentOS-6.8-x86_64.cfg参考模板

```
# Cobbler for Kickstart Configurator for CentOS 6.8 by yao zhang
install
url --url=$tree
text
lang en_US.UTF-8
keyboard us
zerombr
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
$SNIPPET('network_config')
timezone --utc Asia/Shanghai
authconfig --enableshadow --passalgo=sha512
rootpw  --iscrypted $default_password_crypted
clearpart --all --initlabel
part /boot --fstype=ext4 --asprimary --size=200
part swap --size=1024
part / --fstype=ext4 --grow --asprimary --size=200
firstboot --disable
selinux --disabled
firewall --disabled
logging --level=info
reboot
%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end
%packages
@base
@compat-libraries
@debugging
@development
tree
nmap
sysstat
lrzsz
dos2unix
telnet
%end
%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end
%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('RedHat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps
%end
```

