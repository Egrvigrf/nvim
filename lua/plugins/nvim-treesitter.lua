return {
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "cpp", "lua", "vim", "vimdoc", "markdown", "markdown_inline", "python" },
                highlight = { 
                    enable = true,
                    additional_vim_regex_highlighting = { "cpp", "python" },
                },
                indent = { enable = true },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
            }



        end,
    }
}
