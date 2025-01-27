return {
   "williamboman/mason-lspconfig.nvim",
   config = function()
       -- 配置 Mason 和 LSP 服务器
       require("mason").setup()
       require("mason-lspconfig").setup {
           ensure_installed = { "lua_ls", "clangd" }, -- 添加你需要的 LSP 服务器, "pyright"

       }

         -- 配置 LSP 诊断图标
        -- 配置 LSP 诊断图标
        --vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"})
        --vim.fn.sign_define("DiagnosticSignWarning", {text = "", texthl = "DiagnosticSignWarning"})
        --vim.fn.sign_define("DiagnosticSignInformation", {text = "", texthl = "DiagnosticSignInformation"})
        --vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})

        -- 配置 LSP 诊断高亮组
        vim.cmd [[
            highlight DiagnosticSignError guifg=#FF0000
            highlight DiagnosticSignWarning guifg=#FFA500
            highlight DiagnosticSignInformation guifg=#00FF00
            highlight DiagnosticSignHint guifg=#0000FF
        ]]
            
       -- 使用 nvim-web-devicons 设置文件图标
       require'nvim-web-devicons'.setup {
           default = true;
       }
   end,

}
