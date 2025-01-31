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
    end,
}
