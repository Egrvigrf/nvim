-- 每次启动时自动更新配置
local config_dir = vim.fn.stdpath('config')
local result = os.execute('cd ' .. config_dir .. ' && git fetch origin')

-- 获取当前的本地分支和远程分支状态
local local_commit = vim.fn.system('git rev-parse @')
local remote_commit = vim.fn.system('git rev-parse origin/main')

if local_commit == remote_commit then
    -- 如果配置已经是最新的
    vim.notify("Neovim 配置已是最新的！", vim.log.levels.INFO, { timeout = 3000 })  -- 设置 3 秒
elseif result == 0 then
    -- 如果 Git 更新成功
    os.execute('cd ' .. config_dir .. ' && git pull origin main')
    vim.notify("Neovim 配置已更新！", vim.log.levels.INFO, { timeout = 3000 })  -- 设置 3 秒
else
    -- 如果更新失败，显示错误消息，停留时间更长
    vim.notify("配置更新失败，请检查网络连接或 Git 仓库！", vim.log.levels.ERROR, { timeout = 6000 })  -- 设置 5 秒
end