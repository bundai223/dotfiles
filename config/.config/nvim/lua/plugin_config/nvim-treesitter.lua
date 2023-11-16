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
    enable = false
  },
  rainbow = {
    enable = true
  },
	pairs = {
		enable = true,
		disable = {},
		highlight_pair_events = { "CursorMoved" }, -- when to highlight the pairs, use {} to deactivate highlighting
		highlight_self = true,
		goto_right_end = false, -- whether to go to the end of the right partner or the beginning
		fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
		keymaps = { goto_partner = "'%" },
	}
}
