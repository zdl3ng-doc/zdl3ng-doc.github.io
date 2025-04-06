@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 设置目标目录
set "target_dir=c:\Users\zdl3ng\Documents\GitHub\zdl3ng-doc.github.io\01-笔记"

:: 检查目标目录是否存在
if not exist "%target_dir%" (
    echo 错误：目标目录不存在！
    pause
    exit /b
)

:: 获取当前目录名称
for %%F in ("%target_dir%") do set "current_folder_name=%%~nF"

:: 创建 index.md 文件
set "index_file=%target_dir%\index.md"
(echo # !current_folder_name!) > "%index_file%"

:: 遍历目标目录下的文件夹
for /d %%D in ("%target_dir%\*") do (
    set "folder_name=%%~nD"
    echo  - [!folder_name!](%%~nD^) >> "%index_file%"
)

echo index.md 文件已生成: %index_file%
pause