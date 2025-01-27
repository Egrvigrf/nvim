return {
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
}
