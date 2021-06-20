# nesux

nexus介绍

私服是指私有服务器,是假设在局域网的一种特殊的远程仓库,目的是代理远程仓库及部署第三方构建.有了私服之后,当maven需要下载构件时,直接请求私服,私服上存在则下载到本地仓库;否则,私服请求外部的远程仓库,将构件下载到私服,在提供给本地仓库下载.

nexus是一个强大的maven仓库管理器,它极大的简化了本地内部仓库的维护和外部仓库的访问.
nexus是一套开箱即用的系统不需要数据库,它使用文件系统加Lucene来组织数据
nexus使用ExtJS来开发界面,利用Restlet来提供完整的REST APIs,通过IDEA和Eclipse集成使用
nexus支持webDAV与LDAP安全身份认证.
nexus提供了强大的仓库管理功能,构件搜索功能,它基于REST,友好的UI是一个extjs的REST客户端,占用较少的内存,基于简单文件系统而非数据库.
好处

1）加速构建；
2）节省带宽；
3）节省中央maven仓库的带宽；
4）稳定（应付一旦中央服务器出问题的情况）；
5）控制和审计；
6）能够部署第三方构件；
7）可以建立本地内部仓库；
8）可以建立公共仓库
这些优点使得Nexus日趋成为最流行的Maven仓库管理器

# CentOS7.x上用nexus搭建yum仓库

# 一、实验背景

在生产环境中，我们不可能所有的服务器都能连接外网更新rpm包，比较理想的环境是：有一台Linux服务器可以连接外网，剩余的服务器通过这台yum服务器更新。

传统的做法是先把包下载到内网中的yum服务器上，然后通过createrepo命令生成本地仓库，其余服务器通过HTTP/FTP访问这个链接，这种做法比较费时费事。有没有一种比较好的方式，让我们直接通过这台服务器代理连接到公网的163、阿里云yum仓库呢?

这就是本次介绍的Nexus代理，无论你的客户机是CentOS6还是CentOS7又或者是Ubuntu，不论你是想用yum还是pip又或者是npm包管理器，Nexus都能满足你的需求。

你只需要将nexus放到能连外网的服务器上，通过nexus暴露服务就可以了。

# 二、实验环境

操作系统：CentOS Linux release 7.6.1810 (Core)

nexusServer： 192.168.100.188

yumClient：      192.168.100.241

# 三、安装nexus，创建yum私有仓库

**在nexusServer服务器**

关闭selinux

setenforce 0

sed -i 's/SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

 

安装docker

[root@nexusServer ~]# yum -y install  yum-utils device-mapper-persistent-data lvm2

[root@nexusServer ~]# ll /etc/yum.repos.d/CentOS-*
-rw-r--r--. 1 root root 1664 11月 23 2018 /etc/yum.repos.d/CentOS-Base.repo
-rw-r--r--. 1 root root 1309 11月 23 2018 /etc/yum.repos.d/CentOS-CR.repo
-rw-r--r--. 1 root root  649 11月 23 2018 /etc/yum.repos.d/CentOS-Debuginfo.repo
-rw-r--r--. 1 root root  314 11月 23 2018 /etc/yum.repos.d/CentOS-fasttrack.repo
-rw-r--r--. 1 root root  630 11月 23 2018 /etc/yum.repos.d/CentOS-Media.repo
-rw-r--r--. 1 root root 1331 11月 23 2018 /etc/yum.repos.d/CentOS-Sources.repo
-rw-r--r--. 1 root root 5701 11月 23 2018 /etc/yum.repos.d/CentOS-Vault.repo

[root@nexusServer ~]# yum-config-manager  --add-repo    https://download.docker.com/linux/centos/docker-ce.repo

