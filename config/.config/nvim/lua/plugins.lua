-- 参考: https://zenn.dev/yutakatay/articles/neovim-plugins-2022
--       https://github.com/yutkat/dotfiles/blob/main/.config/nvim/lua/rc/pluginlist.lua

-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command("silent !git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- auto compile packer config
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
  -- Packer can manage itself
  use({ 'wbthomason/packer.nvim', opt = true })

  --------------------------------
  -- Vim script Library
  -- use({ "tpope/vim-repeat", event = "VimEnter" })
  -- use {'mattn/webapi-vim'}

  --------------------------------
  -- Lua Library
  -- use({ "nvim-lua/popup.nvim", module = "popup" })
  use({ "nvim-lua/plenary.nvim" }) -- do not lazy load
  use({ "tami5/sqlite.lua", module = "sqlite" })
  use({ "MunifTanjim/nui.nvim", module = "nui" })

  use({
    "dshoreman/caw.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "[myleader]c", "<Plug>(caw:hatpos:toggle)", {})
      vim.api.nvim_set_keymap("v", "[myleader]c", "<Plug>(caw:hatpos:toggle)", {})
    end
  })

  -- use({
  --   'numToStr/Comment.nvim',
  --   config = function()
  --     require('plugin_config/Comment')
  --   end
  -- })

  --------------------------------
  -- ColorScheme
  local colorscheme = "iceberg.vim"
  -- local colorscheme = "nightfox.nvim"
  -- use({
  --   "EdenEast/nightfox.nvim",
  --   event = { "VimEnter", "ColorSchemePre" },
  --   config = function()
  --     -- require("rc/pluginconfig/nightfox")
  --     require('nightfox').setup({
  --       options = {}
  --     })
  --     vim.cmd([[ colorscheme nightfox ]])
  --   end,
  -- })

  use({
    'cocopon/iceberg.vim',
    event = { "VimEnter", "ColorSchemePre" },
    config = function()
      vim.cmd([[ colorscheme iceberg ]])
    end
  })

  --------------------------------
  -- Font
  if not os.getenv("DISABLE_DEVICONS") or os.getenv("DISABLE_DEVICONS") == "false" then
    -- use {'ryanoasis/vim-devicons'}
    use({ "kyazdani42/nvim-web-devicons", after = colorscheme })
  end

  --------------------------------------------------------------
  -- LSP & completion

  --------------------------------
  -- Auto Completion
  use({
    "windwp/nvim-autopairs",
    config = function()
      require('nvim-autopairs').setup {}
    end
  })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "L3MON4D3/LuaSnip",      opt = true, event = "VimEnter" },
      { "windwp/nvim-autopairs", opt = true, event = "VimEnter" },
    },
    after = {
      "LuaSnip",
      "nvim-autopairs",
      "copilot-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-calc",
      "f3fora/cmp-spell",
      "uga-rosa/cmp-dictionary",
      "saadparwaiz1/cmp_luasnip",
      "ray-x/cmp-treesitter",
    },
    config = function()
      require("plugin_config/nvim-cmp")
    end,
  })

  use({
    "onsails/lspkind-nvim",
    module = "lspkind",
    config = function()
      -- require("rc/pluginconfig/lspkind-nvim")
      require("lspkind").init({
        -- enables text annotations
        --
        -- default: true
        mode = "symbol_text",
        -- default symbol map
        -- can be either 'default' (requires nerd-fonts font) or
        -- 'codicons' for codicon preset (requires vscode-codicons font)
        --
        -- default: 'default'
        preset = "codicons",
        -- override preset symbols
        --
        -- default: {}
        symbol_map = {
          Text = "",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "ﰠ",
          Variable = "",
          Class = "ﴯ",
          Interface = "",
          Module = "",
          Property = "ﰠ",
          Unit = "塞",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "פּ",
          Event = "",
          Operator = "",
          TypeParameter = "",
          Copilot = "",
        },
      })

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  })

  -- sources
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
  use({ "hrsh7th/cmp-nvim-lsp-document-symbol" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-cmdline" })
  use({ "hrsh7th/cmp-path" })
  use({ "hrsh7th/cmp-omni" })
  use({ "hrsh7th/cmp-nvim-lua" })
  use({ "hrsh7th/cmp-emoji" })
  use({ "hrsh7th/cmp-calc" })
  use({ "f3fora/cmp-spell" })
  -- use({ "yutkat/cmp-mocword" })
  use({
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
  })
  use({ "saadparwaiz1/cmp_luasnip" })
  -- use({
  --   "tzachar/cmp-tabnine",
  --   run = "./install.sh",
  --   after = "nvim-cmp",
  -- })
  use({ "ray-x/cmp-treesitter" })

  --------------------------------
  -- Language Server Protocol(LSP)
  use({
    "neovim/nvim-lspconfig",
    after = {
      "cmp-nvim-lsp",
    },
    config = function()
      -- require("rc/pluginconfig/nvim-lspconfig")
      -- https://github.com/Pocco81/TheSupercalifragilisticexpialidociousDots/blob/main/.config/nvim/lua/nvdope/initialization/lsp/lspconfig.lua#L97-107
      -- suppress error messages from lang servers
      vim.notify = function(msg, log_level, opts)
        if msg:match("exit code") then
          return
        end
        if log_level == vim.log.levels.ERROR then
          vim.api.nvim_err_writeln(msg)
        else
          vim.api.nvim_echo({ { msg } }, true, {})
        end
      end

      -- [Neovim builtin LSP設定入門](https://zenn.dev/nazo6/articles/c2f16b07798bab)
      vim.api.nvim_set_keymap("n", "<leader>ld", "<Cmd>Trouble<CR>", { noremap = true })
      -- vim.api.nvim_set_keymap("n", "<leader>lK", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true })
    end,
  })

  use({
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup({})
    end
  })

  use({
    'williamboman/mason-lspconfig.nvim',
    requires = {
      { "simrat39/rust-tools.nvim", opt = true }
    },
    after = {
      "nvim-lspconfig",
      "nlsp-settings.nvim",
      "nvim-navic"
    },
    config = function()
      require('plugin_config/mason-lspconfig')
    end
  })

  use({
    'tamago324/nlsp-settings.nvim',
    after = {
      'nvim-lspconfig'
    },
    config = function()
      require('plugin_config/nlsp-settings')
    end
  })

  --------------------------------
  -- LSP's UI
  -- use {'nvim-lua/lsp-status.nvim', after = 'nvim-lspconfig'}
  -- use {
  --   'nvim-lua/lsp_extensions.nvim',
  --   after = 'mason.nvim',
  --   config = function() require 'rc/pluginconfig/lsp_extensions' end
  -- }
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    after = "mason.nvim",
    config = function()
      require("plugin_config/lspsaga")
    end
  })

  use({
    "folke/lsp-colors.nvim",
    module = "lsp-colors",
  })

  use({
    "j-hui/fidget.nvim",
    after = "mason.nvim",
    config = function()
      -- require("rc/pluginconfig/fidget")
      require("fidget").setup({
        sources = {
          -- Sources to configure
          ["null-ls"] = {  -- Name of source
            ignore = true, -- Ignore notifications from this source
          },
        },
      })
    end,
  })

  use({
    "folke/trouble.nvim",
    after = { "mason.nvim" },
    config = function()
      -- https://github.com/yutkat/dotfiles/blob/main/.config/nvim/lua/rc/pluginconfig/trouble.lua
      -- require("rc/pluginconfig/trouble")

      require("trouble").setup({})
    end,
  })

  use({
    "aznhe21/actions-preview.nvim",
    config = function()
      -- vim.api.nvim_set_keymap("n", "<leader>lca", "<Cmd>Lspsaga code_action<CR>", { silent = true, noremap = true })
      vim.keymap.set({ "v", "n" }, "<leader>lca", require("actions-preview").code_actions)
    end
  })

  use {
    'kosayoda/nvim-lightbulb',
    requires = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      local lightbulb = require('nvim-lightbulb')
      lightbulb.setup({ autocmd = { enabled = true } })
    end
  }
  --------------------------------------------------------------
  -- FuzzyFinder

  --------------------------------
  -- telescope.nvim
  use({
    "nvim-telescope/telescope.nvim",
    -- requires = { { "nvim-lua/plenary.nvim", opt = true }, { "nvim-lua/popup.nvim", opt = true } },
    requires = { "nvim-telescope/telescope-live-grep-args.nvim" },
    after = { colorscheme, },
    -- event = "VimEnter",
    config = function()
      require("plugin_config/telescope")
      require("telescope").load_extension("live_grep_args")
    end,
  })

  use({
    "nvim-telescope/telescope-frecency.nvim",
    after = { "telescope.nvim" },
    config = function()
      require("telescope").load_extension("frecency")
    end,
  })
  use({
    "nvim-telescope/telescope-packer.nvim",
    after = { "telescope.nvim" },
    config = function()
      require("telescope").load_extension("packer")
    end,
  })

  use({
    'nvim-telescope/telescope-media-files.nvim',
    after = { "telescope.nvim" },
    config = function()
      require("telescope").load_extension("media_files")
    end
  })

  -- packer
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    after = { "telescope.nvim" },
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
    end
  }

  use({
    'nvim-telescope/telescope-live-grep-args.nvim',
    config = function()
      -- require('plugin_config/telescope-live-grep-args.nvim')
    end
  })

  --------------------------------
  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    after = { colorscheme },
    -- event = "VimEnter",
    run = ":TSUpdate",
    config = function()
      require("plugin_config/nvim-treesitter")
    end,
  })
  use({
    'nvim-treesitter/playground',
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('plugin_config/nvim-treesitter-playground')
    end
  })
  use({
    'RRethy/nvim-treesitter-endwise',
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('plugin_config/nvim-treesitter-endwise')
    end
  })

  use({
    "yioneko/nvim-yati",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter"
    -- requires = "nvim-treesitter/nvim-treesitter",
    -- config = function()
    --   require("nvim-treesitter.configs").setup {
    --     yati = { enable = true },
    --   }
    -- end
  })
  use({
    'nvim-treesitter/nvim-treesitter-context',
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      -- require('plugin_config/nvim-treesitter-context')
    end
  })
  --------------------------------
  -- text object
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = { "nvim-treesitter" },
  })

  --------------------------------
  -- operator
  -- use 'mopp/vim-operator-convert-case'
  use({
    'kylechui/nvim-surround',
    config = function()
      require('plugin_config/nvim-surround')
    end
  })

  --------------------------------------------------------------
  -- Appearance
  use {
    'm-demare/hlargs.nvim',
    after = 'nvim-treesitter',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('hlargs').setup()
    end
  }

  -- highlightするやつ
  use "t9md/vim-quickhl"

  use "RRethy/vim-illuminate"

  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        --   -- your configuration comes here
        --   -- or leave it empty to use the default settings
        --   -- refer to the configuration section below
      }
    end
  }

  use "hashivim/vim-terraform"

  --------------------------------
  -- Statusline
  use({
    "nvim-lualine/lualine.nvim",
    after = { colorscheme, 'nvim-navic' },
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      -- require("rc/pluginconfig/lualine")
      local navic = require("nvim-navic")

      require('lualine').setup({
        sections = {
          lualine_c = {
            { navic.get_location, cond = navic.is_available_navic },
          }
        }
      })
    end,
  })

  --------------------------------
  -- Bufferline
  if not vim.g.vscode then
    use({
      "akinsho/bufferline.nvim",
      after = colorscheme,
      config = function()
        -- require("rc/pluginconfig/bufferline")
        vim.cmd([[hi TabLineSel guibg=#ddc7a1]])

        require("bufferline").setup({
          options = {
            numbers = function(opts)
              return string.format("%s", opts.ordinal)
            end,
            -- NOTE: this plugin is designed with this icon in mind,
            -- and so changing this is NOT recommended, this is intended
            -- as an escape hatch for people who cannot bear it for whatever reason
            -- indicator_icon = '▎',
            -- buffer_close_icon = '',
            -- modified_icon = '●',
            -- close_icon = '',
            -- left_trunc_marker = '',
            -- right_trunc_marker = '',
            -- max_name_length = 18,
            -- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            -- tab_size = 18,
            -- diagnostics = false,
            -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
            --   return "(" .. count .. ")"
            -- end,
            -- NOTE: this will be called a lot so don't do any heavy processing here
            custom_filter = function(buf_number)
              -- filter out filetypes you don't want to see
              if vim.bo[buf_number].filetype == "qf" then
                return false
              end
              if vim.bo[buf_number].buftype == "terminal" then
                return false
              end
              -- -- filter out by buffer name
              if vim.fn.bufname(buf_number) == "" or vim.fn.bufname(buf_number) == "[No Name]" then
                return false
              end
              if vim.fn.bufname(buf_number) == "[dap-repl]" then
                return false
              end
              -- -- filter out based on arbitrary rules
              -- -- e.g. filter out vim wiki buffer from tabline in your work repo
              -- if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
              --   return true
              -- end
              return true
            end,
            -- offsets = {
            --   {filetype = "NvimTree", text = "File Explorer", text_align = "left" | "center" | "right"}
            -- },
            -- show_buffer_icons = true,
            show_buffer_close_icons = false,
            show_close_icon = false,
            -- show_tab_indicators = true
            -- persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
            -- can also be a table containing 2 custom separators
            -- [focused and unfocused]. eg: { '|', '|' }
            -- separator_style = "thick",
            enforce_regular_tabs = true,
            -- always_show_bufferline = true
            -- sort_by = 'relative_directory'
          },
        })
      end,
    })
  end

  --------------------------------
  -- Parse Sourcecode context
  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  }

  -- https://github.com/simrat39/symbols-outline.nvim
  use {
    "simrat39/symbols-outline.nvim",
    config = function()
      local opts = {
        autofold_depth = 2,
      }
      require('symbols-outline').setup(opts)
    end
  }

  --------------------------------
  -- Scrollbar
  use({
    "petertriho/nvim-scrollbar",
    requires = { { "kevinhwang91/nvim-hlslens", opt = true } },
    after = { colorscheme, "nvim-hlslens" },
    config = function()
      -- require("rc/pluginconfig/nvim-scrollbar")
      require("scrollbar").setup({
        show = true,
        set_highlights = true,
      })
    end,
  })

  --------------------------------
  -- Annotation
  use({
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          ruby = {
            template = {
              annotation_convention = "yard"
            }
          }
        }
      })
    end,
    after = { "nvim-treesitter" },
  })

  --------------------------------------------------------------
  -- Search
  use({
    "andymass/vim-matchup",
    config = function()
    end
  })

  --------------------------------
  -- Find
  use({
    "kevinhwang91/nvim-hlslens",
    event = "VimEnter",
    config = function()
      -- require("rc/pluginconfig/nvim-hlslens")
      require('hlslens').setup({
        nearest_only = true,
      })

      local kopts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap('n', 'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', 'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)

      -- if require("rc/packer").is_plugin_installed("vim-asterisk") then
      --   vim.api.nvim_set_keymap("n", "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
      --   vim.api.nvim_set_keymap("n", "g*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
      --
      --   vim.api.nvim_set_keymap("x", "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
      --   vim.api.nvim_set_keymap("x", "g*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
      -- else
      vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      -- end
    end,
  })
  use({
    "haya14busa/vim-asterisk",
    event = "VimEnter",
    config = function()
      -- vim.cmd("source ~/.config/nvim/rc/pluginconfig/vim-asterisk.vim")
    end,
  })

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>f<Space>", "<Cmd>Neotree %:p:h:h %p<CR>",
        { noremap = true, silent = true })
    end,
  }

  -- use {
  --   'nvim-tree/nvim-tree.lua',
  --   requires = {
  --     'nvim-tree/nvim-web-devicons', -- optional, for file icons
  --   },
  --   tag = 'nightly',                 -- optional, updated every week. (see issue #1193)
  --   config = function()
  --     -- lua
  --     require("nvim-tree").setup({
  --       sync_root_with_cwd = true,
  --       respect_buf_cwd = true,
  --       update_focused_file = {
  --         enable = true,
  --         update_root = true
  --       },
  --     })
  --
  --     vim.api.nvim_set_keymap("n", "<leader>f<Space>", "<Cmd>NvimTreeOpen<CR>", { noremap = true, silent = true })
  --   end
  -- }

  --------------------------------
  -- Manual
  use({
    "thinca/vim-ref",
    event = "VimEnter",
    config = function()
      -- vim.cmd("source ~/.config/nvim/rc/pluginconfig/vim-ref.vim")
    end,
  })

  use({
    "folke/which-key.nvim",
    -- after = { "telescope.nvim" }, -- # [FuzzyFinders]が欲しいため
    event = "VimEnter",
    config = function()
      require("plugin_config/which-key")
    end,
  })

  --------------------------------
  -- Lint
  use({
    "jose-elias-alvarez/null-ls.nvim",
    after = "mason.nvim",
    config = function()
      require("plugin_config/null-ls")
    end,
  })

  use({
    'L3MON4D3/LuaSnip',
    config = function()
      require("plugin_config/LuaSnip")
    end
  })

  --------------------------------
  -- Runner
  -- use ({
  --   "klen/nvim-test",
  --   config = function()
  --     require('nvim-test').setup()
  --   end
  -- })

  --------------------------------
  -- Code jump
  use({
    "rgroli/other.nvim",
    event = "VimEnter",
    config = function()
      -- require("rc/pluginconfig/other")
      require("other-nvim").setup({
        mappings = {
          -- builtin mappings
          -- "livewire",
          -- "angular",
          -- "laravel",
          -- custom mapping
          -- {
          --   pattern = ".config/nvim/lua/rc/pluginconfig/(.*).lua$",
          --   target = "../.local/share/nvim/site/pack/packer/*/%1*/README.md",
          --   -- transformer = "lowercase",
          -- },
        },
        transformers = {
          -- defining a custom transformer
          lowercase = function(inputString)
            return inputString:lower()
          end,
          camelToSneak = function(inputString)
            local pathParts = {}

            -- cut along the path separators
            inputString:gsub("%w+[^/]", function(str)
              table.insert(pathParts, str)
            end)

            -- transform to kebap inside of the path fragments
            for i, part in pairs(pathParts) do
              local camelParts = {}
              part:gsub("%u%l+", function(str)
                table.insert(camelParts, str:lower())
              end)
              pathParts[i] = table.concat(camelParts, "_")
            end

            -- rejoin the whole thing
            return table.concat(pathParts, "/")
          end,
          sneakToSneak = function(inputString)
            local pathParts = {}

            -- cut along the path separators
            inputString:gsub("[%w-_]+[^/]", function(str)
              table.insert(pathParts, str)
            end)

            -- transform to kebap inside of the path fragments
            for i, part in pairs(pathParts) do
              local tmp = ""
              for key in part:gmatch("[^-]+") do
                tmp = tmp .. key:sub(1, 1):upper() .. key:sub(2)
              end
              pathParts[i] = tmp
            end

            -- rejoin the whole thing
            return table.concat(pathParts, "/")
          end,
        },
      })
    end,
  })

  --------------------------------
  -- Project
  -- use {'ygm2/rooter.nvim', event = "VimEnter"}
  use({
    "ahmedkhalf/project.nvim",
    event = "VimEnter",
    config = function()
      require("project_nvim").setup({})
    end,
  })
  use({
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup({
        config_files = { ".nvim/local.vim", ".nvim/local.lua" }, -- Config file patterns to load (lua supported)
        hashfile = vim.fn.stdpath("data") .. "/config-local",    -- Where the plugin keeps files data
        autocommands_create = true,                              -- Create autocommands (VimEnter, DirectoryChanged)
        commands_create = true,                                  -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
        silent = false,                                          -- Disable plugin messages (Config loaded/ignored)
      })
    end,
  })

  --------------------------------
  -- New Features
  use({
    'kana/vim-submode',
    config = function()
      vim.api.nvim_set_var('submode_timeout', 1000000)
      vim.api.nvim_set_var('submode_keep_leaving_key', 1)

      -- " http://d.hatena.ne.jp/thinca/20130131/1359567419
      -- " https://gist.github.com/thinca/1518874
      -- " Window size mode.
      vim.fn['submode#enter_with']('winsize', 'n', '', '<C-w>>', '<C-w>>')
      vim.fn['submode#enter_with']('winsize', 'n', '', '<C-w><', '<C-w><')
      vim.fn['submode#enter_with']('winsize', 'n', '', '<C-w>+', '<C-w>+')
      vim.fn['submode#enter_with']('winsize', 'n', '', '<C-w>-', '<C-w>-')
      vim.fn['submode#map']('winsize', 'n', '', '>', '<C-w>>')
      vim.fn['submode#map']('winsize', 'n', '', '<', '<C-w><')
      vim.fn['submode#map']('winsize', 'n', '', '+', '<C-w>+')
      vim.fn['submode#map']('winsize', 'n', '', '-', '<C-w>-')

      -- window移動を連続でしたいことあまりないっぽい。設定したが邪魔だった
      -- " window move mode.
      -- vim.fn['submode#enter_with']('winmove', 'n', '', '<C-w>j', '<C-w>j')
      -- vim.fn['submode#enter_with']('winmove', 'n', '', '<C-w>k', '<C-w>k')
      -- vim.fn['submode#enter_with']('winmove', 'n', '', '<C-w>h', '<C-w>h')
      -- vim.fn['submode#enter_with']('winmove', 'n', '', '<C-w>l', '<C-w>l')
      -- vim.fn['submode#map']('winmove', 'n', '', 'j', '<C-w>j')
      -- vim.fn['submode#map']('winmove', 'n', '', 'k', '<C-w>k')
      -- vim.fn['submode#map']('winmove', 'n', '', 'h', '<C-w>h')
      -- vim.fn['submode#map']('winmove', 'n', '', 'l', '<C-w>l')
      -- " Buffer move mode.
      vim.fn['submode#enter_with']('bufmove', 'n', '', 'bn', ':bnext<CR>')
      vim.fn['submode#enter_with']('bufmove', 'n', '', 'bp', ':bprevious<CR>')
      vim.fn['submode#map']('bufmove', 'n', '', 'n', ':bnext<CR>')
      vim.fn['submode#map']('bufmove', 'n', '', 'p', ':bprevious<CR>')
      -- " Tab move mode.
      vim.fn['submode#enter_with']('tabmove', 'n', '', 'gt', 'gt')
      vim.fn['submode#enter_with']('tabmove', 'n', '', 'gT', 'gT')
      vim.fn['submode#map']('tabmove', 'n', '', 't', 'gt')
      vim.fn['submode#map']('tabmove', 'n', '', 'T', 'gT')
    end
  })

  use({
    'kristijanhusak/line-notes.nvim',
    config = function()
      require('line-notes').setup({
        auto_preview = true
      })
    end
  })

  -- register一覧
  use 'tversteeg/registers.nvim'

  -- session保存
  use {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'info',
        auto_session_suppress_dirs = { '~/', '~/Projects' }
      }
    end
  }

  -- terminmal拡張
  use({
    'akinsho/toggleterm.nvim',
    config = function()
      require('plugin_config/toggleterm')
    end
  })

  -- UI Library
  use({
    "stevearc/dressing.nvim",
    event = "VimEnter",
    config = function()
      require("plugin_config/dressing")
    end,
  })

  use({
    'rcarriga/nvim-notify',
    event = 'VimEnter',
    config = function()
      require('plugin_config/nvim-notify')
    end
  })

  -- use({
  --   'Furkanzmc/zettelkasten.nvim',
  --   config = function() require('plugin_config/zettelkasten_nvim') end
  -- })

  --------------------------------
  -- Neovim Lua development
  -- do not customize K mapping
  -- use({ "tjdevries/nlua.nvim", event = "VimEnter" })
  -- use({ "tjdevries/manillua.nvim", event = "VimEnter" })
  use({ "bfredl/nvim-luadev", event = "VimEnter" })
  use({ "folke/neodev.nvim", module = "neodev" })
  use({ "wadackel/nvim-syntax-info", cmd = { "SyntaxInfo" } })
  use({
    'simrat39/rust-tools.nvim',
    config = function()
      require('plugin_config/rust-tools')
    end
  })

  -- Vue.js
  use({
    'leafOfTree/vim-vue-plugin',
    config = function()
      require('plugin_config/vim-vue-plugin')
    end,
    ft = { 'vue' }
  })

  use {
    'kkoomen/vim-doge',
    run = ':call doge#install()',
    config = function()
      require('plugin_config/vim-doge')
    end
  }

  use({
    'zbirenbaum/copilot.lua',
    -- cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  })

  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end
  }

  --------------------------------
  --
  -- use({
  --   'esensar/nvim-dev-container',
  --   requires = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     require('plugin_config/nvim-dev-container')
  --   end
  -- })
  -- use({
  --   'jamestthompson3/nvim-remote-containers',
  --   config = function()
  --     require('plugin_config/nvim-remote-containers')
  --   end
  -- })
end)
