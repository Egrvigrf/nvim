-- 引入并配置 conform.nvim 插件
return {
    'stevearc/conform.nvim',
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" },
                -- 其他文件类型和格式化工具配置
            },
            formatters = {
                clang_format = {
                    exe = "clang-format",
                    args = function()
                        return {
                            "--assume-filename=" .. vim.fn.expand('%:p'),
                            [[--style={BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4, UseTab: Never, BreakBeforeBraces: Attach, ColumnLimit: 0}]]
                        }
                    end,
                    stdin = true
                }
            }
        })

        -- 设置快捷键来手动格式化代码
        vim.api.nvim_set_keymap('n', '<Leader>f', ':lua require("conform").format()<CR>', { noremap = true, silent = true })

        -- 自动格式化设置
        vim.cmd [[
            augroup ConformFormatAutogroup
                autocmd!
                autocmd BufWritePost * lua require("conform").format()
            augroup END
        ]]
    end
}
