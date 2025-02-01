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

-- 剪贴板操作
k.set('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
k.set('n', '<C-v>', '"+p', { noremap = true, silent = true })
k.set('v', '<C-c>', '"+y', { noremap = true, silent = true })

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
    { "tanvirtin/monokai.nvim" },
    { "folke/tokyonight.nvim" },
    -- 基础插件
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    
    -- 代码片段
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
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
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
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
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
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

    -- treesitter
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
    --
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
        -- 设置快捷键格式化代码
        vim.api.nvim_set_keymap('n', '<Leader>f', ':lua require("conform").format()<CR>', { noremap = true, silent = true })
        end,
    },
    {
        'xeluxee/competitest.nvim',
        dependencies = 'MunifTanjim/nui.nvim',
        config = function()
            require('competitest').setup({
                template_file = vim.fn.stdpath("config") .. "/template.cpp",
            })
        end,
    },

})

-- 启动后配置
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        -- 选择主题
           vim.cmd([[colorscheme monokai_soda]])
        -- vim.cmd([[colorscheme tokyonight-storm]])
        -- vim.cmd([[colorscheme retrobox]])
        -- vim.cmd([[colorscheme habamax]])
        -- 初始化状态栏
        require("lualine").setup({
            options = { theme = "auto" },
            --sections = { lualine_a = { "mode" }, lualine_c = { "filename" } }
        })
    end
})