[root@nexusServer ~]# ll --time-style=long-iso /etc/yum.repos.d/*.repo
-rw-r--r--. 1 root root 1664 2018-11-23 21:16 /etc/yum.repos.d/CentOS-Base.repo
-rw-r--r--. 1 root root 1309 2018-11-23 21:16 /etc/yum.repos.d/CentOS-CR.repo
-rw-r--r--. 1 root root  649 2018-11-23 21:16 /etc/yum.repos.d/CentOS-Debuginfo.repo
-rw-r--r--. 1 root root  314 2018-11-23 21:16 /etc/yum.repos.d/CentOS-fasttrack.repo
-rw-r--r--. 1 root root  630 2018-11-23 21:16 /etc/yum.repos.d/CentOS-Media.repo
-rw-r--r--. 1 root root 1331 2018-11-23 21:16 /etc/yum.repos.d/CentOS-Sources.repo
-rw-r--r--. 1 root root 5701 2018-11-23 21:16 /etc/yum.repos.d/CentOS-Vault.repo
-rw-r--r--. 1 root root 1919 2021-06-11 17:14 /etc/yum.repos.d/docker-ce.repo

[root@nexusServer ~]# yum list docker-ce  --showduplicates | sort  -r
已加载插件：fastestmirror
可安装的软件包
 * updates: mirrors.huaweicloud.com
Loading mirror speeds from cached hostfile
 * extras: mirrors.huaweicloud.com
docker-ce.x86_64            3:20.10.7-3.el7                     docker-ce-stable
docker-ce.x86_64            3:20.10.6-3.el7                     docker-ce-stable
docker-ce.x86_64            3:20.10.5-3.el7                     docker-ce-stable
docker-ce.x86_64            3:20.10.4-3.el7                     docker-ce-stable
docker-ce.x86_64            3:20.10.3-3.el7                     docker-ce-stable
docker-ce.x86_64            3:20.10.2-3.el7                     docker-ce-stable
docker-ce.x86_64            3:20.10.1-3.el7                     docker-ce-stable
docker-ce.x86_64            3:20.10.0-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.9-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.8-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.7-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.6-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.5-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.4-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.3-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.2-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.15-3.el7                    docker-ce-stable
docker-ce.x86_64            3:19.03.14-3.el7                    docker-ce-stable
docker-ce.x86_64            3:19.03.1-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.13-3.el7                    docker-ce-stable
docker-ce.x86_64            3:19.03.12-3.el7                    docker-ce-stable
docker-ce.x86_64            3:19.03.11-3.el7                    docker-ce-stable
docker-ce.x86_64            3:19.03.10-3.el7                    docker-ce-stable
docker-ce.x86_64            3:19.03.0-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.9-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.8-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.7-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.6-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.5-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.4-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.3-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.2-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.1-3.el7                     docker-ce-stable
docker-ce.x86_64            3:18.09.0-3.el7                     docker-ce-stable
docker-ce.x86_64            18.06.3.ce-3.el7                    docker-ce-stable
docker-ce.x86_64            18.06.2.ce-3.el7                    docker-ce-stable
docker-ce.x86_64            18.06.1.ce-3.el7                    docker-ce-stable
docker-ce.x86_64            18.06.0.ce-3.el7                    docker-ce-stable
docker-ce.x86_64            18.03.1.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            18.03.0.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.12.1.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.12.0.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.09.1.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.09.0.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.06.2.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.06.1.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.06.0.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.03.3.ce-1.el7                    docker-ce-stable
docker-ce.x86_64            17.03.2.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.03.1.ce-1.el7.centos             docker-ce-stable
docker-ce.x86_64            17.03.0.ce-1.el7.centos             docker-ce-stable
 * base: mirrors.huaweicloud.com

yum -y install docker-ce

systemctl  start docker

systemctl  status docker

systemctl  enable  docker

docker version





拉取镜像，运行nexus服务

在nexusServer 服务器

docker pull sonatype/nexus3:3.16.0

docker images



mkdir /opt/nexus-data

chown -R  200 /opt/nexus-data

注：容器中nexus的默认运行用户是nexus,uid和gid为200

 

用命令行形式运行nexus容器

