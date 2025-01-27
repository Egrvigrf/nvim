#!/bin/bash

# 设置默认的配置目录
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# 仓库地址
GIT_REPO_URL="https://github.com/Egrvigrf/nvim.git"

# 如果配置目录不存在，或者不是 Git 仓库，则删除并重新克隆仓库
if [ -d "$NVIM_CONFIG_DIR" ]; then
    if [ ! -d "$NVIM_CONFIG_DIR/.git" ]; then
        echo "$NVIM_CONFIG_DIR 目录存在，但不是 Git 仓库，正在删除并重新克隆..."
        rm -rf "$NVIM_CONFIG_DIR"  # 删除该目录
    else
        echo "配置目录已存在且是 Git 仓库，跳过删除。"
    fi
else
    echo "配置目录不存在，正在克隆配置仓库..."
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
