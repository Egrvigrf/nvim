return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('nvim-tree').setup {
            update_focused_file = {
                enable = true,
                update_cwd = true, -- 切换目录时更新当前工作目录
            },
            sync_root_with_cwd = true, -- 同步 nvim-tree 根目录与全局 cwd
            respect_buf_cwd = true, -- 使 nvim-tree 尊重缓冲区的 cwd
            view = {
                width = 30,
                side = 'left',
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
                change_dir = {
                    enable = true,
                    global = true, -- 使用全局 cwd
                },
            },
            hijack_directories = {
                enable = true,
                auto_open = true,
            },
        }

        -- 快捷键 ctrl+t 返回上级目录
        vim.keymap.set('n', '<C-t>', function()
            local api = require('nvim-tree.api')
            api.tree.change_root_to_parent()
            vim.cmd('cd ' .. vim.fn.expand('%:p:h')) -- 更改当前工作目录
        end, {
            desc = 'nvim-tree: Up',
            noremap = true,
            silent = true,
            nowait = true
        })

        -- 快捷键 ctrl+n 进入选中文件夹
        vim.keymap.set('n', '<C-n>', function()
            local api = require('nvim-tree.api')
            api.tree.change_root_to_node()
            vim.cmd('cd ' .. vim.fn.expand('%:p:h')) -- 更改当前工作目录
        end, {
            desc = 'nvim-tree: Down',
            noremap = true,
            silent = true,
            nowait = true
        })

        -- 使用 `:cd` 命令更改 `nvim-tree` 目录
        vim.api.nvim_create_autocmd("DirChanged", {
            pattern = "*",
            callback = function()
                require('nvim-tree.api').tree.change_root(vim.fn.getcwd())
            end,
        })
    end,
}
