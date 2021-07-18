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

