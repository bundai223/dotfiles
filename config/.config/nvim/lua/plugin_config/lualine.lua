local navic = require("nvim-navic")

require('lualine').setup({
  sections = {
    lualine_c = {
      { navic.get_location, cond = navic.is_available_navic },
    }
  }
})
