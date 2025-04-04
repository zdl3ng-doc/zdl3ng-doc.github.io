@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 检查是否提供路径参数
if "%~1"=="" (
    set "current_dir=%cd%"
) else (
    set "current_dir=%~1"
)

for %%F in ("!current_dir!") do set "current_dir=%%~fF"


:: 检查路径是否存在
if not exist "%current_dir%" (
    echo 错误：路径 "%current_dir%" 不存在！
    pause
    exit /b
)

:: 遍历当前目录的所有文件夹
for /d %%D in ("%current_dir%\*") do (
    echo 找到文件夹: %%D
)

pause