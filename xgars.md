# xgars
xgars  
用法：xargs \[选项\]... 命令 \[初始参数\]...  
以所给<初始选项>和其它更多来自标准输入的参数运行指定<命令>。

长选项的必需和可选参数对相应的短选项同样为必需或可选。  
 -0, --null                   各个项目由 null（空字符，不是空白字符）分隔；  
                                同时停止对引用和反斜杠转义的处理及对逻辑 EOF  
                                的处理  
 -a, --arg-file=文件          从指定<文件>读取参数，不使用标准输入  
 -d, --delimiter=分隔用字符   输入流的各个项目使用指定<分隔用字符>进行分隔，  
                                不使用空白字符；同时停止对引用和反斜杠转义的  
                                处理及对逻辑 EOF 的处理  
 -E 终止符                    设置逻辑 EOF（逻辑文件末尾）字符串；如果<终止符>  
                                作为单独一行输入，所有剩余的输入内容将被忽略  
                                （若同时使用了 -0 或 -d 选项，则该选项失效）  
 -e, --eof\[=终止符\]           在指定<终止符>的情况下与 -E <终止符> 等效；  
                                否则，视为文件末尾终止字符串不存在  
 -I R                         和 --replace=R 相同  
 -i, --replace\[=R\]            将<初始参数>中的 R 替换为从标准输入读取的  
                                名称；如果未指定 R，则假定其为{}  
 -L, --max-lines=最大行数     每个命令行使用最多<最大行数>行的非空输入行  
 -l\[最大行数\]                 类似 -L，但在没有给出<最大行数>信息时默认为接受  
                                最多一行非空输入行  
 -n, --max-args=最大参数数量  设置每个命令行可使用的<最大参数数量>  
 -o, --open-tty               Reopen stdin as /dev/tty in the child process  
                                before executing the command; useful to run an  
                                interactive application.  
 -P, --max-procs=MAX-PROCS    同时运行至多<MAX-PROCS>个进程  
 -p, --interactive            运行命令前提示  
     --process-slot-var=VAR   在子进程中设置环境变量<VAR>  
 -r, --no-run-if-empty        如果没有指定任何参数，则不运行指定的<命令>；  
                                如果未给出该选项，指定的<命令>将至少运行一次  
 -s, --max-chars=最大字符数   限制命令行长度的<最大字符数>  
     --show-limits            显示命令行长度的限制  
 -t, --verbose                执行命令前输出命令内容  
 -x, --exit                   如果大小（见 -s）超出限制则退出  
     --help                   显示此帮助信息并退出  
     --version                output version information and exit