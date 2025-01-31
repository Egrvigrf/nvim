return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- 延迟加载，仅在进入插入模式时加载
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- LSP 补全源
    "hrsh7th/cmp-buffer", -- 缓冲区补全源
    "hrsh7th/cmp-path", -- 路径补全源
    "hrsh7th/cmp-cmdline", -- 命令行补全源
    "L3MON4D3/LuaSnip", -- LuaSnip 代码片段引擎
    "saadparwaiz1/cmp_luasnip", -- LuaSnip 补全源
    "rafamadriz/friendly-snippets", -- 预设代码片段集合
    "onsails/lspkind-nvim", -- 补全显示图标
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- 加载友好的代码片段
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.fn.expand("$LOCALAPPDATA/nvim/lua/snippets") })

    -- 自定义 Tab 键行为
    local function tab(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end

    -- 自定义 Shift-Tab 键行为
    local function shift_tab(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end

    -- 设置 cmp
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- 启用 LuaSnip
        end,
      },
      window = {
        completion = cmp.config.window.bordered(), -- 补全窗口带边框
        documentation = cmp.config.window.bordered(), -- 文档窗口带边框
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text", -- 显示图标和文本
          maxwidth = 50, -- 最大宽度
          ellipsis_char = "...", -- 超出宽度时显示省略号
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- 向上滚动文档
        ["<C-f>"] = cmp.mapping.scroll_docs(4), -- 向下滚动文档
        ["<C-Space>"] = cmp.mapping.complete(), -- 触发补全
        ["<C-e>"] = cmp.mapping.abort(), -- 关闭补全
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 确认选择
        ["<Tab>"] = cmp.mapping(tab, { "i", "s" }), -- Tab 键选择下一个
        ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "s" }), -- Shift-Tab 键选择上一个
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP 补全
        { name = "luasnip" }, -- LuaSnip 片段
        { name = "buffer" }, -- 缓冲区补全
        { name = "path" }, -- 路径补全
      }),
      completion = {
        keyword_length = 2, -- 触发补全的最少字符数
        completeopt = "menu,menuone,noinsert", -- 补全选项
        max_item_count = 10, -- 补全列表的最大项数
      },
    })

    -- 针对 C++ 文件类型的补全配置
    cmp.setup.filetype("cpp", {
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP 补全
        { name = "luasnip" }, -- LuaSnip 片段
        { name = "buffer" }, -- 缓冲区补全
      }),
    })

    -- 针对 Markdown 文件类型的补全配置
    cmp.setup.filetype("markdown", {
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP 补全
        { name = "buffer" }, -- 缓冲区补全
        { name = "path" }, -- 路径补全
      }),
    })

    -- 命令行补全配置
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }, -- 缓冲区补全
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" }, -- 路径补全
        { name = "cmdline" }, -- 命令行补全
      }),
    })
  end,
}
