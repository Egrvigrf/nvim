require("config.defaults")
require("config.keymaps")
require("config.autocmd")
require("config.lazy")
require("snippets.set")
--require 'lspconfig'.pyright.setup {}
require 'lspconfig'.clangd.setup {}
require 'lspconfig'.lua_ls.setup {}





