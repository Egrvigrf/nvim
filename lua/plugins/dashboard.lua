return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
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
            extensions = {
                file_browser = {
                    hijack_netrw = true,
                    mappings = {
                        ["i"] = {
                            -- Custom insert mode mappings
                        },
                        ["n"] = {
                            ["<CR>"] = function(prompt_bufnr)
                                local current_picker = action_state.get_current_picker(prompt_bufnr)
                                local cwd = current_picker.cwd
                                local selection = action_state.get_selected_entry()
                                local path = selection.path or selection.filename

                                if vim.fn.isdirectory(path) == 1 then
                                    actions.close(prompt_bufnr)
                                    vim.cmd("lcd " .. path)
                                    telescope.extensions.file_browser.file_browser({ cwd = path })
                                else
                                    actions.select_default(prompt_bufnr)
                                    vim.cmd("lcd " .. cwd)
                                end
                            end,
                            ["h"] = function(prompt_bufnr)
                                local current_picker = action_state.get_current_picker(prompt_bufnr)
                                local cwd = current_picker.cwd
                                local parent_dir = vim.fn.fnamemodify(cwd, ":h")

                                if parent_dir ~= cwd then
                                    actions.close(prompt_bufnr)
                                    vim.cmd("lcd " .. parent_dir)
                                    telescope.extensions.file_browser.file_browser({ cwd = parent_dir })
                                else
                                    select_drive()
                                end
                            end,
                        },
                    },
                },
            },
        }

        telescope.load_extension('file_browser')

        local function browse_drive(drive)
            telescope.extensions.file_browser.file_browser({
                cwd = drive,
            })
        end

        function select_drive()
            local drives = {}
            for _, drive in ipairs({'C:\\', 'D:\\', 'E:\\', 'F:\\', 'G:\\', 'H:\\', 'I:\\', 'J:\\', 'K:\\'}) do
                if vim.fn.isdirectory(drive) == 1 then
                    table.insert(drives, drive)
                end
            end

            pickers.new({}, {
                prompt_title = "Select Drive",
                finder = finders.new_table {
                    results = drives,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry,
                            ordinal = entry,
                        }
                    end
                },
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        browse_drive(selection.value)
                    end)
                    return true
                end,
            }):find()
        end

        -- 配置 Dashboard
        require('dashboard').setup({
            theme = "doom", -- 或 'hyper'
            config = {
                header = {
                    "███████╗ ██████╗ ██████╗ ██╗   ██╗██╗ ██████╗ ██████╗ ███████╗",
                    "██╔════╝██╔════╝ ██╔══██╗██║   ██║██║██╔════╝ ██╔══██╗██╔════╝",
                    "█████╗  ██║  ███╗██████╔╝██║   ██║██║██║  ███╗██████╔╝█████╗  ",
                    "██╔══╝  ██║   ██║██╔══██╗╚██╗ ██╔╝██║██║   ██║██╔══██╗██╔══╝  ",
                    "███████╗╚██████╔╝██║  ██║ ╚████╔╝ ██║╚██████╔╝██║  ██║██║     ",
                    "╚══════╝ ╚═════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ",
                    "                                                              ",
                    "                                                              ",
                    "                                                              ",
                    "                                                              ",
                },
                center = {
                    {
                        icon = " ",
                        desc = "Recently Used Files ",
                        key = "r",
                        action = "Telescope oldfiles"
                    },
                    {
                        icon = " ",
                        desc = "Open File Browser ",
                        key = "o",
                        action = select_drive
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
                        action = "edit $LOCALAPPDATA\\nvim\\init.lua"
                    },
                },
                footer = {"I have a bugcat",
                            "~",
                        }, -- 自定义脚注
            },
        })
    end
}
