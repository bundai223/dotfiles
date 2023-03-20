-- https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
vim.o.timeout = true
vim.o.timeoutlen = 300

local wk = require("which-key")
wk.setup({
  plugins = {
    marks = true,     -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true,
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
    -- z=でspell suggestion
    spelling = {
      enabled = true,
      suggestions = 20
    }
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+",      -- symbol prepended to a group
  },
  window = {
    border = "none",          -- none, single, double, shadow
    position = "bottom",      -- bottom, top
    margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 },                                             -- min and max height of the columns
    width = { min = 20, max = 50 },                                             -- min and max width of the columns
    spacing = 3,                                                                -- spacing between columns
  },
  ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true,                                                             -- show help message on the command line when the popup is visible
  show_keys = true,                                                             -- show the currently pressed key and its label as a message in the command line
  triggers = "auto",                                                            -- automatically setup triggers
  -- triggers = { "<Leader>", "[FuzzyFinder]" }, -- or specify a list manually
})

vim.api.nvim_set_keymap("n", "<leader><CR>", "<Cmd>WhichKey <CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "[FuzzyFinder]<CR>", "<Cmd>WhichKey [FuzzyFinder]<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "[myleader]<CR>", "<Cmd>WhichKey [myleader]<CR>", { noremap = true })

-- for dir in io.popen([[git config --list | grep -i include | sed 's/^.*=//g']]):lines() do print(dir) end
-- git config --list | grep -i 'init.templatedir\|core.attributesfile\|core.excludesfile'

wk.register(
  {
    b = {
      name = 'buffers',
      l = { ':Telescope buffers<cr>', 'listup buffers' },
    },
    f = {
      name = 'file',
      e = {
        name = "edit conf",
        g = {
          name = 'git',
          c = { ':e ~/.gitconfig<cr>', '~/.gitconfig' },
        },
        n = {
          name = 'nvim',
          c = { ':e ~/.local/share/nvim/site/pack/packer<cr>', 'packer plugins cache' },
          i = { ':e ~/repos/github.com/bundai223/dotfiles/config/nvim/init.vim<cr>', 'init.vim' },
          l = { ':e ~/.config/nvim/init.vim<cr>', 'local init.vim' },
          p = { ':e ~/.config/nvim/lua/plugins.lua<cr>', 'packer conf' },
          P = { ':e ~/.config/nvim/lua/plugin_config<cr>', 'packer plugins' },
        },
        p = {
          name = 'powerline',
          c = { ':e ~/.config/powerline/config.json<cr>', 'config.json' },
          l = { ':e ~/.config/powerline/colors.json<cr>', 'color.json' },
          t = { ':e ~/.config/powerline/themes<cr>', 'themes' },
        },
        t = { ':e ~/.tmux.conf<cr>', 'tmux conf' },
        z = {
          name = 'zsh',
          e = { ':e ~/.zshenv<cr>', 'zshenv' },
          r = { ':e ~/.zshrc<cr>', 'zshrc' },
          u = { ':e ~/repos/github.com/bundai223/dotfiles/config/zsh/zsh-utils<cr>', 'utils' },
        }
      },
      f = { ':Telescope find_files<cr>', 'find files' },
      g = { ':Telescope git_files<cr>', 'git files' },
      m = { ':Telescope oldfiles<cr>', 'list mru' },
    },
    g = { ':lua _lazygit_toggle()<CR>', 'lazygit' },
    h = { 'help on vertical splitting.' },
    H = { 'help by cursor word on vertical splitting.' },
    l = {
      name = 'Language Server Protocol',
      o = { ':SymbolsOutline<cr>', 'toggle outline' },
    },
    t = {
      name = 'terminal',
      t = { ':ToggleTerm<cr>', 'ToggleTerm' }
    },
    ["/"] = {
      name = 'search',
      -- g = { ':Telescope live_grep<cr>', 'live grep' },
      g = { '::lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>', 'live grep' },
      r = { ':noh<cr>', 'clear highlight' },
    },
  },
  { prefix = "<leader>" }
)
