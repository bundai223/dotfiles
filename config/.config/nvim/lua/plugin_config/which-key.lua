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
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  win = {
    border = "none",          -- none, single, double, shadow
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3,                    -- spacing between columns
  },
  -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
})

vim.api.nvim_set_keymap("n", "<leader><CR>", "<Cmd>WhichKey <CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "[FuzzyFinder]<CR>", "<Cmd>WhichKey [FuzzyFinder]<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "[myleader]<CR>", "<Cmd>WhichKey [myleader]<CR>", { noremap = true })

-- for dir in io.popen([[git config --list | grep -i include | sed 's/^.*=//g']]):lines() do print(dir) end
-- git config --list | grep -i 'init.templatedir\|core.attributesfile\|core.excludesfile'

wk.add(
  {
    { "<leader>/",    group = "search" },
    { "<leader>/g",   '::lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>',        desc = "live grep" },
    { "<leader>/r",   ":noh<cr>",                                                                         desc = "clear highlight" },
    { "<leader>H",    ":vert bel help <C-r><C-w><cr>",                                                    desc = "help by cursor word on vertical splitting." },
    { "<leader>b",    group = "buffers" },
    { "<leader>bd",   ":bdelete<cr>",                                                                     desc = "delete current buffer" },
    { "<leader>bl",   ":Telescope buffers<cr>",                                                           desc = "listup buffers" },
    { "<leader>d",    group = "doc" },
    { "<leader>dg",   desc = "Generate document" },
    { "<leader>f",    group = "file" },
    { "<leader>fe",   group = "edit conf" },
    { "<leader>feg",  group = "git" },
    { "<leader>fega", ":e ~/repos/github.com/bundai223/dotfiles/config/git/.gitattributes_global<cr>",    desc = "~/.gitattributes" },
    { "<leader>fegc", ":e ~/.gitconfig<cr>",                                                              desc = "~/.gitconfig" },
    { "<leader>fegg", ":e ~/repos/github.com/bundai223/dotfiles/config/.gitconfig<cr>",                   desc = ".gitconfig base" },
    { "<leader>fegi", ":e ~/repos/github.com/bundai223/dotfiles/config/git/.gitignore_global<cr>",        desc = "~/.gitconfig" },
    { "<leader>fegt", ":e ~/repos/github.com/bundai223/dotfiles/config/git/templates<cr>",                desc = "~/.gitconfig" },
    { "<leader>fen",  group = "nvim" },
    { "<leader>fenP", ":e ~/.config/nvim/lua/plugin_config<cr>",                                          desc = "packer plugins" },
    { "<leader>fenc", ":e ~/.local/share/nvim/site/pack/packer<cr>",                                      desc = "packer plugins cache" },
    { "<leader>feng", ":e ~/.config/nvim/ginit.vim<cr>",                                                  desc = "local ginit.vim" },
    { "<leader>feni", ":e ~/repos/github.com/bundai223/dotfiles/config/nvim/init.vim<cr>",                desc = "init.vim" },
    { "<leader>fenl", ":e ~/.config/nvim/init.vim<cr>",                                                   desc = "local init.vim" },
    { "<leader>fenp", ":e ~/.config/nvim/lua/plugins.lua<cr>",                                            desc = "packer conf" },
    { "<leader>fep",  group = "powerline" },
    { "<leader>fepc", ":e ~/.config/powerline/config.json<cr>",                                           desc = "config.json" },
    { "<leader>fepl", ":e ~/.config/powerline/colors.json<cr>",                                           desc = "color.json" },
    { "<leader>fept", ":e ~/.config/powerline/themes<cr>",                                                desc = "themes" },
    { "<leader>fet",  ":e ~/.tmux.conf<cr>",                                                              desc = "tmux conf" },
    { "<leader>few",  group = "wezterm" },
    { "<leader>fewc", ":e ~/repos/github.com/bundai223/dotfiles/config/.config/wezterm/wezterm.lua<cr>",  desc = "wezterm.lua" },
    { "<leader>fewk", ":e ~/repos/github.com/bundai223/dotfiles/config/.config/wezterm/keybinds.lua<cr>", desc = "keybinds.lua" },
    { "<leader>fewo", ":e ~/repos/github.com/bundai223/dotfiles/config/.config/wezterm/on.lua<cr>",       desc = "on.lua" },
    { "<leader>fewu", ":e ~/repos/github.com/bundai223/dotfiles/config/.config/wezterm/utils.lua<cr>",    desc = "utils.lua" },
    { "<leader>fez",  group = "zsh" },
    { "<leader>feze", ":e ~/.zshenv<cr>",                                                                 desc = "zshenv" },
    { "<leader>fezr", ":e ~/.zshrc<cr>",                                                                  desc = "zshrc" },
    { "<leader>fezu", ":e ~/repos/github.com/bundai223/dotfiles/config/zsh/zsh-utils<cr>",                desc = "utils" },
    { "<leader>ff",   ":Telescope find_files<cr>",                                                        desc = "find files" },
    { "<leader>fg",   ":Telescope git_files<cr>",                                                         desc = "git files" },
    { "<leader>fm",   ":Telescope oldfiles<cr>",                                                          desc = "list mru" },
    { "<leader>g",    ":lua _lazygit_toggle()<CR>",                                                       desc = "lazygit" },
    { "<leader>hh",   ":Telescope help_tags<cr>",                                                         desc = "help tags" },
    { "<leader>hv",   ":vert bel help ",                                                                  desc = "help on vertical splitting." },
    { "<leader>l",    group = "Language Server Protocol" },
    { "<leader>lo",   ":SymbolsOutline<cr>",                                                              desc = "toggle outline" },
    { "<leader>t",    group = "terminal" },
    { "<leader>tt",   ":ToggleTerm<cr>",                                                                  desc = "ToggleTerm" },
  }
)
