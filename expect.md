# expect
expect  
介绍: expect 交互性质很强的脚本语言,他可以帮助运维人员实现批量管理若干台服务器操作,是一款很实用的批量部署工具  
expect 依赖于tcl 而linux系统一般不自带安装tcl,所以需要手动安装.

安装 :  
说明: 安装前必须要安装 gcc-c++  
yum install -y gcc-c++  
使用expect 创建脚本的方法  
1) #!/usr/bin/expect定义脚本执行的shell  
2) set timeout 30 定义超时时间 单位为秒 如果设置为-1 就是永不超时的意思  
3) spawn 内部命令 是进入expect环境后执行的内部命令. 主要功能传递交互命令  
4) expect 内部命令 用来判断输出结果是否包含某项字符串, 没有立即返回,否则等待一段时间在返回,等待时间通过set timeout 设置  
5) send 执行交互动作,将交互要执行的动作输入给交互指令,命令字符串结尾加上\\r 如果出现异常等待的状态,可以进行核查  
6) interact 执行完后保持交互状态,把控制权交给控制台,如果不加这一项交互完成会自动退出  
7) exp\_continue 继续执行接下来的交互操作  
8) $argv expect脚本可以接受从bash传递过来的参数,可以用\[lindex $argv n\] 获得 n 从0开始,分别表示第一个 第二个 第三个.... 参数

实现非交互 ssh远程连接主机  
#!/usr/bin/expect  
set ipaddress \[ lindex $argv 0 \]  
set password \[ lindex $argv 1 \]  
set user \[ lindex $argv 2 \]  
set timeout 30  
spawn ssh $user@$ipaddress

expect {  
"yes/no" {send "yes\\r";exp\_continue}  
"password" {send "$password\\r"}  
}  
interact

执行结果  
chenyantao@cyt:~/shell/expect$ ./ssh.exp 192.168.100.188 merlin root  
spawn ssh root@192.168.100.188  
root@192.168.100.188's password:   
Last login: Sat Nov 21 16:10:22 2020 from cyt  
\[root@vm3 ~\]#

扩展   
chenyantao@cyt:~/shell/expect$ sudo cp ssh.exp /usr/bin/ssh2  
\[sudo\] chenyantao 的密码：   
chenyantao@cyt:~/shell/expect$ ss  
ss                ssh2              ssh-agent         ssh-copy-id       ssh-import-id     ssh-import-id-lp  ssh-keyscan         
ssh               ssh-add           ssh-argv0         sshd              ssh-import-id-gh  ssh-keygen          
chenyantao@cyt:~/shell/expect$ ssh  
ssh               ssh-add           ssh-argv0         sshd              ssh-import-id-gh  ssh-keygen          
ssh2              ssh-agent         ssh-copy-id       ssh-import-id     ssh-import-id-lp  ssh-keyscan         
chenyantao@cyt:~/shell/expect$ ssh2 192.168.100.154 merlin chenyantao 自定义命令  方法  
spawn ssh chenyantao@192.168.100.154  
The authenticity of host '192.168.100.154 (192.168.100.154)' can't be established.  
ECDSA key fingerprint is SHA256:JWBtjYGp2mFIkh4851P+SdAut/IE+d9RNJxde3F+mpQ.  
Are you sure you want to continue connecting (yes/no/\[fingerprint\])? yes  
Warning: Permanently added '192.168.100.154' (ECDSA) to the list of known hosts.  
chenyantao@192.168.100.154's password:   
Last failed login: Sat Nov 21 03:05:42 EST 2020 from cyt on ssh:notty  
There were 3 failed login attempts since the last successful login.  
Last login: Sat Nov 21 01:23:58 2020 from cyt  
\[chenyantao@vm1 ~\]$ exit  
登出  
\======================================================================================================  
#!/usr/bin/expect  
set ipaddress \[ lindex $argv 0 \]  
set password \[ lindex $argv 1 \]  
set user \[ lindex $argv 2 \]  
set timeout 30  
spawn scp -r /etc/hosts $user@$ipaddress:/tmp/

expect {  
"yes/no" {send "yes\\r";exp\_continue}  
"password" {send "$password\\r"}

}  
expect eof  
\======================================================================================================  
需求:写一个脚本 实现将本地主机生成密钥分发给想要通过ssh密钥认证的主机(推送公钥)  
#!/usr/bin/bash  
\# ssh-copy public   
\# v1.0 by ytchen5 2020年11月21日  
for ip in \`cat $1\`  
do  
expect <<-EOF  
spawn ssh-copy-id -i /home/chenyantao/.ssh/id\_rsa.pub chenyantao@$ip  
expect "password"  
send "merlin\\r"  
expect eof  
EOF  
done