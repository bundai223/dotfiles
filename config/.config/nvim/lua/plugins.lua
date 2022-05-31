-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.api.nvim_command("silent !git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use({'wbthomason/packer.nvim', opt = true })

  --------------------------------
  -- Vim script Library
  -- use({ "tpope/vim-repeat", event = "VimEnter" })
  -- use {'mattn/webapi-vim'}

  --------------------------------
  -- Lua Library
  -- use({ "nvim-lua/popup.nvim", module = "popup" })
  use({ "nvim-lua/plenary.nvim" }) -- do not lazy load
  use({ "tami5/sqlite.lua", module = "sqlite" })
  -- use({ "MunifTanjim/nui.nvim", module = "nui" })

  use({
    "tyru/caw.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "[myleader]c", "<Plug>(caw:hatpos:toggle)", {})
      vim.api.nvim_set_keymap("v", "[myleader]c", "<Plug>(caw:hatpos:toggle)", {})
    end
  })
  --------------------------------
  -- ColorScheme
  -- local colorscheme = "iceberg.vim"
  local colorscheme = "nightfox.nvim"
  use({
    "EdenEast/nightfox.nvim",
    event = { "VimEnter", "ColorSchemePre" },
    config = function()
      -- require("rc/pluginconfig/nightfox")
      require('nightfox').setup({
        options = {}
      })
      vim.cmd([[ colorscheme nightfox ]])
    end,
  })

  -- use({
  --   'cocopon/iceberg.vim',
  --   config = function()
  --     vim.cmd([[ colorscheme iceberg ]])
  --   end
  -- })

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
    "hrsh7th/nvim-cmp",
    -- requires = {
    --   { "L3MON4D3/LuaSnip", opt = true, event = "VimEnter" },
    --   { "windwp/nvim-autopairs", opt = true, event = "VimEnter" },
    -- },
    -- after = { "LuaSnip", "nvim-autopairs" },
    config = function()
      -- require("rc/pluginconfig/nvim-cmp")
      -- vim.cmd([[set completeopt=menu,menuone,noselect]])
      vim.g.completeopt = "menu,menuone,noselect"

      local cmp = require'cmp'
      -- Global setup.
      cmp.setup({
        formatting = {
          -- fields = {'abbr', 'kind', 'menu'},
          format = require("lspkind").cmp_format({
            with_text = true,
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              cmp_tabnine = "[TabNine]",
              copilot = "[Copilot]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
              path = "[Path]",
              omni = "[Omni]",
              spell = "[Spell]",
              emoji = "[Emoji]",
              calc = "[Calc]",
              rg = "[Rg]",
              treesitter = "[TS]",
              dictionary = "[Dictionary]",
              mocword = "[mocword]",
              cmdline_history = "[History]",
            },
          }),
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        -- sources = cmp.config.sources({
        --   { name = 'nvim_lsp', priority = 100 },
        --   { name = 'vsnip' }, -- For vsnip users.
        --   -- { name = 'luasnip' }, -- For luasnip users.
        --   -- { name = 'snippy' }, -- For snippy users.
        --   -- { name = 'ultisnips' }, -- For ultisnips users.
        -- }, {
        --   { name = 'buffer' },
        --   -- { name = 'emoji' },
        --   { name = 'path', priority = 100 },
        --   { name = 'omni' },
        --   { name = 'nvim_lua' },
        --   { name = 'nvim_lsp_signature_help' },
        -- })
        sources = cmp.config.sources({
          { name = "copilot", priority = 90 }, -- For luasnip users.
          { name = "nvim_lsp", priority = 100 },
          { name = "cmp_tabnine", priority = 30 },
          { name = "luasnip", priority = 20 }, -- For luasnip users.
          { name = "path", priority = 100 },
          { name = "emoji", insert = true, priority = 60 },
          { name = "nvim_lua", priority = 50 },
          { name = "nvim_lsp_signature_help", priority = 80 },
        }, {
          { name = "buffer", priority = 50 },
          { name = "omni", priority = 40 },
          { name = "spell", priority = 40 },
          { name = "calc", priority = 50 },
          { name = "treesitter", priority = 30 },
          { name = "mocword", priority = 60 },
          { name = "dictionary", keyword_length = 2, priority = 10 },
        }),
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
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
        },
      })
    end,
  })

  -- sources
  use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp"})
  use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-omni", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-emoji", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-calc", after = "nvim-cmp" })
  use({ "f3fora/cmp-spell", after = "nvim-cmp" })
  use({ "yutkat/cmp-mocword", after = "nvim-cmp" })
  use({
    "uga-rosa/cmp-dictionary",
    after = "nvim-cmp",
    config = function()
      -- require("rc/pluginconfig/cmp-dictionary")
      require("cmp_dictionary").setup({
        dic = {
          ["*"] = "/usr/share/dict/words",
        },
        first_case_insensitive = true,
        document = true,
      })
      require("cmp_dictionary").update() -- THIS
      -- OR
      -- vim.cmd("CmpDictionaryUpdate")
    end,
  })
  -- use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })
  -- use({
  --   "tzachar/cmp-tabnine",
  --   run = "./install.sh",
  --   after = "nvim-cmp",
  -- })
  use({ "ray-x/cmp-treesitter", after = "nvim-cmp" })

  --------------------------------
  -- Language Server Protocol(LSP)
  use({
    "neovim/nvim-lspconfig",
    after = { "cmp-nvim-lsp" },
    config = function()
      -- require("rc/pluginconfig/nvim-lspconfig")
    end,
  })
  use({
    "williamboman/nvim-lsp-installer",
    -- requires = { { "RRethy/vim-illuminate", opt = true }, { "simrat39/rust-tools.nvim", opt = true } },
    -- after = { "nvim-lspconfig", "vim-illuminate", "nlsp-settings.nvim", "rust-tools.nvim" },
    after = { "nvim-lspconfig"},
    config = function()
      -- require("rc/pluginconfig/nvim-lsp-installer")
      require("nvim-lsp-installer").setup({})

      local lspconfig = require("lspconfig")

      local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
      local servers = require("nvim-lsp-installer").get_installed_servers()
      for _, server in ipairs(servers) do
        local opts = { capabilities = capabilities, on_attach = on_attach }
        -- use rust-tools
        if server.name == "rust_analyzer" then
          require("rust-tools").setup({ server = opts })
        else
          lspconfig[server.name].setup(opts)
        end
        vim.cmd([[ do User LspAttachBuffers ]])
      end
    end,
  })

  --------------------------------
  -- LSP's UI
  -- use {'nvim-lua/lsp-status.nvim', after = 'nvim-lspconfig'}
  -- use {
  --   'nvim-lua/lsp_extensions.nvim',
  --   after = 'nvim-lsp-installer',
  --   config = function() require 'rc/pluginconfig/lsp_extensions' end
  -- }
  use({
    "tami5/lspsaga.nvim",
    after = "nvim-lsp-installer",
    config = function()
      -- require("rc/pluginconfig/lspsaga")
      local lspsaga = require("lspsaga")
      lspsaga.setup({ -- defaults ...
      debug = false,
      use_saga_diagnostic_sign = true,
      -- diagnostic sign
      error_sign = "",
      warn_sign = "",
      hint_sign = "",
      infor_sign = "",
      diagnostic_header_icon = "   ",
      -- code action title icon
      code_action_icon = " ",
      code_action_prompt = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
      finder_definition_icon = "  ",
      finder_reference_icon = "  ",
      max_preview_lines = 10,
      finder_action_keys = {
        open = "o",
        vsplit = "s",
        split = "i",
        quit = "q",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
      },
      code_action_keys = { quit = "q", exec = "<CR>" },
      rename_action_keys = { quit = "<C-c>", exec = "<CR>" },
      definition_preview_icon = "  ",
      border_style = "single",
      rename_prompt_prefix = "➤",
      server_filetype_map = {},
      diagnostic_prefix_format = "%d. ",
    })
  end
})
use({
  "folke/lsp-colors.nvim",
  module = "lsp-colors",
})
use({
  "j-hui/fidget.nvim",
  after = "nvim-lsp-installer",
  config = function()
    -- require("rc/pluginconfig/fidget")
    require("fidget").setup({
      sources = { -- Sources to configure
      ["null-ls"] = { -- Name of source
      ignore = true, -- Ignore notifications from this source
    },
  },
})
    end,
  })

  --------------------------------------------------------------
  -- FuzzyFinders

  --------------------------------
  -- telescope.nvim
  use({
    "nvim-telescope/telescope.nvim",
    -- requires = { { "nvim-lua/plenary.nvim", opt = true }, { "nvim-lua/popup.nvim", opt = true } },
    after = { colorscheme },
    -- event = "VimEnter",
    config = function()
      -- require("rc/pluginconfig/telescope")
      require("telescope").setup({
        defaults = {
          -- Default configuration for telescope goes here:
          -- config_key = value,
          mappings = {
            i = {
              -- map actions.which_key to <C-h> (default: <C-/>)
              -- actions.which_key shows the mappings for your picker,
              -- e.g. git_{create, delete, ...}_branch for the git_branches picker
              ["<C-h>"] = "which_key"
            }
          }
        },
        pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
          },
          extensions = {
            -- Your extension configuration goes here:
            -- extension_name = {
              --   extension_config_key = value,
              -- }
              -- please take a look at the readme of the extension you want to configure
            }
          })
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

      --------------------------------
      -- Treesitter
      use({
        "nvim-treesitter/nvim-treesitter",
        after = { colorscheme },
        -- event = "VimEnter",
        run = ":TSUpdate",
        config = function()
          -- require("rc/pluginconfig/nvim-treesitter")
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true,
              disable = {},
            },
          }
        end,
      })
      use({ "yioneko/nvim-yati", after = "nvim-treesitter" })

      --------------------------------------------------------------
      -- Appearance

      --------------------------------
      -- Statusline
      use({
        "nvim-lualine/lualine.nvim",
        after = colorscheme,
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
          -- require("rc/pluginconfig/lualine")
        end,
      })

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

      --------------------------------------------------------------
      -- Search

      --------------------------------
      -- Find
      use({
        "kevinhwang91/nvim-hlslens",
        event = "VimEnter",
        config = function()
          -- require("rc/pluginconfig/nvim-hlslens")
        end,
      })
    end)
