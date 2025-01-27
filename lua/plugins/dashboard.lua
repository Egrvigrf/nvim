-- 获取操作系统类型
local is_windows = vim.fn.has('win32') == 1
local config_path
local script_path

-- 获取 init.lua 的路径
if is_windows then
    -- Windows 系统的路径
    config_path = "$LOCALAPPDATA\\nvim\\init.lua"
    script_path = "$LOCALAPPDATA\\nvim\\update_config.sh"  -- 脚本路径与 init.lua 同级
else
    -- 非 Windows 系统的路径（例如 Linux）
    config_path = "~/.config/nvim/init.lua"
    script_path = "~/.config/nvim/update_config.sh"  -- 脚本路径与 init.lua 同级
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvimdev/dashboard-nvim"
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values

        telescope.setup {
            extensions = {},
        }

        -- 执行自定义的 update_config.sh 脚本
        local function update_config()
            -- 根据操作系统选择路径
            if is_windows then
                -- Windows 系统
                vim.fn.system('bash "' .. vim.fn.expand(script_path) .. '"')
            else
                -- Linux 或 macOS 系统
                vim.fn.system('bash ' .. vim.fn.expand(script_path))
            end
            print("配置文件已更新！")
        end

        require('dashboard').setup({
            theme = "doom", -- 或 'hyper'
            config = {
                header = {
                    "███████╗██╗      █████╗ ████████╗███████╗██████╗ ",
                    "██╔════╝██║     ██╔══██╗╚══██╔══╝██╔════╝██╔══██╗",
                    "█████╗  ██║     ███████║   ██║   █████╗  ██║  ██║",
                    "██╔══╝  ██║     ██╔══██║   ██║   ██╔══╝  ██║  ██║",
                    "███████╗███████╗██║  ██║   ██║   ███████╗██████╔╝",
                    "╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═════╝  "
                },
                center = {
                    {
                        icon = " ",
                        desc = "Recently Used Files ",
                        key = "r",
                        action = "Telescope oldfiles"
                    },
                    {
                        icon = " ",
                        desc = "Bookmarks           ",
                        key = "m",
                        action = "Telescope marks"
                    },
                    {
                        icon = " ",
                        desc = "Update Plugins      ",
                        key = "u",
                        action = "Lazy"
                    },
                    {
                        icon = " ",
                        desc = "Open Config         ",
                        key = "c",
                        action = "edit " .. config_path  -- 根据系统路径设置
                    },
                    {
                        icon = "⚙️ ",
                        desc = "Update Config       ",
                        key = "P",
                        action = update_config  -- 执行脚本更新配置
                    },
                },
                footer = {"Maomaochong", "~"},
            },
        })
    end
}
