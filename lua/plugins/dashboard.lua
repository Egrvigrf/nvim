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
                        action = function()
                            local config_dir
                            local config_path

                            if vim.fn.has('win32') == 1 then
                                config_dir = os.getenv("LOCALAPPDATA") .. "\\nvim"
                                config_path = config_dir .. "\\init.lua"
                            else
                                config_dir = os.getenv("HOME") .. "/.config/nvim"
                                config_path = config_dir .. "/init.lua"
                            end

                            -- 设置当前工作目录并打开配置文件
                            vim.cmd("cd " .. config_dir)
                            vim.cmd("edit " .. config_path)
                            vim.cmd("NvimTreeToggle")
                        end
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
