#!/bin/bash

# 使用说明:
# 运行此脚本以生成指定目录及其子目录中的 readme.md 文件。
# 参数:
#   1. 目标目录路径 (可选，默认为当前目录)
#   2. -r (可选，递归处理子目录)
#   3. -b (可选，在最底层文件夹生成 readme.md 文件)
#
# 示例:
#   ./readme.sh . -r -b
#   ./readme.sh /path/to/dir -r
#   ./readme.sh /path/to/dir

# ------------- 非递归处理目录函数 -------------
generate_index() {
    local current_dir="$(realpath "$1")" # Use absolute path
    local bottom="$2"

    # 检查当前目录是否有子文件夹
    local has_subdirs=false
    for dir in "$current_dir"/*/; do
        if [ -d "$dir" ]; then
            has_subdirs=true
            break
        fi
    done

    # 如果有子文件夹，生成 readme.md 文件
    if [ "$has_subdirs" == true ]; then
        local output_file="$current_dir/readme.md"
        {
            # 获取当前文件夹名称
            current_folder_name=$(basename "$current_dir")
            echo "# $current_folder_name"
        } > "$output_file"

        for file in "$current_dir"/*.md; do
            if [ "$(basename "$file")" != "readme.md" ]; then
                mdfile_name=$(basename "$file")
                echo "  - [$mdfile_name]($mdfile_name)" >> "$output_file"
            fi
        done

        for dir in "$current_dir"/*/; do
            folder_name=$(basename "$dir")
            echo "  - [$folder_name](${folder_name})" >> "$output_file" # Ensure proper folder link
        done

        echo "已生成: $output_file"
    elif [ "$bottom" == true ]; then
        # 如果最底层文件夹，生成 readme.md 文件
        local output_file2="$current_dir/readme.md"
        {
            # 获取当前文件夹名称
            current_folder_name2=$(basename "$current_dir")
            echo "# $current_folder_name2"
        } > "$output_file2"

        for file in "$current_dir"/*.md; do
            if [ "$(basename "$file")" != "readme.md" ]; then
                mdfile_name2=$(basename "$file")
                echo "  - [$mdfile_name2]($mdfile_name2)" >> "$output_file2"
            fi
        done

        echo "已生成: $output_file2"
    fi
}

# ------------- 递归处理子目录函数 -------------
generate_index_recursive() {
    local current_dir="$(realpath "$1")" # Use absolute path
    local bottom="$2"

    # 调用非递归生成 readme.md
    generate_index "$current_dir" "$bottom"

    # 递归处理子目录
    for dir in "$current_dir"/*/; do
        [ -d "$dir" ] && generate_index_recursive "$dir" "$bottom"
    done
}

# ------------- 主方法函数 -------------

# 检查是否提供路径参数
if [ -z "$1" ]; then
    target_dir=$(realpath "$(pwd)") # Use absolute path
else
    target_dir=$(realpath "$1") # Use absolute path
fi

# 检查目标目录是否存在
if [ ! -d "$target_dir" ]; then
    echo "错误：目标目录不存在！路径: $target_dir"
    exit 1
fi

# 检查是否传入 -r （递归）参数
recursive=false
if [ "$2" == "-r" ]; then
    recursive=true
fi

# 检查是否传入 -b （最底层文件夹生成readme.md）参数
bottom=false
if [ "$3" == "-b" ]; then
    bottom=true
fi

# 调试输出
echo "================================================================================================================="
echo "目标目录: $target_dir"
echo "是否递归: $recursive"
echo "是否最底层文件夹生成readme.md: $bottom"
echo "----------------------------------------------------------------------------------------------------------------"

# 生成 readme.md 文件
if [ "$recursive" == true ]; then
    generate_index_recursive "$target_dir" "$bottom"
else
    generate_index "$target_dir" "$bottom"
fi

echo "----------------------------------------------------------------------------------------------------------------"
echo "所有指定目录的 readme.md 文件已生成！"
echo "================================================================================================================="
