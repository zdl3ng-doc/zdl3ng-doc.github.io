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

:: 检查是否传入 -r （递归）参数
set "recursive=false"
if "%~2"=="-r" (
    set "recursive=true"
)

:: 检查是否传入 -b （最底层文件夹生成readme.md）参数
set "bottom=false"
if "%~3"=="-b" (
    set "bottom=true"
)

:: 调试输出
echo =================================================================================================================
echo 目标目录: "%target_dir%"
echo 是否递归: %recursive%
echo 是否最底层文件夹生成readme.md: %bottom%
echo ----------------------------------------------------------------------------------------------------------------

:: 生成 readme.md 文件
if "%recursive%"=="true" (
    call :generate_index_recursive "%target_dir%" "%bottom%"
) else (
    call :generate_index "%target_dir%" "%bottom%"
)

echo ----------------------------------------------------------------------------------------------------------------
echo 所有指定目录的 readme.md 文件已生成！
echo =================================================================================================================
endlocal
pause
exit /b


:: ------------- 非递归处理目录函数 -------------
:generate_index
setlocal enabledelayedexpansion
set "current_dir=%~f1"
set "bottom=%~2"

:: 检查当前目录是否有子文件夹
set "has_subdirs=false"
for /d %%D in ("!current_dir!\*") do (
    :: echo 找到子目录: "%%D"
    set "has_subdirs=true"
)

:: 如果有子文件夹，生成 readme.md 文件
if "%has_subdirs%"=="true" (
    set "output_file=!current_dir!\readme.md"
    > "!output_file!" (
        :: 获取当前文件夹名称
        for %%F in ("!current_dir!") do set "current_folder_name=%%~nF"
        echo # !current_folder_name!
    )
    for /f "delims=" %%D in ('dir /b /a:-d /o-n "!current_dir!\*.md"') do (
        if /i not "%%D"=="readme.md" (
            set "mdfile_name=%%~nxD"
            echo  - [!mdfile_name!](%%D^) >> "!output_file!"
        )
    )
    for /f "delims=" %%D in ('dir /b /a:d-h /o-n "!current_dir!"') do (
        set "folder_name=%%~nxD"
        echo  - [!folder_name!](%%D^) >> "!output_file!"
    )
    echo 已生成: "!output_file!"
) else if "%bottom%"=="true" (
    :: 如果最底层文件夹，生成 readme.md 文件
    set "output_file2=!current_dir!\readme.md"
    > "!output_file2!" (
        :: 获取当前文件夹名称
        for %%F in ("!current_dir!") do set "current_folder_name2=%%~nF"
        echo # !current_folder_name2!
    )
    for /f "delims=" %%D in ('dir /b /a:-d /o-n "!current_dir!\*.md"') do (
        if /i not "%%D"=="readme.md" (
            set "mdfile_name2=%%~nxD"
            echo  - [!mdfile_name2!](%%D^) >> "!output_file2!"
        )
    )
    echo 已生成: "!output_file2!"
)
endlocal
exit /b



:: ------------- 递归处理子目录函数 -------------
:generate_index_recursive
setlocal enabledelayedexpansion
set "current_dir=%~f1"
set "bottom=%~2"

:: 调用非递归生成 readme.md
call :generate_index "!current_dir!" "!bottom!"

:: 递归处理子目录
for /d %%D in ("!current_dir!\*") do (
    call :generate_index_recursive "%%D" "!bottom!"
)
endlocal
exit /b