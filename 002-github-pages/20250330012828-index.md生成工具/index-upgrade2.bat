:: 升级：不要标题

@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 检查是否提供参数
if "%~1"=="" (
    set "target_dir=%cd%"
) else (
    set "target_dir=%~1"
)

:: 检查目标目录是否存在
if not exist "%target_dir%" (
    echo 错误：目标目录不存在！
    pause
    exit /b
)

:: 创建 index.md 文件
set "index_file=%target_dir%\index.md"

:: 遍历目标目录下的文件夹
for /d %%D in ("%target_dir%\*") do (
    set "folder_name=%%~nD"
    echo  - [!folder_name!](%%~nD^) >> "%index_file%"
)

echo index.md 文件已生成: %index_file%
pause