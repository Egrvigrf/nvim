return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    -- 配置 1：默认配置
    local config_default = {
      options = {
        theme = "auto", -- 自动根据 Neovim 主题选择
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }

    -- 配置 2：简洁风格
    local config_minimal = {
      options = {
        theme = "tokyonight",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }

    -- 配置 3：LSP 状态显示
    local config_lsp = {
      options = {
        theme = "onedark",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_active_clients()
              if next(clients) == nil then
                return "No LSP"
              end
              local client_names = {}
              for _, client in ipairs(clients) do
                table.insert(client_names, client.name)
              end
              return "LSP: " .. table.concat(client_names, ", ")
            end,
            icon = "",
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }

    -- 配置 4：Git 和诊断信息
    local config_git_diagnostics = {
      options = {
        theme = "dracula",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = { "diff", "diagnostics" },
        lualine_y = { "filetype" },
        lualine_z = { "progress" },
      },
    }

    -- 配置 5：夜间模式
    local config_nightfly = {
      options = {
        theme = "nightfly",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }

    -- 配置 6：Catppuccin 主题
    local config_catppuccin = {
      options = {
        theme = "catppuccin",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }

    -- 配置 7：Gruvbox 主题
    local config_gruvbox = {
      options = {
        theme = "gruvbox",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }

    -- 配置 8：Monokai 主题
    local config_monokai = {
      options = {
        theme = {
          normal = {
            a = { fg = "#272822", bg = "#a6e22e", gui = "bold" }, -- 绿色
            b = { fg = "#f8f8f2", bg = "#272822" },
            c = { fg = "#f8f8f2", bg = "#272822" },
          },
          insert = {
            a = { fg = "#272822", bg = "#66d9ef", gui = "bold" }, -- 蓝色
          },
          visual = {
            a = { fg = "#272822", bg = "#ae81ff", gui = "bold" }, -- 紫色
          },
          replace = {
            a = { fg = "#272822", bg = "#f92672", gui = "bold" }, -- 红色
          },
          command = {
            a = { fg = "#272822", bg = "#e6db74", gui = "bold" }, -- 黄色
          },
          inactive = {
            a = { fg = "#f8f8f2", bg = "#272822", gui = "bold" },
            b = { fg = "#f8f8f2", bg = "#272822" },
            c = { fg = "#f8f8f2", bg = "#272822" },
          },
        },
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }

    -- 配置 9：Old Config（你原来的配置）
    local old_config = {
    options = {
      component_separators = '',
      section_separators = '',
      theme = {
        normal = { c = { fg = '#bbc2cf', bg = '#202328' } },
        inactive = { c = { fg = '#bbc2cf', bg = '#202328' } },
      },
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {
        {
          function()
            return '▊'
          end,
          color = { fg = '#51afef' },
          padding = { left = 0, right = 1 },
        },
        {
          function()
            return ''
          end,
          color = function()
            local mode_color = {
              n = '#ec5f67',
              i = '#98be65',
              v = '#51afef',
              [''] = '#51afef',
              V = '#51afef',
              c = '#c678dd',
              no = '#ec5f67',
              s = '#FF8800',
              S = '#FF8800',
              [''] = '#FF8800',
              ic = '#ECBE7B',
              R = '#a9a1e1',
              Rv = '#a9a1e1',
              cv = '#ec5f67',
              ce = '#ec5f67',
              r = '#008080',
              rm = '#008080',
              ['r?'] = '#008080',
              ['!'] = '#ec5f67',
              t = '#ec5f67',
            }
            return { fg = mode_color[vim.fn.mode()] }
          end,
          padding = { right = 1 },
        },
        'filesize',
        {
          'filename',
          color = { fg = '#c678dd', gui = 'bold' },
        },
        'location',
        { 'progress', color = { fg = '#bbc2cf', gui = 'bold' } },
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = { error = ' ', warn = ' ', info = ' ' },
          diagnostics_color = {
            color_error = { fg = '#ec5f67' },
            color_warn = { fg = '#ECBE7B' },
            color_info = { fg = '#008080' },
          },
        },
        {
          function()
            return '%='
          end,
        },
        {
          function()
            local msg = 'No Active Lsp'
            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then
              return msg
            end
            for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
              end
            end
            return msg
          end,
          icon = ' LSP:',
          color = { fg = '#ffffff', gui = 'bold' },
        },
      },
      lualine_x = {
        {
          'o:encoding',
          fmt = string.upper,
          color = { fg = '#98be65', gui = 'bold' },
        },
        {
          'fileformat',
          fmt = string.upper,
          icons_enabled = false,
          color = { fg = '#98be65', gui = 'bold' },
        },
        {
          'branch',
          icon = '',
          color = { fg = '#a9a1e1', gui = 'bold' },
        },
        {
          'diff',
          symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
          diff_color = {
            added = { fg = '#98be65' },
            modified = { fg = '#FF8800' },
            removed = { fg = '#ec5f67' },
          },
        },
        {
          function()
            return '▊'
          end,
          color = { fg = '#51afef' },
          padding = { left = 1 },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
}


    -- 选择配置
    -- local selected_config = config_default -- 默认配置
       local selected_config = config_minimal -- 简洁风格
    -- local selected_config = config_lsp -- LSP 状态显示
    -- local selected_config = config_git_diagnostics -- Git 和诊断信息
    -- local selected_config = config_nightfly -- 夜间模式
    -- local selected_config = config_catppuccin -- Catppuccin 主题
    -- local selected_config = config_gruvbox -- Gruvbox 主题
    -- local selected_config = config_monokai -- Monokai 主题
    -- local selected_config = old_config -- 你原来的配置

    -- 应用配置
    lualine.setup(selected_config)
  end,
}
