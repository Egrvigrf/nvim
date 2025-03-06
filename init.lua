-- 基础设置
local options = {
    number = true,
    relativenumber = false,
    wrap = false,  -- 禁止换行
    mouse = "a",   -- 允许使用鼠标
    cmdheight = 1, -- 调整 lualine 下方 cmdline 的高度
    clipboard = "unnamedplus",
    cursorline = true,
    fileencoding = "utf-8",
    hlsearch = true,
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    autoindent = true,
    termguicolors = true,
    signcolumn = "yes",
    ignorecase = true, -- 启用搜索时不区分大小写
    smartcase = true,
    splitright = true,
    splitbelow = true,
    swapfile = false, -- 禁用交换文件
    backup = false,   -- 禁用文件备份
}

--nvim光标设置
vim.opt.guicursor = table.concat({
  "n:block-Cursor",          -- 普通模式：方块
  "i:hor20-rCursor",         -- 插入模式：下划线
  "v:block-vCursor-blinkon0",-- 可视模式：方块（不闪烁）
  "r:hor20-rCursor",         -- 替换模式：下划线
  "c:block-cCursor",         -- 命令模式：方块
  "sm:block-blinkwait0",     -- 匹配模式
  "a:blinkon0"              -- 禁用所有闪烁
}, ",")

-- 用一个循环来设置基本参数
for key, value in pairs(options) do
    vim.opt[key] = value
end

-- 自动加载 C++ 模板
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.cpp",
    callback = function()
        local template_path = vim.fn.stdpath("config") .. "/template.cpp"
        if vim.fn.filereadable(template_path) == 1 then
            local content = vim.fn.readfile(template_path)
            vim.api.nvim_buf_set_lines(0, 0, 0, false, content)
        end
    end
})

-- 键位映射
local k = vim.keymap
vim.g.mapleader = " "

-- 清除搜索高亮
k.set("n", "<leader>nh", ":nohl<CR>")

-- 编译并运行 C++ 文件
function CompileAndRun()
    vim.cmd("write")  -- 保存文件
    local filepath = vim.fn.expand('%:p')  -- 获取当前文件的完整路径
    local output_name = vim.fn.expand('%:t:r')  -- 获取当前文件名（不带扩展名）

    if vim.fn.has("unix") == 1 then
        vim.cmd("lcd " .. vim.fn.expand('%:p:h'))
        local compile_cmd = string.format("g++ -std=c++20 \"%s\" -o \"%s\"", filepath, output_name)
        local run_cmd = string.format("./%s", output_name:match("([^/]+)$"))
        if vim.fn.system(compile_cmd) == "" then
            vim.cmd(string.format("vsplit | term bash -c \"%s\"", run_cmd))
        end
    elseif vim.fn.has("win32") == 1 then
        vim.cmd(string.format(
            "vsplit | term g++ \"%s\" -o \"%s\" && \"%s\"",
            filepath, output_name, output_name
        ))
    end
    vim.cmd("startinsert")  -- 打开终端后自动进入插入模式
end

k.set('n', '<F5>', ':lua CompileAndRun()<CR>', { noremap = true, silent = true })

