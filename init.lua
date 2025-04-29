-- 基础设置
local options = {
    number = true,
    relativenumber = false,
    wrap = false,  -- 禁止换行
    mouse = "a",   -- 允许使用鼠标
    cmdheight = 1, -- 调整 lualine 下方 cmdline 的高度
    clipboard = "unnamedplus",
    cursorline = false,
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

-- 循环设置基本参数
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

k.set('n', '<F5>', function()
    vim.cmd('silent write')
    
    -- 获取纯文件名
    local filename = vim.fn.expand('%:t')
    local src = vim.fn.expand('%:p:S')  -- 自动处理空格路径
    local exe = vim.fn.expand('%<:p:S')..'.exe'

    -- 原始批处理脚本保持不变
    local batch_cmd = string.format([[
@echo off
chcp 65001 > nul
echo [Compile] "%s"
g++ -O2 "%s" -o "%s"
if %%ERRORLEVEL%% neq 0 (
    echo [Compile Error] && pause && exit
)
echo [Running]
"%s"
echo.
echo exit code: %%ERRORLEVEL%%
pause
]], src, src, exe, exe)

    -- 生成批处理文件
    local batch_file = os.tmpname()..'.bat'
    local fd = io.open(batch_file, 'w')
    fd:write(batch_cmd)
    fd:close()

    -- 转换路径格式并确保双引号包裹
    local win_path = batch_file:gsub('/', '\\')
    vim.fn.system(string.format(
        'start "%s" /WAIT cmd /c ""%s""',
        filename,
        win_path
    ))

    vim.defer_fn(function()
        os.remove(batch_file)
    end, 3000)
end, { noremap = true, silent = true })


-- 自定义命令跳转到设置
vim.api.nvim_create_user_command('Setting', function()
    local config_dir = vim.fn.stdpath('config')
    vim.cmd('cd ' .. config_dir .. ' | e init.lua')
end, { desc = 'Open Neovim config' })

-- 设置快捷键格式化代码
vim.api.nvim_set_keymap('n', '<Leader>f', ':lua require("conform").format()<CR>', { noremap = true, silent = true })

-- 字体大小调整
local default_font_size = 14
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
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- 主题插件
    { "tanvirtin/monokai.nvim", priority = 1000  },
    -- { "folke/tokyonight.nvim", priority = 1000  },
    -- { "ellisonleao/gruvbox.nvim", priority = 1000},

    -- 括号补全
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    
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
                    { name = "nvim_lsp"},
                    { name = "buffer", config = function() require("bufferline").setup{} end },
                    { name = "path" },
                }),

                performance = {
                    max_view_entries = 6    -- 总候选词最多显示6个
                },
                completion = {
                     keyword_length = 2  -- 输入至少3个字符后触发补全
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
            -- if vim.fn.executable("clang-format") == 0 then
            --     vim.cmd("MasonInstall clang-format --force")
            -- end
        end
    },
    
    -- 缩进线
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },

    -- 自动注释 快捷gcc gc
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

    -- 标签栏
    { "akinsho/bufferline.nvim"},
    
    -- 用自带的 :Ex 可以代替nerdtree 进入后v 分屏

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
})


vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.cmd([[colorscheme monokai]])
        require("ibl").setup() -- 启用缩进线
        require("bufferline").setup{} -- 启用上方标签栏 
    end
})


