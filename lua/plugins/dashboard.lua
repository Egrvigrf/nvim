return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvimdev/dashboard-nvim",
        "folke/tokyonight.nvim",
        "catppuccin/nvim",
        "tanvirtin/monokai.nvim"
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values

        -- 读取主题配置
        local function load_theme()
            local theme_file = vim.fn.stdpath("config") .. "/theme.lua"
            local f = io.open(theme_file, "r")
            if f then
                local theme = f:read("*a"):match("%S+")
                f:close()
                if theme and theme ~= "" then
                    vim.cmd("colorscheme " .. theme)
                    return
                end
            end
            vim.cmd("colorscheme monokai_soda")
        end

        -- 保存主题配置
        local function save_theme(theme)
            local theme_file = vim.fn.stdpath("config") .. "/theme.lua"
            local f = io.open(theme_file, "w")
            if f then
                f:write(theme .. "\n")
                f:close()
            end
        end

        local function pick_theme()
            local themes = vim.fn.getcompletion('', 'color')
            local theme_plugins = { "tokyonight", "catppuccin", "monokai" }
            for _, theme in ipairs(theme_plugins) do
                if not vim.tbl_contains(themes, theme) then
                    table.insert(themes, theme)
                end
            end
            pickers.new({}, {
                prompt_title = "Select Theme",
                finder = finders.new_table(themes),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    map("i", "<CR>", function()
                        local selection = action_state.get_selected_entry()[1]
                        vim.cmd("colorscheme " .. selection)
                        save_theme(selection)
                        actions.close(prompt_bufnr)
                    end)
                    return true
                end,
            }):find()
        end

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
            theme = "doom",
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
                            local config_dir = vim.fn.stdpath("config")
                            local config_path = config_dir .. "/init.lua"
                            vim.cmd("cd " .. config_dir)
                            vim.cmd("edit " .. config_path)
                            vim.cmd("NvimTreeToggle")
                        end
                    },
                    {
                        icon = " ",
                        desc = "Change Theme        ",
                        key = "t",
                        action = pick_theme
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

        -- 加载主题
        load_theme()
    end
}



