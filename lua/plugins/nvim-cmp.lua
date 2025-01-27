return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        'hrsh7th/cmp-path',
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'L3MON4D3/LuaSnip', -- LuaSnip 用于代码片段
        'saadparwaiz1/cmp_luasnip', -- cmp 的 LuaSnip 补全源
        'rafamadriz/friendly-snippets', -- 预设的代码片段集合
        'onsails/lspkind-nvim' -- 补全显示图例
    },
    config = function()
        local cmp = require'cmp'
        local luasnip = require'luasnip'
        local lspkind = require'lspkind'

        -- 加载友好的代码片段
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.fn.expand("$LOCALAPPDATA/nvim/lua/snippets") })

        local function tab(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end

        local function shift_tab(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- 启用 LuaSnip
                end,
            },
            window = {
                completion = cmp.config.window.bordered(), -- 启用边界
                documentation = cmp.config.window.bordered(), -- 启用边界
            },
            formatting = {
                format = lspkind.cmp_format({with_text = false, maxwidth = 50}) -- lspkind 配置
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(tab, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
                
                { name = 'luasnip' }, -- 添加 LuaSnip 作为补全源
                { name = 'buffer' },
                { name = 'nvim_lsp' },
                { name = 'path' },
            }, {
                
            }),
            completion = {
                keyword_length = 2,  -- 触发补全的最少字符数
                completeopt = 'menu,menuone,noinsert',  -- Vim 的补全选项
                max_item_count = 5,  -- 补全列表的最大项数
            }
        })

        -- 设置特定文件类型
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'git' },
            }, {
                { name = 'buffer' },
            })
        })

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
        })

        -- 设置 LSP
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- 设置 LSP servers
        require('lspconfig').clangd.setup {
            capabilities = capabilities,
            cmd = { "clangd" },
            root_dir = require('lspconfig').util.root_pattern(".git", "."),
            filetypes = { "c", "cpp", "objc", "objcpp" },
            single_file_support = true,
            on_attach = function(client, bufnr)
                -- 可以添加更多配置
            end,
        }

        require('lspconfig').pyright.setup {
            capabilities = capabilities,
        }

        require('lspconfig').lua_ls.setup {
            capabilities = capabilities,
        }

        -- 添加更多 LSP servers 示例
        require('lspconfig').tsserver.setup {
            capabilities = capabilities,
        }

        require('lspconfig').html.setup {
            capabilities = capabilities,
        }

        require('lspconfig').cssls.setup {
            capabilities = capabilities,
        }
    end,
}
