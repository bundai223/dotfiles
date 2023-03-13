require("telescope").setup({
  -- shorten_path = true,
  defaults = {
    path_display = { "smart" }, -- smart/truncate
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
