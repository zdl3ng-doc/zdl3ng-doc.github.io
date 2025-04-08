@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 检查是否提供路径参数
if "%~1"=="" (
    set "target_dir=%cd%"
) else (
    set "target_dir=%~1"
)

:: 检查目标目录是否存在
if not exist "%target_dir%" (
    echo 错误：目标目录不存在！路径: "%target_dir%"
    pause
    exit /b
)

:: 检查是否传入 -r 参数
set "recursive=false"
if "%~2"=="-r" (
    set "recursive=true"
)

:: 调试输出
echo 目标目录: "%target_dir%"
echo 是否递归: %recursive%

:: 生成 index.md 文件
if "%recursive%"=="true" (
    call :generate_index_recursive "%target_dir%"
) else (
    call :generate_index "%target_dir%"
)

echo 所有指定目录的 index.md 文件已生成！
endlocal
pause
exit /b


:: ------------- 非递归处理目录函数 -------------
:generate_index
setlocal enabledelayedexpansion
set "current_dir=%~f1"

:: 调试输出
echo 正在处理目录: "!current_dir!"

:: 检查当前目录是否有子文件夹
set "has_subdirs=false"
for /d %%D in ("!current_dir!\*") do (
    echo 找到子目录: "%%D"
    set "has_subdirs=true"
)

:: 如果有子文件夹，生成 index.md 文件
if "%has_subdirs%"=="true" (
    set "output_file=!current_dir!\index.md"
    echo 正在生成文件: "!output_file!"
    > "!output_file!" (
        :: 获取当前文件夹名称
        for %%F in ("!current_dir!") do set "current_folder_name=%%~nF"
        echo # !current_folder_name!
    )
    for /f "delims=" %%D in ('dir /b /a:d-h /o-n "!current_dir!"') do (
        set "folder_name=%%~nD"
        echo  - [!folder_name!](%%D^) >> "!output_file!"
    )
    echo 已生成: "!output_file!"
) else (
    echo 当前目录没有子文件夹: "!current_dir!"
)
endlocal
exit /b



:: ------------- 递归处理子目录函数 -------------
:generate_index_recursive
setlocal enabledelayedexpansion
set "current_dir=%~f1"

:: 调试输出
echo 正在递归处理目录: "!current_dir!"

:: 调用非递归生成 index.md
call :generate_index "!current_dir!"

:: 递归处理子目录
for /d %%D in ("!current_dir!\*") do (
    call :generate_index_recursive "%%D"
)
endlocal
exit /b