nexus内部添加epel源


访问 http://ip:8081，
创建仓库：选择相应apt、yum、pypi等类型，host为离线储存模式，proxy为在线代理模式，group为组模式，用于整合仓库资源

创建yum源：
https://mirrors.tuna.tsinghua.edu.cn/centos/
创建apt源：
https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
#bionic,focal抓取ubuntu18.04、ubuntu20.04
创建epel源：
http://mirrors.aliyun.com/epel
创建centos6 yum源：
http://mirrors.aliyun.com/centos-vault/6.10

客户端配置
Centos

cat /etc/yum.repos.d/CentOS-Base.repo

[base]
name=base
baseurl=http://ip:8081/repository/tsinghua-yum/$releasever/os/$basearch/
enabled=1
gpgcheck=0

[updates]
name=updates
baseurl=http://ip:8081/repository/tsinghua-yum/$releasever/updates/$basearch/
enabled=1
gpgcheck=0

[extras]
name=extras
baseurl=http://ip:8081/repository/tsinghua-yum/$releasever/extras/$basearch/
enabled=1
gpgcheck=0

[plus]
name=plus
baseurl=http://ip:8081/repository/tsinghua-yum/$releasever/centosplus/$basearch/
enabled=1
gpgcheck=0


Ubuntu

cat /etc/apt/sources.list

deb http://ip:8081/repository/tsinghua-ubuntu/ bionic main restricted universe multiverse
deb http://ip:8081/repository/tsinghua-ubuntu/ bionic-updates main restricted universe multiverse
deb http://ip:8081/repository/tsinghua-ubuntu/ bionic-backports main restricted universe multiverse
deb http://ip:8081/repository/tsinghua-ubuntu/ bionic-security main restricted universe multiverse

pypi

cat /root/.pip/pip.conf

[global]
index-url = http://ip:8081/repository/tsinghua-pypi/simple/
trusted-host = ip



epel

cat /etc/yum.repos.d/CentOS-Base.repo

[epel]
name=epel
baseurl=http://ip:8081/repository/ali-epel/7/$basearch
enabled=1
gpgcheck=0

[epel-debuginfo]
name=epel-debuginfo
baseurl=http://ip:8081/repository/ali-epel/7/$basearch/debug
enabled=0
gpgcheck=0

[epel-source]
name=epel-source
baseurl=http://ip:8081/repository/ali-epel/7/SRPMS
enabled=0
gpgcheck=0