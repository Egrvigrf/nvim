return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",  -- 必须的依赖
    "echasnovski/mini.nvim",            -- 如果使用 mini.nvim 插件集
    "echasnovski/mini.icons",         -- 如果你使用独立的 mini.icons 插件
    -- "nvim-tree/nvim-web-devicons",   -- 如果你喜欢 nvim-web-devicons
  },
  config = function()
    require("render-markdown").setup({
      -- 插件的配置选项
      opts = {}  -- 如果你有自定义配置，可以在此添加
    })
  end,
  ft = "markdown",  -- 仅在打开 Markdown 文件时加载
  cmd = "RenderMarkdown",  -- 你可以用这个命令来触发插件
}