-- 切换 NvimTree 文件管理窗口
k.set('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- 自定义命令跳转到设置
vim.api.nvim_create_user_command('Setting', function()
    local config_dir = vim.fn.stdpath('config')
    vim.cmd('cd ' .. config_dir .. ' | e init.lua | echo "Neovim config opened"')
end, { desc = 'Open Neovim config' })

-- Neogit
k.set('n', '<C-g>', ':Neogit<CR>', { noremap = true, silent = true })
-- MarkdownPreview
k.set('n', '<C-m>', ':MarkdownPreview<CR>', { noremap = true, silent = true })
-- CompetitiveTest 快捷键
k.set('n', 'ca', ':CompetiTest add_testcase<CR>', { noremap = true, silent = true })
k.set('n', 'cr', ':CompetiTest run<CR>', { noremap = true, silent = true })
k.set('n', 'ce', ':CompetiTest edit_testcase<CR>', { noremap = true, silent = true })
k.set('n', 'ct', ':CompetiTest receive testcases<CR>', { noremap = true, silent = true })
k.set('n', 'cp', ':CompetiTest receive problem<CR>', { noremap = true, silent = true })
k.set('n', 'cc', ':CompetiTest receive contest<CR>', { noremap = true, silent = true })
k.set('n', 'cs', ':CompetiTest show_ui<CR>', { noremap = true, silent = true })

-- 设置快捷键格式化代码
vim.api.nvim_set_keymap('n', '<Leader>f', ':lua require("conform").format()<CR>', { noremap = true, silent = true })

-- 字体大小调整
local default_font_size = 12
local current_font_size = default_font_size

local function set_font_size(size)
    vim.opt.guifont = string.format("FiraCode Nerd Font:h%d", size)
end

local function increase_font_size()
    current_font_size = current_font_size + 1
    set_font_size(current_font_size)
end

local function decrease_font_size()
    current_font_size = current_font_size - 1
    set_font_size(current_font_size)
end

k.set("n", "<C-+>", ":lua increase_font_size()<CR>", { noremap = true, silent = true })
k.set("n", "<C-=>", ":lua increase_font_size()<CR>", { noremap = true, silent = true })
k.set("n", "<C-->", ":lua decrease_font_size()<CR>", { noremap = true, silent = true })

set_font_size(default_font_size)

-- local k = vim.keymap
local opts = { noremap = true, silent = true }

-- 剪贴板增强操作 (支持系统剪贴板)
k.set('n', '<C-a>', 'ggVG', { noremap = true, silent = true })    -- 全选
k.set('n', '<C-c>', '"+y', { noremap = true, silent = true })     -- 复制当前行
k.set('n', '<C-v>', '"+p', { noremap = true, silent = true })     -- 粘贴
k.set('n', '<C-x>', '"+dd', { noremap = true, silent = true })    -- 剪切当前行

k.set('v', '<C-c>', '"+y', { noremap = true, silent = true })     -- 复制选中内容 
k.set('v', '<C-x>', '"+d', { noremap = true, silent = true })     -- 剪切选中内容
k.set('v', '<C-v>', '"_d"+P', { noremap = true, silent = true })  -- 替换粘贴（不会覆盖剪贴板）



-- leader + f 格式化cpp代码
vim.api.nvim_set_keymap('n', '<Leader>f', ':lua require("conform").format()<CR>', { noremap = true, silent = true })



-- LSP 基础配置
local on_attach = function(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    k.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    k.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    k.set('n', 'K', vim.lsp.buf.hover, bufopts)
    k.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    k.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
end

-- 插件管理器初始化
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- 主题插件
    { "tanvirtin/monokai.nvim", priority = 1000  },
    { "folke/tokyonight.nvim", priority = 1000  },
    { "ellisonleao/gruvbox.nvim", priority = 1000},


    -- 基础插件
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    

    -- Mason
    {
        "williamboman/mason.nvim",
        opts = {},
        config = function()
            require("mason").setup()
                if vim.fn.executable("clang-format") == 0 then
                    vim.cmd("MasonInstall clang-format --force")
            end
        end
    },


    -- 补全系统
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            -- local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 15,
                        ellipsis_char = "...",
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources(
                {
                    {
                    name = "nvim_lsp",
                    entry_filter = function(entry)
                    local item = entry:get_completion_item()
                        if not item.kind then return true end

                        -- 禁用的补全类型列表
                        local disabled_kinds = {
                        --    vim.lsp.protocol.CompletionItemKind.Interface,
                            vim.lsp.protocol.CompletionItemKind.EnumMember,
                        --    vim.lsp.protocol.CompletionItemKind.Snippet,
                        }

                        -- 循环检查补全项的 kind 是否在禁用列表中
                        for _, kind in ipairs(disabled_kinds) do
                            if item.kind == kind then
                                return false  -- 如果是禁用类型，直接排除
                            end
                        end

                        return true  -- 其他类型允许继续
                    end
                },
                    { name = "buffer", config = function() require("bufferline").setup{} end },
                    { name = "path" },
                }),
                experimental = {
                    ghost_text = { hl_group = "Comment" },  -- 半透明预览文本
                },
            })
        end
    },
    

    -- LSP 配置
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
            })
            
            -- 诊断图标
            local signs = { Error = "", Warn = "", Info = "", Hint = "" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl })
            end

            -- Clangd 配置
            require("lspconfig").clangd.setup({
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                on_attach = on_attach,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=never",
                }
            })
        end
    },


    --文件浏览树
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require('nvim-tree').setup({
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                },
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
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
                    global = true,
                },
                },
                hijack_directories = {
                    enable = true,
                    auto_open = true,
                },
            })
        end,
    },


    -- treesitter语法高亮
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "cpp" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "cpp" },
                },
                indent = { enable = true },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
            }
        end,
    }, 


    -- 缩进线
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "▏", tab_char = "▏" },
            scope = { show_start = false, show_end = false },
            exclude = { filetypes = { "help", "dashboard", "NvimTree", "Trouble" } }
        }
    },


    -- 自动注释
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                ft = {
                    cpp = {
                        line = '//%s',
                        block = '/*%s*/',
                        },
                    },
                })
        end,
    },


    -- neogit
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = true
    },


    -- 其他插件
    { "akinsho/bufferline.nvim",config = function() require("bufferline").setup{} end },
    { "nvim-tree/nvim-web-devicons" }, -- lualine依赖
    { "nvim-lualine/lualine.nvim"},


    -- cpp格式化
    { 'stevearc/conform.nvim',
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    c = { "clang_format" },
                    cpp = { "clang_format" },
                },
                formatters = {
                    clang_format = {
                        exe = "clang-format",  -- 指定 clang-format 可执行文件
                        args = function()
                            return {
                                "--assume-filename=" .. vim.fn.expand('%:p'),  -- 传递当前文件名
                                "--style={BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4, UseTab: Never, BreakBeforeBraces: Attach, ColumnLimit: 0}"
                            }
                        end,
                        stdin = true  -- 通过标准输入传递文件内容
                    }
                }
            })
        end,
    },
    

    --nvim版cph
    {
        'xeluxee/competitest.nvim',
        dependencies = 'MunifTanjim/nui.nvim',
    },


    --markdown预览
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },


    --美化插件
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
        "MunifTanjim/nui.nvim",
        --"rcarriga/nvim-notify",
        }
    },


    --Dashboard
    {
        'nvimdev/dashboard-nvim',
        dependencies = { {'nvim-tree/nvim-web-devicons'}},
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                theme = 'hyper',
                config = {
                week_header = {
                     enable = true,
                 },
                 footer = { 'Happy'},
                shortcut = {
                    { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },

                    {
                         icon = ' ',
                         icon_hl = '@variable',
                         desc = 'Files',
                         group = 'Label',
                         action = 'Telescope find_files',
                         key = 'f',
                    },

                    {
                        icon = '󰡯 ',
                         icon_hl = '@variable',
                         desc = 'Receive_problem',
                         group = 'Label',
                         action = 'CompetiTest receive problem',
                         key = 'r',
                    },

                    { 
                         icon = ' ',
                         desc = 'Setting',
                         group = 'DiagnosticHint',
                         action = 'Setting',
                         key = 's',
                    },

                    { 
                         icon = ' ',
                         desc = 'Themes',
                         group = 'Number',
                         action = telescope_theme_picker,
                         key = 't',
                    },


                },
            },
        }
        end,
    },
    
})

