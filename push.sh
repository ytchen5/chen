#!/bin/bash
git status &>/dev/null
sleep 2
git add .
sleep 2
git commit -m "chenyantao@cyt" &>/dev/null
sleep 2
git push origin master &>/dev/null
sleep 10
echo "push ok"
