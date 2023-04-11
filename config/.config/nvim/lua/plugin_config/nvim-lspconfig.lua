-- https://github.com/Pocco81/TheSupercalifragilisticexpialidociousDots/blob/main/.config/nvim/lua/nvdope/initialization/lsp/lspconfig.lua#L97-107
-- suppress error messages from lang servers
-- vim.notify = function(msg, log_level, opts)
--   if msg:match("exit code") then
--     return
--   end
--   if log_level == vim.log.levels.ERROR then
--     vim.api.nvim_err_writeln(msg)
--   else
--     vim.api.nvim_echo({ { msg } }, true, {})
--   end
-- end

-- [Neovim builtin LSP設定入門](https://zenn.dev/nazo6/articles/c2f16b07798bab)
vim.api.nvim_set_keymap("n", "<leader>ld", "<Cmd>Trouble<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>lK", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true })

