local dap = require('dap')

-- 每次启动时自动更新配置
local config_dir = vim.fn.stdpath('config')

-- 执行 git fetch 获取远程最新数据
local fetch_result = os.execute('cd ' .. config_dir .. ' && git fetch origin')

-- 获取本地和远程的最新提交 ID
local local_commit = vim.fn.system('git rev-parse @') -- 本地提交
local remote_commit = vim.fn.system('git rev-parse origin/main') -- 远程提交

-- 如果本地提交和远程提交不相同，执行拉取操作
if local_commit ~= remote_commit then
    if fetch_result == 0 then
        -- 如果 fetch 成功，执行 git pull
        os.execute('cd ' .. config_dir .. ' && git pull origin main')
        vim.notify("Neovim 配置已更新！", vim.log.levels.INFO, { timeout = 3000 })  -- 设置 3 秒
    else
        -- 如果 fetch 失败，显示错误消息
        vim.notify("配置更新失败，请检查网络连接或 Git 仓库！", vim.log.levels.ERROR, { timeout = 5000 })  -- 设置 5 秒
    end
else
    -- 如果配置已经是最新的
    vim.notify("Neovim 配置已是最新的！", vim.log.levels.INFO, { timeout = 3000 })  -- 设置 3 秒
end

