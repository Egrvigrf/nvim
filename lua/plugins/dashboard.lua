-- 获取操作系统类型
local is_windows = vim.fn.has('win32') == 1
local config_path
local script_path

-- 获取 init.lua 的路径
if is_windows then
    -- Windows 系统的路径
    config_path = "$LOCALAPPDATA\\nvim\\init.lua"
else
    -- 非 Windows 系统的路径（例如 Linux）
    config_path = "~/.config/nvim/init.lua"

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

        local function generate_unique_filename(base_name)
            local i = 1
            local filename = base_name .. ".cpp"
            while vim.fn.filereadable(filename) == 1 do
                filename = base_name .. i .. ".cpp"
                i = i + 1
            end
            return filename
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
                        icon = "  ",
                        desc = "New file                                ",
                        action = function()
                          local filename = generate_unique_filename("tmp")
                          vim.cmd("e " .. filename)
                        end,
                        key = "e",
                    }
                },
 
                footer = {"Maomaochong", "~"},
            },
        })
    end
}
