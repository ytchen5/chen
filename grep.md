# grep
\### grep 应用实例

grep 家族  
grep 在文本中全局查找制定的正则表达式, 并打印包含该正则表达式的行  
egrep 扩展的grep, 支持更多的正则表达式元字符  
fgrep  固定的grep(fixed grep),有时候也被称作快速(fast grep),它按照字面解释所有字符  
一. grep命名格式  
grep \[选项\] PATTERN filename filename  
\# grep 'Tom' /etc/passwd  
\# grep "bash shell" /etc/test  
找到: grep 返回退出状态为0  
没找到: grep返回退出状态为1  
找不到指定文件: grep返回退出状态为2  
grep 程序的输入可以来自标准输入或者 管道, 而不仅是文件, 例如:

二. grep使用的元字符

grep  
 使用基本元字符 ^ $ . \* \[\] \[^\] \\< \\> \\(\\) \\{\\}  
 使用扩展元字符 \\+ \\|  
egrep(或grep -E)  
 使用扩展元字符 ? + {} | ()  
\\w   所有字母与数字  称为字符 \[a-zA-Z0-9\]  l\[a-zA-Z9-0\]\*ve  等价于 l\\w\*ve  
\\W   所有字母与数字之外的字符 称为非字符  love\[^a-zA-Z0-9\]+ 等价于 love\\W+  
\\b   词边界        \\<love\\>    等价于 \\blove\\b

grep示例:  
grep -E 或者 egrep

egrep 'NW' datafile  
egrep 'NW' d\*  
egrep '^n' datafile  
egrep '4$' datafile  
egrep '5\\..' datafile  
egrep '\\.5' datafile  
egrep '^\[we\]' datafile  
egrep '^n\\w\*\\W' datafile   
grep 选项  
\-i --ignore-case 忽略大小写  
\-l --files-which-matches 只列出匹配行的所在的文件名  
\-n --line-number 在每一行前面加上它在文件中所在的行号  
\-c --count   显示成功匹配的行数  
\-s --no-messages 禁止显示文件不存在或文件不可读等错误信息  
\-q --quiet,--silent 静默 --quiet --silent  
\-v --invert-match 反向查找 只显示不匹配的行  
\-R -r --recursive 递归针对目录  
\--color    颜色  
\-o --only-matching 只显示匹配的内容  
\-B --before-context=NUM Print NUM lines of leading context   
\-A --after-context=NUM rint NUM lines of trailing context after matching lines  
\-C --context=NUM Print NUM lines of output context