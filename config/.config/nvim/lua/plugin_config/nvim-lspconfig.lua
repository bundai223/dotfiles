-- https://github.com/Pocco81/TheSupercalifragilisticexpialidociousDots/blob/main/.config/nvim/lua/nvdope/initialization/lsp/lspconfig.lua#L97-107

-- [Neovim builtin LSP設定入門](https://zenn.dev/nazo6/articles/c2f16b07798bab)
vim.api.nvim_set_keymap("n", "<leader>ld", "<Cmd>Trouble<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>lK", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true })

