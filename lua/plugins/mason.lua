return {
  -- Mason.nvim
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- Mason Tool Installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "clang-format", -- C, C++
        "clangd",
      },
      auto_update = false,
      run_on_start = true,
    },
  },

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 配置 Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "markdown_oxide" }, -- 自动安装的 LSP 服务器
      })

      -- 配置 LSP 诊断图标
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

      -- 配置 LSP 诊断高亮组
      vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#FF0000" })
      vim.api.nvim_set_hl(0, "DiagnosticSignWarning", { fg = "#FFA500" })
      vim.api.nvim_set_hl(0, "DiagnosticSignInformation", { fg = "#00FF00" })
      vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#0000FF" })

      -- 配置 LSP 客户端
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 通用 on_attach 函数
      -- local on_attach = function(client, bufnr)
      --   -- 绑定快捷键
      --   vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "跳转定义" })
      --   vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "查找引用" })
      --   vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "查看文档" })
      --   vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "代码操作" })
      --   vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, { buffer = bufnr, desc = "格式化文件" })
      --   vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = bufnr, desc = "下一个诊断" })
      --   vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "上一个诊断" })
      --   vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { buffer = bufnr, desc = "查看诊断详情" })
      -- end

      -- 通用 LSP 配置
      local common_setup = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Lua LSP 配置
      lspconfig.lua_ls.setup(vim.tbl_extend("force", common_setup, {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }, -- 忽略 `vim` 全局变量的未定义警告
            },
            telemetry = {
              enable = false, -- 禁用遥测
            },
          },
        },
      }))

      -- Clangd LSP 配置
      lspconfig.clangd.setup(common_setup)

      -- Markdown Oxide LSP 配置
      lspconfig.markdown_oxide.setup(vim.tbl_extend("force", common_setup, {
        settings = {
          markdown = {
            lint = {
              enabled = true, -- 启用语法检查
              rules = {
                ["heading-increment"] = "error", -- 标题层级必须递增
                ["no-duplicate-heading"] = "warn", -- 禁止重复标题
                ["no-missing-space-atx"] = "error", -- 标题后必须加空格
                ["ul-style"] = "warn", -- 列表项必须统一使用 `-` 或 `*`
              },
            },
          },
        },
      }))
    end,
  },
}
