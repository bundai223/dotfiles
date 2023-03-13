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
