return {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
    require('mason-tool-installer').setup({
        ensure_installed = {
        --  "prettier",        -- JavaScript, TypeScript, CSS, etc.
        --  "black",           -- Python
        --  "stylua",          -- Lua
        --  "clang-format",    -- C, C++
        },
        auto_update = false,
        run_on_start = true,
      })
    end
}