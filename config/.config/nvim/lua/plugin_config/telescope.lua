local lga_actions = require("telescope-live-grep-args.actions")

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
    },
    live_grep_args = {
      auto_quoting = false, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
})
