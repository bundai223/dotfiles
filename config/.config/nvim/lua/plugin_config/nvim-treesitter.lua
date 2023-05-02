require 'nvim-treesitter.configs'.setup {
  endwise = {
    enable = true
  },
  matchup = {
    enable = true,
  },
  highlight = {
    enable = true,
    disable = {},
  },
  textobjects = {
    select = {
      enable = true,

      -- automatically jump forward to text obj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner"
      }
    }
  },
  yati = {
    enable = true,
    disable = {
      "markdown"
    },
    default_lazy = true
  },
  indent = {
    enable = true
  },
  rainbow = {
    enable = true
  }
}
