执行脚本

| 执行方式          | 含义                                                         |
| ----------------- | ------------------------------------------------------------ |
| # ./shell.sh      | 需要执行权限，在当前shell的子shell中执行                     |
| # bash shell.sh   | 不需要执行权限，在当前shell的子shell中执行                   |
| # . shell.sh      | 不需要执行权限，在当前shell中执行                            |
| # source shell.sh | 不需要执行权限，在当前shell中执行,通常修改系统配置文件时候选择这样方式执行使其立即生效 |
| sh -n shell.sh    | 仅调试syntax error                                           |
| sh -vx shell.sh   | 以调试的方式执行，查询整个执行                               |

