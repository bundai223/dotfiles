require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
  },
  extensions = {
    file_browser = {
      theme = 'ivy',
      hijack_netrw = true
    }
  }
})

-- nmap <C-u> [denite]
vim.api.nvim_set_keymap("n", "[FuzzyFinder]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "[FuzzyFinder]", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "z", "[FuzzyFinder]", {})
vim.api.nvim_set_keymap("v", "z", "[FuzzyFinder]", {})
vim.api.nvim_set_keymap("n", "[FuzzyFinder]f", "<Cmd>Telescope find_files<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[FuzzyFinder]b", "<Cmd>Telescope buffers<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[FuzzyFinder]p", "<Cmd>Telescope git_files<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[FuzzyFinder]g", "<Cmd>Telescope live_grep<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[FuzzyFinder]m", "<Cmd>Telescope frecency<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[FuzzyFinder]n", "<Cmd>Telescope notify<CR>", { noremap = true, silent = true })
