git push 的时候报错 hint: Updates were rejected because the remote contains work that you do 解决方法：



1.git pull origin master --allow-unrelated-histories

2.git pull origin master

3.git init

4.git remote add origin ssh://git@git.limikeji.com:10022/yanhui/webweb.git （可忽略）

5.git add .


6.git commit -m 'testst'



7.git push -u origin master

