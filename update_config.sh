#!/bin/bash

# 检测操作系统
OS="$(uname)"

# 设置默认的配置目录
NVIM_CONFIG_DIR=""

if [ "$OS" == "Linux" ]; then
    # Linux 系统
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
elif [[ "$OS" == MINGW64_NT* || "$OS" == MSYS* ]]; then
    # Windows 系统（Git Bash 或者 WSL）
    NVIM_CONFIG_DIR="$HOME/AppData/Local/nvim"
else
    echo "不支持的操作系统: $OS"
    exit 1
fi

# 仓库地址
GIT_REPO_URL="https://github.com/Egrvigrf/nvim.git"

# 如果配置目录存在，强制删除并重新克隆仓库
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo "$NVIM_CONFIG_DIR 目录存在，正在删除并重新克隆..."
    # 确认删除操作
    read -p "确定要删除 $NVIM_CONFIG_DIR 吗? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -rf "$NVIM_CONFIG_DIR"  # 删除该目录
        echo "目录已删除"
    else
        echo "操作取消"
        exit 1
    fi
else
    echo "配置目录不存在，准备克隆配置仓库..."
fi

# 克隆仓库
git clone "$GIT_REPO_URL" "$NVIM_CONFIG_DIR"

# 进入配置目录
cd "$NVIM_CONFIG_DIR" || { echo "无法进入目录！"; exit 1; }

# 检查仓库是否有更新
git fetch origin

# 获取当前的本地分支和远程分支状态
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

# 如果本地分支和远程分支不同，则进行更新
if [ "$LOCAL" != "$REMOTE" ]; then
    echo "有更新，开始拉取..."
    git pull origin main  # 假设你的默认分支是 main
    echo "更新完成!"
else
    echo "配置已经是最新的!"
fi
