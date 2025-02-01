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

-- 使用 Lazy 插件管理器
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

-- 插件配置
require("lazy").setup({
    spec = {
        { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
        { "tanvirtin/monokai.nvim" },
        { "folke/tokyonight.nvim" },
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
        {
            "akinsho/bufferline.nvim",
            config = function()
                require("bufferline").setup{}
            end,
        },
        {
            "NeogitOrg/neogit",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "sindrets/diffview.nvim",
                "nvim-telescope/telescope.nvim",
            },
            config = true
        },
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                local lualine = require("lualine")
                local config_minimal = {
                    options = {
                        theme = "auto",
                        component_separators = { left = "|", right = "|" },
                        section_separators = { left = "", right = "" },
                    },
                    sections = {
                        lualine_a = { "mode" },
                        lualine_c = { "filename" },
                        lualine_x = { "filetype" },
                        lualine_y = { "progress" },
                        lualine_z = { "location" },
                    },
                }
                lualine.setup(config_minimal)
            end,
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            version = "v3",
            config = function()
            require("ibl").setup {
                    indent = {
                        char = '│',
                    },
                    exclude = {
                     buftypes = {"terminal"},
                        filetypes = {"help", "dashboard", "packer", "NvimTree"},
                    },
                    scope = {
                      enabled = true,
                        show_start = true,
                        show_end = true,
                    },
                }
            end,
        },
        {
            "nvim-tree/nvim-tree.lua",
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require('nvim-tree').setup {
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
                }
            end,
        },
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
        {
            "williamboman/mason.nvim",
            opts = {},
            config = function()
                require("mason").setup()
                if vim.fn.executable("clang-format") == 0 then
                    vim.cmd("MasonInstall clang-format --force<CR>")
                end
            end
        },
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
            },
            config = function()
                require("mason-lspconfig").setup({
                    ensure_installed = { "clangd" },
                })
                local signs = {
                    Error = "",
                    Warn = "",
                    Info = "",
                    Hint = "",
                }
                for type, icon in pairs(signs) do
                    local hl = "DiagnosticSign" .. type
                    vim.fn.sign_define(hl, { text = icon, texthl = hl })
                end
                vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#FF0000" })
                vim.api.nvim_set_hl(0, "DiagnosticSignWarning", { fg = "#FFA500" })
                vim.api.nvim_set_hl(0, "DiagnosticSignInformation", { fg = "#00FF00" })
                vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#0000FF" })
                local lspconfig = require("lspconfig")
                local capabilities = require("cmp_nvim_lsp").default_capabilities()
                lspconfig.clangd.setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,
        },
        {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" }, -- 同时支持命令行补全
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",                      -- 文件路径补全
    "hrsh7th/cmp-cmdline", 
    "onsails/lspkind-nvim",
    "L3MON4D3/LuaSnip",                     -- 代码片段支持
    "saadparwaiz1/cmp_luasnip",             -- luasnip 集成
    "rafamadriz/friendly-snippets",         -- 预设代码片段
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- 加载预设代码片段
    require("luasnip.loaders.from_vscode").lazy_load()

    -- 智能确认函数
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered({
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          col_offset = -1,    -- 对齐左侧
          side_padding = 0,   -- 去除多余padding
        }),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          before = function(entry, vim_item)
            -- 显示源名称
            vim_item.menu = string.format("[%s]", string.upper(entry.source.name))
            return vim_item
          end
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
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
        { name = "nvim_lsp", priority = 1000 },  -- LSP 最高优先级
        { name = "luasnip",  priority = 750 },   -- 代码片段
        { name = "buffer",   priority = 500 },   -- 缓冲区内容
        { name = "path",     priority = 250 },   -- 文件路径
      }),
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        }
      },
      experimental = {
        ghost_text = { hl_group = "Comment" },  -- 半透明预览文本
      },
      performance = {
        debounce = 50,         -- 输入延迟处理
        throttle = 100,        -- 补全请求间隔
        fetching_timeout = 200 -- 补全源超时
      }
    })

    -- 命令行补全配置
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }
      }
    })

    -- cmdline 补全配置
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" }
      })
    })
  end
},
        {
            'stevearc/conform.nvim',
            config = function()
                require("conform").setup({
                    formatters_by_ft = {
                        c = { "clang_format" },
                        cpp = { "clang_format" },
                    },
                    formatters = {
                        clang_format = {
                            exe = "clang-format",
                            args = function()
                                return {
                                    "--assume-filename=" .. vim.fn.expand('%:p'),
                                    [[--style={BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4, UseTab: Never, BreakBeforeBraces: Attach, ColumnLimit: 0}]]
                                }
                            end,
                            stdin = true
                        }
                    }
                })
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
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
})

-- 启用 clangd 自动补全
require 'lspconfig'.clangd.setup {}

-- 选择主题
-- vim.cmd([[colorscheme monokai_soda]])
-- vim.cmd([[colorscheme tokyonight]])
 vim.cmd([[colorscheme retrobox]])
-- vim.cmd([[colorscheme habamax]])
