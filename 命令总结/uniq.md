## uniq工具

去除连续的重复的行

```
常见选项：
-i	忽略大小写
-c	统计重复行的次数
-d	只显示重复的行

举例说明：
chenyantao@cyt:~$ uniq -c 1.txt
      3 111111111111
      1 222222222222
      1 333333333333
      1 222222222222
      1 444444444444
      1 555555555555
      1 777777777777
      1 333333333333
chenyantao@cyt:~$ uniq -dc 1.txt
      3 111111111111
chenyantao@cyt:~$ cat 3.txt 
qqqqqqqqqqqq
QQQQQqqqqqqq
bbbbbBBBBBBB
BBBBBBBBBBBB
bbbbbbbbbbbb
aaaAaAaAaAaA
AAAAAAAAAAAA
aaaaaaaaaaaa
chenyantao@cyt:~$ uniq -ic 3.txt 
      2 qqqqqqqqqqqq
      3 bbbbbBBBBBBB
      3 aaaAaAaAaAaA
chenyantao@cyt:~$ uniq -icd 3.txt 
      2 qqqqqqqqqqqq
      3 bbbbbBBBBBBB
      3 aaaAaAaAaAaA
```

