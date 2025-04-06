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

:: 创建或覆盖 index.md 文件
set "index_file=%target_dir%\index.md"
> "%index_file%" (
    :: 使用 dir /o-n /a:d-h 忽略隐藏文件夹并倒序列出文件夹
    for /f "delims=" %%D in ('dir /b /a:d-h /o-n "%target_dir%"') do (
        set "folder_name=%%~nD"
        echo  - [!folder_name!](%%D^)
    )
)

echo index.md 文件已生成并覆盖: %index_file%
pause