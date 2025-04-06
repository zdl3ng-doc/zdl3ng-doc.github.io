# 支持对最底层文件夹生成md文件的index.md

## 需求说明：
使用中发现，很多时候比不想手动维护最底层的index.md，还是像使用工具快速生成

## 询问：
当前文件夹下有 多个md文件，如：index.md, 问题.md，解决.md，判断当前文件夹下，是否有非index.md的其他md文件。若有，将这些文件，列入新的index.md中 

## 答复：

### 修改后的代码

```bat
@echo off
setlocal enabledelayedexpansion

:: 设置当前目录
set "current_dir=%cd%"
set "output_file=%current_dir%\index.md"

:: 初始化 index.md 文件
> "%output_file%" echo # Index of %current_dir%

:: 遍历当前目录的所有 .md 文件，排除 index.md
for /f "delims=" %%D in ('dir /b /a:-d /o-n "%current_dir%\*.md"') do (
    if /i not "%%D"=="index.md" (
        set "file_name=%%~nxD"
        echo  - [!file_name!](%%D) >> "%output_file%"
    )
)

echo 已生成: "%output_file%"
pause
```

### 代码说明

1. 初始化 index.md 文件：
`> "%output_file%" echo # Index of %current_dir%`
 - 清空并初始化 index.md 文件，写入标题。
2. 遍历 .md 文件：
`for /f "delims=" %%D in ('dir /b /a:-d /o-n "%current_dir%\*.md"') do (`
 - `dir /b /a:-d /o-n "%current_dir%\*.md"`：
   - /b：简洁模式，仅显示文件名。
   - /a:-d：仅列出文件（排除文件夹）。
   - /o-n：按名称降序排列。
   - *.md：仅匹配 .md 文件。
3. 排除 index.md：
`if /i not "%%D"=="index.md" (`
   - `/i`：忽略大小写比较。
   - 如果文件名不是 index.md，则将其添加到新的 index.md 文件中。
4. 写入文件名到 index.md：
```bat
set "file_name=%%~nxD"
echo  - [!file_name!](%%D) >> "%output_file%"
```
   - %%~nxD：提取文件名和扩展名。
   - 将文件名和链接格式化写入 index.md。
  
## 询问：bat if else if 语句如何写

在批处理脚本中，`if else if` 语句可以通过多个 `if` 语句嵌套实现，因为批处理脚本本身不支持直接的 `else if` 语法。以下是一个示例：

```bat
if "%var%"=="value1" (
    echo 条件1满足
) else if "%var%"=="value2" (
    echo 条件2满足
) else (
    echo 条件都不满足
)
```

### 注意事项：
1. `else if` 实际上是通过 `else` 后紧跟另一个 `if` 实现的。
2. `else` 和 `if` 必须在同一行，且 `else` 前后需要有空格。
3. 确保括号匹配正确，避免语法错误。
4. 使用 `setlocal enabledelayedexpansion` 时，变量需要用 `!var!` 而不是 `%var%`。

通过这种方式，可以实现类似于其他编程语言中的 `if else if` 逻辑。

## 询问：bat call :generate_index_recursive "%target_dir%" 传两个参数如何写?

### 示例代码

```bat
@echo off
setlocal enabledelayedexpansion

:: 示例调用
call :generate_index_recursive "%target_dir%" "%output_file%"
exit /b

:: 定义函数
:generate_index_recursive
set "target_dir=%~1"
set "output_file=%~2"

echo 处理目录: !target_dir!
echo 输出文件: !output_file!

:: 在此处添加处理逻辑
:: ...

exit /b
```

### 说明
1. `call :generate_index_recursive "%target_dir%" "%output_file%"`：
   - `%~1` 和 `%~2` 分别表示传递的第一个和第二个参数。
2. 在函数内部：
   - `set "target_dir=%~1"`：获取第一个参数。
   - `set "output_file=%~2"`：获取第二个参数。
3. 使用 `exit /b` 退出函数，返回到调用点。

