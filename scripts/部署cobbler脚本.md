```shell
#!/bin/bash
#AUTHOR:ytchen5
#VERSION:1.0.0
#DATE:2021-07-12
#MODIFY: 2021-07-15
#FUNCTION:一键部署cobbler服务器
#DESCRIBE:基于CentOS Linux release 7.6.1810 (Core)
#NOTICES:

# 定义变量，运行环境脚本
root_pwd="root"								#装完系统后的root密码
#输出不同颜色的字体
#$1代表颜色编号,$2代表输出内容（提示用32，成功用92，错误用31，重点提醒用96，说明性用36）
cecho(){
	echo -e "\033[$1m$2\033[0m"
}

# 获取系统的的网络信息从而定义网络参数变量
get_net(){
IP_TMP=`ip addr show $1 | tr " " ":" | awk -F: '/:inet:/{print $0}'| awk -F: '{print $6}'`
IP=${IP_TMP%/*}
MASK_CODE=${IP_TMP#*/}
case ${MASK_CODE} in

24) MASK="255.255.255.0";;
25) MASK="255.255.255.128";;
26) MASK="255.255.255.192";;
27) MASK="255.255.255.224";;
28) MASK="255.255.255.240";;
29) MASK="255.255.255.248";;
*)    exit 1
esac
Gateway_TMP=`ip route | grep -e $dev | grep -i default | awk -F" " '{print $3}'`
if [ -z $Gateway_TMP ];then 
  gateway="0.0.0.0"
else
  gateway=${Gateway_TMP}
fi
}

#Centos7安装多个工具
Yum_Mul(){
	Array=($1)
	for i in ${Array[*]}
	do
		stat=`rpm -qa $i`

		if [ -z ${stat} ];then
			echo -en "Installing $i......\t\t\t\t"
			yum -y install $i --showduplicates &> /dev/null

			[ $? -eq 0 ] && echo -e "\e[32;1m[OK]\e[0m" || cecho 31 "$i 安装失败" && sleep 6 && exit 71 
		else

           cecho 31 "${stat} already installed" && sleep 6
        fi
	done
}

CONFIG_IP_CENTOS7(){
  get_net $1
  cp /etc/sysconfig/network-scripts/ifcfg-$1{,.bak}
  [ -f  /etc/sysconfig/network-scripts/ifcfg-$1.bak ] && >/etc/sysconfig/network-scripts/ifcfg-$1

cat >> /etc/sysconfig/network-scripts/ifcfg-$1 << EOF
TYPE=Ethernet
BOOTPROTO=static
NAME=$1
DEVICE=$1
ONBOOT=yes
IPADDR=$IP
NETMASK=$MASK
GATEWAY=$gateway
EOF
systemctl restart NetworkManager.service
}

#关闭防火墙，禁用selinux
Security_Conf(){
  systemctl disable firewalld  &>/dev/null
  systemctl stop firewalld &>/dev/null
  local selinux_mode=$(grep '^SELINUX=' /etc/selinux/config |awk -F'=' '{print $2}')
  if [ ${selinux_mode} != "disabled" ];then
     setenforce 0
     sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config
     cecho 92 "selinux需重启系统才能生效"
  fi
}

# 启动相关程序函数
STR_SVC(){
  SERVICE=$1
  systemctl status $1 &>/dev/null
  if [ $? -eq 0 ];then
    echo "$1 is already running"
  else
    systemctl restart $1 &>/dev/null
  fi
  systemctl status $1 &>/dev/null
  [ $? -eq 0 ] && echo "$1 started successfully" || echo "$1 Boot failure"

}

# 网络环境准备
network(){
DEVICE=(`ip addr | grep :*eth[0-10]*: | tr " " ":" | awk -F: '{print  $3}'|tr "\n" " "`)
DEVICE_1=${#DEVICE[*]% *}
read -p "发现了${DEVICE_1[@]}块网卡${DEVICE[*]} 请您输入需要配置的网卡：" dev 
get_net $dev

# 固定IP地址
CONFIG_IP_CENTOS7 $dev
}


# 配置yum源
Yum(){
yum_dir=/etc/yum.repos.d/
repo_file_count=`find $yum_dir ! -name "yum.repos.d" -type d -prune -o -type f  -print| wc -l`
repo_files=(`find $yum_dir ! -name "yum.repos.d" -type d -prune -o -type f  -print`)


if [[ ${repo_file_count} -gt 0 ]];then

	[ ! -d ${yum_dir}bak ] && mkdir ${yum_dir}bak
	
	i=0
	while [ $i -lt ${#repo_files[*]} ]
	do
		mv $yum_dir${repo_files[$i]##*/} ${yum_dir}bak/

		let i++
	done

fi

read -p "请问你当前的服务器可以连接互联网吗？请输入（yes|no）" internet
if [[ $internet == "yes" ]]; then
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum repolist
yum makecache
else
	echo "需要连接互联网才能部署，否则需要手动安装软件及依赖组件"
	exit 
fi
}

# 安装软件包
InstallSoft(){
soft_packets=("cobbler-web" "cobbler" "unzip" "dhcp" "tftp-server" "pykickstart" "httpd" "xinetd")
Yum_Mul "${soft_packets[*]}"

 	#或者用下面的命名在线下载引导文件
	#cobbler get-loaders
}

# 修改配置文件
modify_conf(){
# 定义变量
cobbler_conf=/etc/cobbler/settings
httpd_conf=/etc/httpd/conf/httpd.conf
rsync_conf=/etc/xinetd.d/rsync
tftpd_conf=/etc/xinetd.d/tftp
dhcp_conf=/etc/dhcp/dhcpd.conf
#备份
[ ! -f ${cobbler_conf}.save ] && cp ${cobbler_conf} ${cobbler_conf}.save
[ ! -f ${httpd_conf}.save ] && cp ${httpd_conf} ${httpd_conf}.save
#[ ! -f ${rsync_conf}.save ] && cp ${rsync_conf} ${rsync_conf}.save
[ ! -f ${tftpd_conf}.save ] && cp ${tftpd_conf} ${tftpd_conf}.save
[ ! -f ${dhcp_conf}.save  ] && cp ${dhcp_conf} ${dhcp_conf}.save
sed -i "s#next_server: [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}#next_server: ${IP}#" $cobbler_conf
sed -i "s#server: [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}#server: ${IP}#" $cobbler_conf
sed -i "s#manage_dhcp: 0#manage_dhcp: 1#" $cobbler_conf
sed -i "s#pxe_just_once: 0#pxe_just_once: 1#" $cobbler_conf
sed -i "s/manage_dns: 0/manage_dns: 1/" $cobbler_conf
sed -ri "/default_password_crypted/s#(.*: ).*#\1\"`openssl passwd -1 -salt 'cobbler' "${root_pwd}"`\"#"  $cobbler_conf
#sed -i '/diable/ s/yes/no/' $rsync_conf
sed -i '/diable/ s/yes/no/' $tftpd_conf 
sed -i "/^ServerName.*/s/^ServerName.*/ServerName $IP/" $httpd_conf

#校验
grep  "^next_server:*" $cobbler_conf
grep  "^server:*" $cobbler_conf
grep  "^manage_dhcp:*" $cobbler_conf
grep  "^pxe_just_once:*" $cobbler_conf
grep  "^manage_tftpd:*" $cobbler_conf
grep  "^manage_dns:*" $cobbler_conf
grep  "^ServerName" $httpd_conf


# 修改dhcp

SET_DHCP(){
	cat >>$dhcp_conf<<-EOF
	option domain-name "${IP}";
    option domain-name-servers ${IP};
    default-lease-time 600;
    max-lease-time 7200;
    log-facility local7;
    subnet ${IP%.*}.0 netmask ${MASK} {
    range ${IP%.*}.100 ${IP%.*}.200;
    option domain-name-servers ${IP};
    option domain-name "${IP}";
    option routers ${gateway};
    option broadcast-address ${IP%.*}.255;
    }
	EOF

}
	if [ ! -f ${dhcp_conf} ];then
    SET_DHCP
    else
    mv ${dhcp_conf} /tmp
    SET_DHCP
    fi

}

# #启动相关服务
start_service(){
	echo "[ ss -nutlp |grep tftpd &>/dev/null ] || systemctl start tftpd" >> /etc/rc.local		#解决tftp开机不启动的问题
	chmod +x /etc/rc.local
	STR_SVC cobblerd
	STR_SVC httpd
	STR_SVC tftp
	STR_SVC rsyncd

	systemctl restart httpd;systemctl restart cobblerd;sleep 5;cobbler sync						#先同步配置文件才能启动dhcpd服务
	STR_SVC dhcpd
	cobbler check
}

#导入镜像[写绝对路径]
import_images(){
	image_dir=$1										#镜像路径
	mount_dir=/system									#挂载目录
	[ ! -d $mount_dir ] && mkdir $mount_dir  || umount $mount_dir
	mount $image_dir $mount_dir
	
	image_name=`basename $image_dir`
	name=`echo $image_name |awk -F- '{print $1 "-" $2}'`
	cobbler import --path=$mount_dir --name=${name} --arch=x86_64
	cobbler check
}

# 导入你准备的ks文件并使用，可以根据实际情况修改
KSFILE_CONFIG(){
ksfile=/var/lib/cobbler/kickstarts/centos7-x86_64.ks
cat >>$ksfile<<-EOF
# Cobbler for Kickstart Configurator for CentOS 7 by ytchen5
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
EOF

cobbler profile edit --name=centos7-x86_64 --kickstart=$ksfile
cobbler profile report | grep kickstart
}


#帮助信息
HELP(){
cat << EOF
cobbler version 1.1.0
Usage: cobbler [-h] [-all] [-init] [-soft] [-conf][-start][-import 镜像绝对路径]
=======================================================================
optional arguments:
	-h              提供帮助信息
	-all			一键式安装(适用于首次安装)
	-init			关闭防火墙、设置selinux
	-soft			安装软件包
	-conf			修改配置文件
	-start			启动服务
	-import			导入镜像
	-ks             替换ks文件，并使用
EXAMPLE:
	bash main.sh -import ubuntu-16.04.4-server-amd64.iso
EOF
}


#############################主程序#############################
[ $# -eq 0 ] && HELP
case $1 in 
-h)
	HELP ;;
-all)
	cecho 32 "关闭防火墙，禁用selinux"
	Security_Conf

	cecho 32 "配置网络信息，固定IP地址"
	network

	cecho 32 "配置YUM源"
	Yum

	cecho 32 "安装相关软件包"
	InstallSoft

    cecho 32 "修改相关配置文件"
    modify_conf

    cecho 32 "启动相关服务"
    start_service

    cecho 32 "导入镜像"
    if [ $# -eq 2 ];then
	name=$2 
			suffix=`echo ${name##*.}`
			[ ${suffix} != 'iso' ] && cecho 31 "Invalid option:bash `basename $0` [-h]" && exit 71	
			import_images ${name} && exit 0
	fi
		cecho 31 "Invalid option:bash `basename $0` [-h]"
	

    cecho 32 "定制ks文件"
    KSFILE_CONFIG

	;;
	-init)
	    cecho 32 "关闭防火墙，禁用selinux"
		Security_Conf
	    ;;
	-soft)
		cecho 32 "配置网络信息，固定IP地址"
	    network
		cecho 32 "安装相关软件包"
	    InstallSoft
	;;
	-conf)
	    
	    cecho 32 "修改相关配置文件"
	    network
        modify_conf
	;;
	-start)
	    cecho 32 "启动相关服务"
        start_service
	;;
	-import)	
	if [ $# -eq 2 ];then
	name=$2 
			suffix=`echo ${name##*.}`
			[ ${suffix} != 'iso' ] && cecho 31 "Invalid option:bash `basename $0` [-h]" && exit 71	
			import_images ${name} && exit 0
	fi
		cecho 31 "Invalid option:bash `basename $0` [-h]"
		;;

    -ks)
	    cecho 32 "定制ks文件"
        KSFILE_CONFIG
        ;;	
	*)
		cecho 31 "Invalid option:bash `basename $0` [-h]"
		;;
esac

```

