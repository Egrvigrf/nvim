-- 基础设置
local options = {
  number = true,
  wrap = false,  -- 禁止换行
  mouse = "a",   -- 允许使用鼠标
  clipboard = "unnamedplus",
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

-- CompetitiveTest 快捷键
k.set('n', 'ca', ':CompetiTest add_testcase<CR>', { noremap = true, silent = true })
k.set('n', 'cr', ':CompetiTest run<CR>', { noremap = true, silent = true })
k.set('n', 'ce', ':CompetiTest edit_testcase<CR>', { noremap = true, silent = true })
k.set('n', 'ct', ':CompetiTest receive testcases<CR>', { noremap = true, silent = true })
k.set('n', 'cp', ':CompetiTest receive problem<CR>', { noremap = true, silent = true })
k.set('n', 'cc', ':CompetiTest receive contest<CR>', { noremap = true, silent = true })
k.set('n', 'cs', ':CompetiTest show_ui<CR>', { noremap = true, silent = true })

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

-- 字体大小调整
local FONT, SIZE = "FiraCode Nerd Font", 15
local function adjust(step)
  SIZE = math.max(1, SIZE + step)
  vim.opt.guifont = ("%s:h%d"):format(FONT, SIZE)
end
for _, v in ipairs({ { "<C-+>", 1 }, { "<C-=>", 1 }, { "<C-->", -1 } }) do
  vim.keymap.set("n", v[1], function() adjust(v[2]) end, { noremap = true, silent = true })
end
vim.opt.guifont = ("%s:h%d"):format(FONT, SIZE)  -- 初始化

-- 剪贴板增强操作 (支持系统剪贴板)
k.set('n', '<C-a>', 'ggVG', { noremap = true, silent = true })    -- 全选
k.set('n', '<C-c>', '"+y', { noremap = true, silent = true })     -- 复制当前行
k.set('n', '<C-v>', '"+p', { noremap = true, silent = true })     -- 粘贴
k.set('n', '<C-x>', '"+dd', { noremap = true, silent = true })    -- 剪切当前行

k.set('v', '<C-c>', '"+y', { noremap = true, silent = true })     -- 复制选中内容 
k.set('v', '<C-x>', '"+d', { noremap = true, silent = true })     -- 剪切选中内容
k.set('v', '<C-v>', '"_d"+P', { noremap = true, silent = true })  -- 替换粘贴（不会覆盖剪贴板）

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
          })
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        performance = { max_view_entries = 6 },
        completion = { keyword_length = 2 }
      })

      -- Cmdline 补全配置
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" }
        })
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
      

    vim.diagnostic.config({
        virtual_text = false, -- 完全关闭虚拟文本
        signs = true,         -- 左侧符号标记（如警告三角、错误叉号）
        float = {             -- 悬停时显示浮动窗口
        border = "rounded",
            source = "always",
        },
    })

    -- 绑定快捷键查看诊断
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics" })

      -- Clangd 增强配置
      require("lspconfig").clangd.setup({
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--completion-style=detailed",  -- 更详细的补全
          "--all-scopes-completion"       -- 全作用域补全
        }
      })
    end
  },

  -- 优化后的 C/C++ 格式化配置
  { 
    'stevearc/conform.nvim',
    ft = { "c", "cpp" },  -- 仅针对 C/C++ 文件加载
    config = function()
      local conform = require("conform")
      local get_clang_format_args = function()
        local fname = vim.api.nvim_buf_get_name(0)
        return {
          "--assume-filename=" .. (fname ~= "" and fname or "temp.cpp"),
          "--style={BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4, UseTab: Never, BreakBeforeBraces: Attach, ColumnLimit: 0}"
        }
      end

      conform.setup({
        formatters_by_ft = {
          c = { "clang_format" },
          cpp = { "clang_format" },
        },
        formatters = {
          clang_format = {
            exe = vim.fn.exepath("clang-format") or "clang-format",
            args = get_clang_format_args,
            stdin = true,
            timeout = 5000
          }
        }
      })

      vim.keymap.set("n", "<leader>f", function()
        conform.format({ async = true, lsp_fallback = true })
      end, { desc = "格式化代码" })
    end
  },

  -- 缩进线
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- 标签栏
  { "akinsho/bufferline.nvim" },

  -- mini.nvim 插件集
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.files').setup({
        mappings = {
          close       = 'q',
          go_in       = 'l',
          go_out      = 'h',
          synchronize = '<CR>',
        },
        windows = {
          preview = true,
          width_focus = 50,
        },
      })

      vim.keymap.set('n', '<leader>e', function()
        if not MiniFiles.close() then MiniFiles.open() end
      end, { desc = 'Toggle file explorer' })

      require('mini.pairs').setup()
      require('mini.icons').setup()
      require('mini.statusline').setup()
    end,
  },

  -- 竞赛编程插件
  {
    'xeluxee/competitest.nvim',
    dependencies = 'MunifTanjim/nui.nvim',
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.cmd([[colorscheme monokai]])
    require('bufferline').setup()
    require("ibl").setup()
    require('competitest').setup({
      template_file = vim.fn.stdpath("config") .. "/template.cpp",
      testcases_use_single_file = true,
      testcases_directory = "./testcases",
    })
  end
})