docker run -d  --name nexus  --ulimit nofile=65536:65536  -p 192.168.100.188:8081:8081 -v /opt/nexus-data:/nexus-data sonatype/nexus3:3.16.0

 

 



 

docker logs  -f  nexus

 



docker  ps  -a

ss  -tan

浏览器访问: http:192.168.100.181:8081

**浏览器访问: http:192.168.1.107:8081**

![img](https://upload-images.jianshu.io/upload_images/12979420-1d3ba2bd061aa6b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

![img](https://upload-images.jianshu.io/upload_images/12979420-d799ad396ec08d43.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

**默认登录用户名密码：admin/admin123**

创建yum私有仓库

 

yum私服有三种类：



 

创建blob存储，为其创建一个单独的存储空间，命名为yum



 



创建hosted类型的yum库

Name:：定义一个名称yumDev

Storage：Blob store，我们下拉选择前面创建好的专用blob：yum。

Hosted：开发环境，我们运行重复发布，因此Delpoyment policy 我们选择Allow redeploy

 



 







 

创建一个proxy类型的yum仓库

Name: yumProxy

Proxy：Remote Storage: 远程仓库地址，写: http://mirrors.163.com/centos

Storage: yum

其他设置，使用均是默认。

这里就先创建一个代理163的仓库，其实还可以多创建几个，诸如阿里云，搜狐等等，这个根据个人需求来定义。



 





创建一个group类型的yum仓库

Name：yumGroup

Storage：选择专用的blob存储yum

group : 将左边可选的2个仓库，添加到右边的members

 





可以创建多个prxoy类型的yum仓库，通过同一个group暴露给客户端使用

 



构建yum缓存

新建一台环境干净的主机，此时需要保证这台主机能够上网，因为私服当中还没有进行初始化。

先简单配置一下，将yum源指向到私服中来。

#  cd /etc/yum.repos.d

# mkdir repoBackup

# mv *.repo  repoBackup

 

# vim nexus.repo

####################################################################

[nexus]

name=Nexus Yum Repository

baseurl=http://192.168.1.107:8081/repository/yumGroup/$releasever/os/$basearch/

enabled=1

gpgcheck=0

#######################################################################

 





#  yum clean all

#  yum  makecache



现在，我们可以从页面上看缓存包了



 





 

服务端启动方式改进，将nexus注册成系统服务

编写unit文件

# vim /etc/systemd/system/nexus.service

####################################################

[Unit]

Description=Nexus

Documentation=https://www.sonatype.com

After=network-online.target firewalld.service docker.service

Requires=docker.service

[Service]

ExecStartPre=-/usr/bin/docker rm -f nexus

ExecStart=/usr/bin/docker run \

--name nexus \

--ulimit nofile=65536:65536 \

-p 192.168.1.107:8081:8081 \

-v /opt/nexus-data:/nexus-data \

sonatype/nexus3:3.16.0

ExecStop=/usr/bin/docker stop nexus

LimitNOFILE=65535

Restart=on-failure

StartLimitBurst=3

StartLimitInterval=60s

[Install]

WantedBy=multi-user.target

#####################################################

 



 

停止和删除命令行启动的nexus服务

# docker stop nexus

# docker rm nexus

 

用systemd启动服务

# systemctl daemon-reload

#  systemctl start  nexus

#  systemctl enable nexus

#  systemctl status nexus

 



# docker logs  -f nexus



 

四、测试nexus的yum私服


在yumClient服务器

用一台不能上网但是可以与刚刚私服通信的主机，将其yum源指向的配置好的私服，或者是将其他的源都切断，然后yum源仅仅指向私服，看看安装是否顺利。

#  cd /etc/yum.repos.d

# mkdir repoBackup

# mv *.repo  repoBackup

# vim nexus.repo

####################################################################

[nexus]

name=Nexus Yum Repository

baseurl=http://192.168.1.107:8081/repository/yumGroup//$releasever/os/$basearch/

enabled=1

gpgcheck=0

#######################################################################



#  yum clean all

# yumrepolist 

#  yum  -y  install  httpd





 

五、参考
nexus3搭建yum源

https://blog.51cto.com/daibaiyang119/2116205

http://limingming.org/index.php/2018/12/nexus3-yum-repo

 

企业级开源仓库nexus3实战应用

http://www.eryajf.net/category/%E6%9C%AF%E4%B8%9A%E4%B8%93%E6%94%BB/%E6%9C%8D%E5%8A%A1%E7%B1%BB%E7%9B%B8%E5%85%B3/nexus

 



 

# nexus3作为yum私服的使用

Yum（全称为 Yellow dog Updater, Modified）是一个软件包管理器。Yum基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软件包，无须繁琐地一次次下载、安装。

在开始之前，我先说说自己之前是怎么在不能上网的服务器上安装软件的：
1）本地新安装一台和目标服务器系统一样的虚拟机，在/etc/yum.conf中将“keepcache=0”改成keepcache=1（为了保存安装的rpm包）
2）在本地虚拟机上用yum安装需要的软件
3）把本地虚拟机/var/cache/下的rpm包都拷贝到目标服务器上的一个目录下，并用createrepo进行创建yum源仓库
4）配置目标服务器上的repo源地址
这个过程光看看就非常繁琐，而且yum源中的rpm包是固定死的，不能更新。在了解到了nexus这个大神器之后，我觉得之前的自己真是蠢的有点可爱，哈哈！

用nexus来作为yum私服的好处：
1.节省公网带宽，这个是私服的共有特征。
2.由于权限、配额等原因，公司中有些服务器无法上网，那这些不能上网的服务器怎么安装软件包啊？nexus可以完美的解决这个问题。

一、创建Blob Stores
和之前maven、npm一样，这里新建一个这里新建一个blob store专门作为yum的存储。

1）Type
选择"File"。

2）Name
就叫yum-blob吧。

3）Enable Soft Quota
限制目录的大小。我这边就不限制了。如果要限制的话，就勾选上，并填上限制的条件和限制的值就OK了。

4）Path
在填入Name之后，path会自动生成。



二、创建一个hosted类型的仓库
用户可以把一些自己的构件手动上传至宿主仓库（Hosted Repository）中。
点击"Repository"–>“Repositories”–>“Create repository”，选择yum(hosted)。



1）Name
就叫yum-hosted-my吧。

2）Online
勾选，可以设置这个仓库是在线还是离线。

3）Yum
Repodata Depth：指定创建repodata文件夹的存储库深度，这里选择"2"。
Deploy Policy：布局策略
Strict：严格
Permissive：宽松
这里选择默认的Strict。

4）Storang
Blob store：选择此仓库使用的Blob存储，这里选择之前创建的yum-blob。
Strict Content Type Validation：验证上传内容格式，这里就用默认的勾选。

5）Hosted
Deployment Policy：部署策略，有三个选项，分别是：
Allow Redeploy：允许重新部署
Disable Redeploy：禁止重新部署
Read-Only：只读

我这里使用默认的"Disable Redeploy"，如果是开发环境，可以选择"Allow Redeploy"。

6）Cleanup
Cleanup Policies：清除策略，这个是新增的功能，这里先不进行设置。

配置完成后如下图



三、创建一个proxy类型的仓库
代理仓库（Proxy Repository）是远程仓库的代理，当用户向这个代理仓库请求一个依赖包时，这个代理仓库会先在本地查找，如果存在，会直接提供给用户进行下载；如果在代理仓库本地查找不到，就会从配置的远程中央仓库中进行下载，下载到私服上之后再提供给用户下载。所以一般我们把私服架设在内网之中，这样可以节省外网带宽，并且大大提高了用户下载依赖的速度。
点击"Repository"–>“Repositories”–>“Create repository”，选择yum(proxy)。

1）Name
因为我要代理阿里云的yum仓库，所以就叫"yum-proxy-aliyun"。

2）Online
勾选，设置成在线。

3）Proxy
Remote storage：设置远程中央仓库的地址，我这里设置成阿里云的yum仓库地址—http://mirrors.aliyun.com/centos/

其他的用默认值即可。

4）Storage
Blob store：选择yum-blob
Strict Content Type Validation：验证上传内容格式，这里就用默认的勾选。

5）Routing,Negative Cache,Cleanup,HTTP
都使用默认配置。



四、创建一个group类型的仓库
仓库组（Repository Group）的目的是将多个仓库（代理仓库和宿主仓库）聚合，对用户暴露统一的地址。当用户需要获取某一个依赖包时，请求的是仓库组的地址，系统将会根据仓库组配置的仓库顺序依次查找。
点击"Repository"–>“Repositories”–>“Create repository”，选择yum(gruop)。

1）Name
yum-group-my

2）Online
勾选，设置成在线

3）Storage
Blob store：选择yum-blob
Strict Content Type Validation：使用默认的勾选

4）Group
将左侧的Available中的仓库列表添加到右侧的Members中。



五、验证测试
测试很简单，找一台不能上网的服务器或者把服务器中的其他yum源配置删除。为了方便，我这里直接把服务器中的其他yum源配置文件删除。

1、客户端配置
先备份原始repo文件

[root@localhost ~]# cd /etc/yum.repos.d/
[root@localhost yum.repos.d]# ls
Centos-7.repo  CentOS-Base.repo  CentOS-CR.repo  CentOS-Debuginfo.repo  CentOS-fasttrack.repo  CentOS-Media.repo  CentOS-Sources.repo  CentOS-Vault.repo
[root@localhost yum.repos.d]# mkdir repo_bak
[root@localhost yum.repos.d]# mv *.repo repo_bak/
1
2
3
4
5
再创建nexus.repo

[root@localhost yum.repos.d]# vim nexus.repo
[nexusrepo]
name=Nexus Repository
baseurl=http://192.168.0.125:9081/repository/yum-group-my/$releasever/os/$basearch/
enabled=1
gpgcheck=0
[root@localhost yum.repos.d]# ls
nexus.repo  repo_bak
1
2
3
4
5
6
7
8
2、更新客户端的yum源
用yum celan all和yum makecache命令来更新客户端yum源

[root@localhost yum.repos.d]# yum clean all
Loaded plugins: fastestmirror
Cleaning repos: nexusrepo
Cleaning up everything
Maybe you want: rm -rf /var/cache/yum, to also free up space taken by orphaned data from disabled or removed repos
Cleaning up list of fastest mirrors
[root@localhost yum.repos.d]# yum makecache
Loaded plugins: fastestmirror
nexusrepo                                                                                                                            | 1.8 kB  00:00:00     
(1/4): nexusrepo/7/x86_64/group_gz                                                                                                   | 167 kB  00:00:00     
(2/4): nexusrepo/7/x86_64/filelists                                                                                                  | 7.6 MB  00:00:00     
(3/4): nexusrepo/7/x86_64/primary                                                                                                    | 2.9 MB  00:00:00     
(4/4): nexusrepo/7/x86_64/other                                                                                                      | 1.6 MB  00:00:00     
Determining fastest mirrors
nexusrepo                                                                                                                                       10097/10097
nexusrepo                                                                                                                                       10097/10097
nexusrepo                                                                                                                                       10097/10097
Metadata Cache Created
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
3、验证从私服下载
客户端的yum配置已经完成，这里用yum安装gcc来做测试。

安装之前，先看一眼现在私服上的yum-group-my仓库是没有任何的构件的。



好了，万事具备，开始安装gcc吧

[root@localhost ~]# yum -y install gcc
1
gcc安装完成



然后再看一眼私服上的yum-group-my仓库。



和预期的一样，私服上已经从远程中央仓库下载了gcc的rpm和它的依赖包。

4、验证上传
yum客户端没有附带上传rpm包的方法。官网给出的例子是使用curl通过简单的http-put的方法将rpm包上传到私服的hosted仓库中。

我这里拿一个grafana的rpm进行上传测试

[root@localhost ~]# curl -v --user 'admin:Abc@123456' --upload-file ./grafana-4.4.3-1.x86_64.rpm http://192.168.0.125:9081/repository/yum-hosted-my/test/grafana-4.4.3-1.x86_64.rpm
* About to connect() to 192.168.0.125 port 9081 (#0)
*   Trying 192.168.0.125...
* Connected to 192.168.0.125 (192.168.0.125) port 9081 (#0)
* Server auth using Basic with user 'admin'
> PUT /repository/yum-hosted-my/test/grafana-4.4.3-1.x86_64.rpm HTTP/1.1
> Authorization: Basic YWRtaW46QWJjQDEyMzQ1Ng==
> User-Agent: curl/7.29.0
> Host: 192.168.0.125:9081
> Accept: */*
> Content-Length: 47258737
> Expect: 100-continue
>
> < HTTP/1.1 100 Continue
* We are completely uploaded and fine
< HTTP/1.1 400 Uploading RPMs above the configured depth is not allowed. Repodata depth set to 2, RPM depth is lower (1)
< Date: Mon, 14 Oct 2019 07:11:30 GMT
< Server: Nexus/3.19.0-01 (OSS)
< X-Content-Type-Options: nosniff
< Content-Security-Policy: sandbox allow-forms allow-modals allow-popups allow-presentation allow-scripts allow-top-navigation
< X-XSS-Protection: 1; mode=block
< Content-Length: 0
< 
* Connection #0 to host 192.168.0.125 left intact
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
可以看到上传并没有成功，报了400的错误，原因是"Uploading RPMs above the configured depth is not allowed. Repodata depth set to 2, RPM depth is lower (1)"。这是因为之前在创建yum-hosted-my仓库的时候，我设置了"Repodata Depth"的值为2，也就是rpm包的上传深度为2。但是我在用curl命令上传时的深度就只有test这么一级目录，所以我的实际上传是深度为1，小于设置的上传深度2才报的这个错。

解决方法：
用curl上传的时候将rpm包的上传深度大于等于2就行。

[root@localhost ~]# curl -v --user 'admin:Abc@123456' --upload-file ./grafana-4.4.3-1.x86_64.rpm http://192.168.0.125:9081/repository/yum-hosted-my/test/my/grafana-4.4.3-1.x86_64.rpm     
* About to connect() to 192.168.0.125 port 9081 (#0)
*   Trying 192.168.0.125...
* Connected to 192.168.0.125 (192.168.0.125) port 9081 (#0)
* Server auth using Basic with user 'admin'
> PUT /repository/yum-hosted-my/test/my/grafana-4.4.3-1.x86_64.rpm HTTP/1.1
> Authorization: Basic YWRtaW46QWJjQDEyMzQ1Ng==
> User-Agent: curl/7.29.0
> Host: 192.168.0.125:9081
> Accept: */*
> Content-Length: 47258737
> Expect: 100-continue
>
> < HTTP/1.1 100 Continue
* We are completely uploaded and fine
< HTTP/1.1 200 OK
< Date: Mon, 14 Oct 2019 07:21:04 GMT
< Server: Nexus/3.19.0-01 (OSS)
< X-Content-Type-Options: nosniff
< Content-Security-Policy: sandbox allow-forms allow-modals allow-popups allow-presentation allow-scripts allow-top-navigation
< X-XSS-Protection: 1; mode=block
< Content-Length: 0
< 
* Connection #0 to host 192.168.0.125 left intact
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
可以看到，返回200，这时候去私服看一下yum-group-my仓库。



有了，完美上传，哈哈。

参考文章：
https://help.sonatype.com/repomanager3/formats/yum-repositories#YumRepositories-ConfiguringYumClienthttps://blog.csdn.net/alibert/article/details/80678371
http://www.eryajf.net/2002.html
————————————————
版权声明：本文为CSDN博主「wc1695040842」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/wc1695040842/article/details/102576093









