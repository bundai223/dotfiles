local lspsaga = require("lspsaga")

require('lspsaga').setup({})

-- mapping
vim.api.nvim_set_keymap("n", "<leader>lf", "<Cmd>Lspsaga lsp_finder<CR>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>lca", "<Cmd>Lspsaga code_action<CR>", { silent = true, noremap = true }) -- actions-preview.nvimにまかせた
-- vim.api.nvim_set_keymap("<Cmd>Lspsaga range_code_action<CR>", "<leader>lca", "v", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>lr", "<Cmd>Lspsaga rename<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>lp", "<Cmd>Lspsaga peek_definition<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>lld", "<Cmd>Lspsaga show_line_diagnostics<CR>",
  { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>lh", "<Cmd>Lspsaga hover_doc<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<Space>?", "<Cmd>Lspsaga hover_doc<CR>", { silent = true })
