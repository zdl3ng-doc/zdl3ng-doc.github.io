# index.md生成工具使用方法

`index.bat` windows上的index.md生成工具，可以遍历文件夹生成index.md。放在了项目根目录下。

```shell
## 递归所有文件夹，执行命令
.\index.bat . -r

## 仅当前文件夹，执行命令
.\index.bat .

## 递归所有文件夹，并且最低层文件夹也生成index.md，执行命令
.\index.bat . -r -b
```