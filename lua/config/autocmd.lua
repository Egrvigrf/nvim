function ChangeDirectoryToCurrentFile(show_notify)
    local current_file_path = vim.fn.expand('%:p:h')
    local current_file_name = vim.fn.expand('%:t')
    vim.cmd('cd ' .. current_file_path)
    if show_notify then
        vim.notify('Directory switched to: ' .. current_file_path, vim.log.levels.INFO)
    else
        vim.notify('Opened: ' .. current_file_name, vim.log.levels.INFO)
    end
end

-- 自动命令在每次打开文件时执行 ChangeDirectoryToCurrentFile 函数，并显示通知
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        ChangeDirectoryToCurrentFile(false)
    end,
})

-- 自定义保存函数
function SaveAndNotify()
    vim.cmd('write')  -- 执行实际的保存操作
end

-- 自定义保存并退出函数
function SaveAndQuitAndNotify()
    vim.cmd('write')  -- 执行实际的保存操作
    vim.cmd('quit')   -- 退出 Neovim
end

-- 重新定义 :w 命令
vim.api.nvim_create_user_command('W', function()
    SaveAndNotify()
end, {})

-- 重新定义 :wq 命令
vim.api.nvim_create_user_command('Wq', function()
    SaveAndQuitAndNotify()
end, {})

-- 重新绑定 :w 和 :wq 命令到新的自定义命令
vim.api.nvim_set_keymap('n', ':w', ':W<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ':wq', ':Wq<CR>', { noremap = true, silent = true })

-- 创建自动命令，当文件保存时触发通知
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        local current_file_name = vim.fn.expand('%:t')
        vim.notify('File saved: ' .. current_file_name, vim.log.levels.INFO)
    end,
})

-- 文件写入前执行 LSP 格式化
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        require('conform').format()
    end,
})

-- 进入插入模式时禁用高亮显示，并在离开插入模式时重新启用高亮显示
-- 创建自动命令组
local group = vim.api.nvim_create_augroup("IndentBlanklineScopeToggle", { clear = true })

-- 进入插入模式时禁用 scope 高亮显示
vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    pattern = "*",
    callback = function()
        local buftype = vim.api.nvim_buf_get_option(0, "buftype")
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if buftype == "" and not vim.tbl_contains({"help", "dashboard", "packer", "NvimTree"}, filetype) then
            vim.api.nvim_exec(":IBLDisableScope", false)
        end
    end,
})

-- 退出插入模式时启用 scope 高亮显示
vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    pattern = "*",
    callback = function()
        local buftype = vim.api.nvim_buf_get_option(0, "buftype")
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if buftype == "" and not vim.tbl_contains({"help", "dashboard", "packer", "NvimTree"}, filetype) then
            vim.api.nvim_exec(":IBLEnableScope", false)
        end
    end,
})
