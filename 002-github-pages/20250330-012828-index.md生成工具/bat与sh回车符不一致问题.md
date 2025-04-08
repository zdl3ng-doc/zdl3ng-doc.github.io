# bat与sh回车符不一致问题

## 问题描述
通过bat和sh生成的readme.md文件对比发现，bat的换行符是 CRLF，sh的换行符是LF。能不能通过修改bat或sh脚本，使两者换行符一致

## 排查过程

### 1. 检查文件内容是否真的一致
首先，通过 `git diff` 命令检查文件的差异：
```bash
git diff
```
如果没有输出内容，说明文件内容在 Git 的视角中没有变化。

### 2. 检查换行符差异
文件的换行符可能是问题的根源。Windows 系统通常使用 `CRLF` 换行符，而 Linux 系统使用 `LF` 换行符。可以通过以下命令检查换行符：
```bash
git diff --text
```
如果换行符不同，Git 会将其视为文件被修改。

### 3. 检查文件编码
文件编码（如 UTF-8 和 UTF-8 with BOM）可能导致 Git 检测到差异。可以使用文本编辑器（如 VS Code）或工具（如 `file` 命令）检查文件的编码。

### 4. 检查文件权限
在某些情况下，文件权限的变化也会导致 Git 提示文件被修改。可以通过以下命令检查：
```bash
git diff --summary
```

### 5. 检查是否为不可见字符
文件中可能存在不可见字符（如 BOM）。可以使用 `git diff --binary` 命令查看二进制差异：
```bash
git diff --binary
```

### 6. 将两次生成的文件进行对比
使用 notepad++ 可以明显实现换行符不一致

## 解决方法

### 1. 统一换行符
在 `readme.sh` 脚本中，添加 `\r` 来确保生成的文件使用 `CRLF` 换行符：
```bash
echo -e "# $current_folder_name\r" > "$output_file"
```

### 2. 配置 Git 忽略换行符差异
通过以下命令配置 Git 忽略换行符差异：
```bash
git config core.autocrlf true
```

### 3. 确保文件编码一致
在生成文件时，明确指定文件编码为 UTF-8（无 BOM）。例如：
```bash
echo -e "\xEF\xBB\xBF# $current_folder_name" > "$output_file"
```

### 4. 撤销不必要的更改
如果文件确实没有变化，可以通过以下命令撤销更改：
```bash
git checkout -- <file>
```

## 总结
通过以上排查和解决方法，可以有效处理文件内容一致但 Git 提示文件被修改的问题。建议在团队协作中统一文件的换行符和编码格式，以减少类似问题的发生。
