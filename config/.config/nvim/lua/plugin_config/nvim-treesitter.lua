require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("my_treesitter_start", { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
