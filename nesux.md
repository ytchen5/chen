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

docker run -d  --name nexus  --ulimit nofile=65536:65536  -p 192.168.1.188:8081:8081 -v /opt/nexus-data:/nexus-data sonatype/nexus3:3.16.0

 

 



 

docker logs  -f  nexus

 



docker  ps  -a

ss  -tan

浏览器访问: http:192.168.100.181:8081








