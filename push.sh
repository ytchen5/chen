#!/bin/bash

process_count=`ps -ef | grep Typora | grep -v grep | wc -l`
git_home="/home/chen_lub"
PUSH(){
LOG_FILE=./push.log
echo "###########`date +%F-%H:%M:%m`#############">>$LOG_FILE
git status >>$LOG_FILE
sleep 2
git add .
sleep 2
git commit -m "chenyantao@cyt" >>$LOG_FILE
sleep 2
git push origin master >>$LOG_FILE
sleep 10
echo "push ok"
}

if [ ! ${process_count} -eq 0 ];then
	cd $git_home
	PUSH
fi

