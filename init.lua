require("config.defaults")
require("config.keymaps")
require("config.autocmd")
require("config.lazy")
require("snippets.set")
--require 'lspconfig'.pyright.setup {}
require 'lspconfig'.clangd.setup {}
require 'lspconfig'.lua_ls.setup {}




local dap = require('dap')

-- 每次启动时自动更新配置
local config_dir = vim.fn.stdpath('config')
local result = os.execute('cd ' .. config_dir .. ' && git pull origin main')

-- 监听 Git 更新结果并通过 dap 通知
if result == 0 then
    dap.set_log_level('INFO')
    dap.adapters['my_adapter'] = {
        type = 'server',
        host = 'localhost',
        port = 8080,
    }
    dap.listeners.after.event_initialized['my_listener'] = function()
        vim.notify("Neovim 配置已更新！", vim.log.levels.INFO)
    end
else
    dap.set_log_level('ERROR')
    dap.adapters['my_adapter'] = {
        type = 'server',
        host = 'localhost',
        port = 8080,
    }
    dap.listeners.after.event_initialized['my_listener'] = function()
        vim.notify("配置更新失败，请检查网络连接或 Git 仓库！", vim.log.levels.ERROR)
    end
end


