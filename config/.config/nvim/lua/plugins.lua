-- 参考: https://zenn.dev/yutakatay/articles/neovim-plugins-2022
--       https://github.com/yutkat/dotfiles/blob/main/.config/nvim/lua/rc/pluginlist.lua

------------------------------------------
-- statuslineをsplitしても1つにする設定
vim.opt.fillchars = {
  horiz     = '━',
  horizup   = '┻',
  horizdown = '┳',
  vert      = '┃',
  vertleft  = '┫',
  vertright = '┣',
  verthoriz = '╋',
}
vim.opt.laststatus = 3
------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

----------------------------------------------------------------
---- Load local plugins
local function load_local_plugins()
  if vim.fn.filereadable(vim.fn.expand("~/.nvim_pluginlist_local.lua")) == 1 then
    return dofile(vim.fn.expand("~/.nvim_pluginlist_local.lua"))
  end
end
local local_plugins = load_local_plugins() or {}

local plugins = {
  -- ------------------------------------------------------------
  -- Installer
  { "folke/lazy.nvim" },

  -- External package Installer
  {
    "williamboman/mason.nvim",
    event = "BufReadPre",
    config = function()
      require("mason").setup({})
    end,
  },

  --------------------------------
  -- Vim script Library
  -- use({ "tpope/vim-repeat", event = "VimEnter" })
  -- use {'mattn/webapi-vim'}

  --------------------------------
  -- Lua Library
  { "nvim-lua/popup.nvim",   lazy = false },
  { "nvim-lua/plenary.nvim", lazy = false },
  { "tami5/sqlite.lua",      lazy = false },
  { "MunifTanjim/nui.nvim",  lazy = false },

  {
    "dshoreman/caw.vim",
    event = "VimEnter",
    config = function()
      vim.api.nvim_set_keymap("n", "[myleader]c", "<Plug>(caw:hatpos:toggle)", {})
      vim.api.nvim_set_keymap("v", "[myleader]c", "<Plug>(caw:hatpos:toggle)", {})
    end
  },

  --------------------------------
  -- ColorScheme
  {
    'cocopon/iceberg.vim',
    event = { "VimEnter", "ColorSchemePre" },
    config = function()
      vim.cmd([[ colorscheme iceberg ]])
    end
  },

  --------------------------------
  -- Font
  -- {
  --   "kyazdani42/nvim-web-devicons",
  --   enabled = function()
  --     return not os.getenv("DISABLE_DEVICONS") or os.getenv("DISABLE_DEVICONS") == "false"
  --   end,
  -- },

  -- {
  --    -- ambiguous chara
  --   "delphinus/cellwidths.nvim",
  --   event = "BufEnter",
  --   config = function()
  --     require("cellwidths").setup({
  --       name = "default",
  --     })
  --   end,
  -- },

  --------------------------------
  -- UI Library
  {
    "stevearc/dressing.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/dressing")
    end,
  },

  {
    'rcarriga/nvim-notify',
    event = 'BufReadPre',
    config = function()
      require('plugin_config/nvim-notify')
    end
  },

  --------------------------------------------------------------
  -- LSP & completion

  --------------------------------
  -- Auto Completion
  {
    "windwp/nvim-autopairs",
    event = "VimEnter",
    config = function()
      require('nvim-autopairs').setup {}
    end
  },

  {
    "hrsh7th/nvim-cmp",
    -- event = "VimEnter",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("plugin_config/nvim-cmp")
    end,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      -- Duplicate popups.
      -- { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "dmitmel/cmp-cmdline-history" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-omni" },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-calc" },
      { "f3fora/cmp-spell" },
      -- { "yutkat/cmp-mocword" },
      {
        "uga-rosa/cmp-dictionary",
        config = function()
          -- require("rc/pluginconfig/cmp-dictionary")
          require("cmp_dictionary").setup({
            dic = {
              -- ["*"] = "/usr/share/dict/words",
              ["*"] = "~/.config/dictionary/my.dict",
            },
            first_case_insensitive = true,
            document = true,
          })
          require("cmp_dictionary").update() -- THIS
          -- OR
          -- vim.cmd("CmpDictionaryUpdate")
        end,
      },
      { "saadparwaiz1/cmp_luasnip" },
      -- {
      --   "tzachar/cmp-tabnine",
      --   build = "./install.sh",
      -- },
      { "ray-x/cmp-treesitter" },
      {
        "onsails/lspkind-nvim",
        config = function()
          require("plugin_config/lspkind-nvim")
        end
      },

    }
  },

  --------------------------------
  -- Language Server Protocol(LSP)
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugin_config/nvim-lspconfig")
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    event = "BufReadPre",
    config = function()
      require('plugin_config/mason-lspconfig')
    end,
    dependencies = {
      {
        "folke/neoconf.nvim",
        config = function()
          require("plugin_config/neoconf")
        end
      },
      {
        "SmiteshP/nvim-navic",
        config = function()
          require('plugin_config/nvim-navic')
        end

      },
      { "folke/neodev.nvim" },
      {
        'simrat39/rust-tools.nvim',
        config = function()
          require('plugin_config/rust-tools')
        end
      },
      {
        'tamago324/nlsp-settings.nvim',
        config = function()
          require('plugin_config/nlsp-settings')
        end
      },

    },
  },

  --------------------------------
  -- LSP's UI
  {
    "glepnir/lspsaga.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/lspsaga")
    end
  },

  {
    -- diagnostics viewer
    "folke/trouble.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/trouble")
    end,
  },

  {
    -- いい感じにlspの起動を右下に表示するやつ
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "VimEnter",
    config = function()
      require("plugin_config/fidget")
    end,
  },

  {
    -- code actionsのpreview。名前そのまま
    "aznhe21/actions-preview.nvim",
    event = "VimEnter",
    config = function()
      -- vim.api.nvim_set_keymap("n", "<leader>lca", "<Cmd>Lspsaga code_action<CR>", { silent = true, noremap = true })
      vim.keymap.set({ "v", "n" }, "<leader>lca", require("actions-preview").code_actions)
    end
  },

  {
    'antoinemadec/FixCursorHold.nvim',
    event = "VimEnter",
    dependencies = {
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          local lightbulb = require('nvim-lightbulb')
          lightbulb.setup({ autocmd = { enabled = true } })
        end
      }
    }
  },

  --------------------------------
  -- AI completion
  {
    "zbirenbaum/copilot.lua",
    -- cmd = { "Copilot" },
    event = "InsertEnter",
    config = function()
      vim.defer_fn(function()
        require("plugin_config/copilot")
      end, 100)
    end,
  },

  --------------------------------
  -- telescope.nvim
  {
    "nvim-telescope/telescope-file-browser.nvim",
    event = "VimEnter",
    config = function()
      require("telescope").load_extension("file_browser")
    end,
    enabled = function()
      return vim.fn.executable("ueberzug")
    end,
  },
  {
    "LinArcX/telescope-changes.nvim",
    event = "VimEnter",
    config = function()
      require("telescope").load_extension("changes")
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    event = "VimEnter",
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
  {
    'nvim-telescope/telescope-media-files.nvim',
    event = "VimEnter",
    config = function()
      require("telescope").load_extension("media_files")
    end
  },
  {
    'nvim-telescope/telescope-live-grep-args.nvim',
    event = "VimEnter",
    config = function()
      require("telescope").load_extension("live_grep_args")
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VimEnter",
    config = function()
      require("telescope").load_extension("ui-select")
    end,
  },
  -- {
  --   "nvim-telescope/telescope-smart-history.nvim",
  --   config = function()
  --     require("telescope").load_extension("smart_history")
  --   end,
  --   build = function()
  --     os.execute("mkdir -p " .. vim.fn.stdpath("state") .. "databases/")
  --   end,
  -- },
  {
    "nvim-telescope/telescope-symbols.nvim",
    event = "VimEnter",
  },
  {
    "debugloop/telescope-undo.nvim",
    event = "VimEnter",
    config = function()
      require("telescope").load_extension("undo")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/telescope")
    end,
  },

  --------------------------------
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost" },
    build = ":TSUpdate",
    config = function()
      require("plugin_config/nvim-treesitter")
    end,
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring" }, -- TODO: cawとかぶってるやつ
      { "nvim-treesitter/nvim-treesitter-refactor" },    -- TODO:
      { "nvim-treesitter/nvim-tree-docs" },              -- TODO:
      { "vigoux/architext.nvim" },                       -- TODO: 現時点ではむずすぎる印象。substituteを独自クエリでやるやつ
      { "yioneko/nvim-yati" },                           -- treesitterのindent plugin
      { "theHamsta/nvim-treesitter-pairs" }              -- %で移動するpairsの定義
    }
  },

  --------------------------------
  -- Treesitter UI customize
  {
    "mrjones2014/nvim-ts-rainbow",
    event = "BufReadPost",
    config = function()
      -- -- patch https://github.com/nvim-treesitter/nvim-treesitter/issues/1124
      -- vim.cmd("e!")
    end,
  },
  -- { "haringsrob/nvim_context_vt", event = "BufReadPost" },
  {
    "m-demare/hlargs.nvim",
    event = "VimEnter",
    config = function()
      require('hlargs').setup()
    end,
  },
  {
    'nvim-treesitter/playground',
    event = "VimEnter",
    config = function()
      require('plugin_config/nvim-treesitter-playground')
    end
  },
  {
    'RRethy/nvim-treesitter-endwise',
    event = "VimEnter",
    config = function()
      require('plugin_config/nvim-treesitter-endwise')
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    cmd = { "TSContextEnable" },
    config = function()
      require("treesitter-context").setup({})
    end
  },

  --------------------------------
  -- Treesitter textobject & operator
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "VimEnter" },
  -- {
  --   "chrisgrieser/nvim-various-textobjs",
  --   event = "VimEnter",
  --   config = function()
  --     require("rc/pluginconfig/nvim-various-textobjs")
  --   end,
  -- },
  -- incremental-selection
  -- { "RRethy/nvim-treesitter-textsubjects", after = { "nvim-treesitter" } },
  -- {
  --   "mizlan/iswap.nvim",
  --   event = "VimEnter",
  --   config = function()
  --     require("rc/pluginconfig/iswap")
  --   end,
  -- },
  -- {
  --   "mfussenegger/nvim-treehopper",
  --   event = "VimEnter",
  --   config = function()
  --     require("rc/pluginconfig/nvim-treehopper")
  --   end,
  -- },
  -- {
  --   "David-Kunz/treesitter-unit",
  --   event = "VimEnter",
  --   config = function()
  --     require("rc/pluginconfig/treesitter-unit")
  --   end,
  -- },

  --------------------------------------------------------------
  -- Appearance
  {
    "petertriho/nvim-scrollbar",
    event = "VimEnter",
    config = function()
      -- require("rc/pluginconfig/nvim-scrollbar")
      require("scrollbar").setup({
        show = true,
        set_highlights = true,
      })
    end,
  },

  {
    "xiyaowong/transparent.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/transparent")
    end
  },

  --------------------------------
  -- StatusLine
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/lualine")
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      {
        "SmiteshP/nvim-navic",
        config = function()
          require('plugin_config/nvim-navic')
        end
      },
    },
  },

  --------------------------------
  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    enabled = function()
      return not vim.g.vscode
    end,
    event = "VimEnter",
    config = function()
      require("plugin_config/bufferline")
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    version = "*"
  },

  --------------------------------
  -- Highlight
  {
    "RRethy/vim-illuminate",
    event = "VimEnter",
  },
  -- {
  --   "xiyaowong/nvim-cursorword",
  --   event = "VimEnter",
  --   config = function()
  --     require("rc/pluginconfig/nvim-cursorword")
  --   end,
  -- },
  {
    "t9md/vim-quickhl",
    event = "VimEnter",
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    config = function()
      require("todo-comments").setup {
        --   -- your configuration comes here
        --   -- or leave it empty to use the default settings
        --   -- refer to the configuration section below
      }
    end
  },

  -- Context Parse
  -- https://github.com/simrat39/symbols-outline.nvim
  {
    "simrat39/symbols-outline.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/symbols-outline")
    end
  },

  --------------------------------
  -- Sidebar
  -- {
  --   "GustavoKatel/sidebar.nvim",
  --   cmd = { "SidebarNvimToggle" },
  --   config = function()
  --     require("plugin_config/sidebar")
  --   end,
  -- },

  --------------------------------
  -- Window Separators
  {
    "nvim-zh/colorful-winsep.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/colorful-winsep")
    end,
  },

  --------------------------------
  -- Menu
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/which-key")
    end,
  },

  --------------------------------
  -- operator
  -- use 'mopp/vim-operator-convert-case'
  {
    "gbprod/substitute.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/substitute")
    end,
  },

  {
    'kylechui/nvim-surround',
    event = "VimEnter",
    config = function()
      require('plugin_config/nvim-surround')
    end
  },

  --------------------------------------------------------------
  -- Search
  {
    "andymass/vim-matchup",
    event = "VimEnter",
    config = function()
    end
  },

  --------------------------------
  -- Find
  {
    "kevinhwang91/nvim-hlslens",
    event = "VimEnter",
    config = function()
      require("plugin_config/nvim-hlslens")
    end,
  },
  -- {
  --   "rapan931/lasterisk.nvim",
  --   event = "VimEnter",
  --   config = function()
  --     require("rc/pluginconfig/lasterisk")
  --   end,
  -- },

  --------------------------------
  -- Filer
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VimEnter",
    branch = "main",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>f<Space>", "<Cmd>Neotree %:p:h:h %p<CR>",
        { noremap = true, silent = true })
    end,
  },

  --------------------------------
  -- Lint
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/null-ls")
    end,
  },

  --------------------------------
  -- Command
  {
    "jghauser/mkdir.nvim",
    event = "VimEnter",
    config = function()
      require("mkdir")
    end,
  },

  {
    'mattn/vim-findroot',
    event = "VimEnter",
    config = function()
    end
  },

  --------------------------------
  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    event = "VimEnter",
    config = function()
      require('plugin_config/toggleterm')
    end
  },
  {
    "yutkat/term-gf.nvim",
    event = "VimEnter",
    config = function()
      require("term-gf").setup()
    end,
  },

  -- register一覧
  {
    'tversteeg/registers.nvim',
    event = "VimEnter",
  },

  -- snippet
  {
    'L3MON4D3/LuaSnip',
    config = function()
      require("plugin_config/LuaSnip")
    end
  },

  --------------------------------
  -- Neovim Lua development
  -- do not customize K mapping
  {
    "bfredl/nvim-luadev",
    event = "VimEnter"
  },
  {
    "wadackel/nvim-syntax-info",
    event = "VimEnter"
  },

  -- Vue.js
  {
    'leafOfTree/vim-vue-plugin',
    event = "VimEnter",
    config = function()
      require('plugin_config/vim-vue-plugin')
    end,
  },

  {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    -- event = "VimEnter",
    lazy = false,
    config = function()
      require('plugin_config/vim-doge')
    end
  },

  {
    'noprompt/vim-yardoc',
    event = "VimEnter",
  },

  --------------------------------
  -- New Features
  {
    'kana/vim-submode',
    event = "VimEnter",
    config = function()
      require('plugin_config/submode')
    end
  },

  -- {
  --   'mvllow/modes.nvim',
  --   event = "VimEnter",
  --   config = function()
  --     require('plugin_config/modes')
  --   end
  -- },

  --------------------------------
  -- Debugger
  {
    'mfussenegger/nvim-dap',
    event = "VimEnter",
    config = function()
    end
  },
}

local function merge_lists(t1, t2)
  local result = {}
  for _, v in pairs(t1) do
    table.insert(result, v)
  end
  for _, v in pairs(t2) do
    table.insert(result, v)
  end
  return result
end

require("lazy").setup(merge_lists(plugins, local_plugins), {
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
  },
  dev = {
    path = vim.fn.stdpath("data") .. "/dev",
  },
})
