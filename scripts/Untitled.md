#!/bin/env bash

Dir=/tmp

[ -d $Dir ] && rm -fr $Dir/*

for i in {1..3};do

​	mkdir $Dir/dir$i

done

cp /etc/hosts $Dir/dir1

echo "报告首长，任务已于$(date +%F" "%H:%M:%S)"

