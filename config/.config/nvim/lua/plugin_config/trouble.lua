require("trouble").setup({})

-- binding
vim.api.nvim_set_keymap("n", "<leader>ld", "<Cmd>Trouble<CR>", { noremap = true })
