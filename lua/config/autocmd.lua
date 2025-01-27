-- 自动命令：文件保存时触发 LSP 格式化
-- vim.api.nvim_create_autocmd("BufWritePre", {
--    pattern = "*",
--    callback = function()
--        require('conform').format()
--    end,
-- })

-- 进入插入模式时禁用高亮显示
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
