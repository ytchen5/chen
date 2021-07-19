## tee工具

tree工具是从标准输入读取并写入到标准输出和文件，即：双向覆盖重定向（屏幕输出，文本输入）

选项：

`-a`	双向追加重定向

```
# echo hello word
# echo hello world | tee file1
# cat file1
# echo 999 | tee -a file1
# cat file1
```

***生产中一般应用与备份配置文件情况下***

```
[root@vm1 ~]# cat /etc/vsftpd/vsftpd.conf | egrep -v '(^#|^$)' | tee vsftpd.conf.bak
anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
[root@vm1 ~]# cat vsftpd.conf.bak 
anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
[root@vm1 ~]# 
```