themes = {
    'monokai',
    'tokyonight-storm',
    'gruvbox',
    'retrobox',
    'habamax', 
}

function telescope_theme_picker()
  require("telescope.pickers").new({}, {
    prompt_title = "🎨 选择主题",
    finder = require("telescope.finders").new_table({
      results = themes,
      entry_maker = function(entry)
        return {
          value = entry,
          display = "  " .. entry,
          ordinal = entry,
        }
      end
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        vim.cmd("colorscheme " .. selection.value)
        vim.notify("主题已应用: " .. selection.value, vim.log.levels.INFO)
      end)
      return true
    end
  }):find()
end


-- 创建一个函数来更新 theme.txt 文件
local config_dir = vim.fn.stdpath("config")
local function update_theme_file(theme_name)
    local theme_file = config_dir .. "/theme.txt"
    -- 打开文件进行写入
    local file = io.open(theme_file, "w")
    if file then
        file:write(theme_name) 
        file:close()
    end
end
-- 主题变化后保存
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local theme_name = vim.g.colors_name
        update_theme_file(theme_name)
    end
})
-- 初始化时读取 theme.txt 文件并设置主题
local function load_theme_from_file()
    local theme_file = config_dir .. "/theme.txt"
    local theme_name = ""
    local file = io.open(theme_file, "r")
    if file then
        theme_name = file:read("*line")  -- 读取第一行作为主题名称
        file:close()
    end
    if theme_name and theme_name ~= "" then
        vim.cmd("colorscheme " .. theme_name)
    else
        -- 如果没有有效主题，设置默认主题
           vim.cmd([[colorscheme monokai]])
        -- vim.cmd([[colorscheme tokyonight-storm]])
        -- vim.cmd([[colorscheme retrobox]])
        -- vim.cmd([[colorscheme habamax]])
        -- vim.cmd([[colorscheme gruvbox]])
    end
end
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        load_theme_from_file()
        require("lualine").setup({
            options = { theme = "auto" },
            --sections = { lualine_a = { "mode" }, lualine_c = { "filename" } }
        })
        require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                 ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
        })
        require('competitest').setup({
            template_file = vim.fn.stdpath("config") .. "/template.cpp",
        })
    end
})


