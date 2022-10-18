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
    "tyru/caw.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "[myleader]c", "<Plug>(caw:hatpos:toggle)", {})
      vim.api.nvim_set_keymap("v", "[myleader]c", "<Plug>(caw:hatpos:toggle)", {})
    end
  })
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
    "windwp/nvim-autopairs"
  })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "L3MON4D3/LuaSnip", opt = true, event = "VimEnter" },
      { "windwp/nvim-autopairs", opt = true, event = "VimEnter" },
    },
    after = { "LuaSnip", "nvim-autopairs" },
    config = function()
      -- require("rc/pluginconfig/nvim-cmp")
      -- vim.cmd([[set completeopt=menu,menuone,noselect]])
      vim.g.completeopt = "menu,menuone,noselect"

      local cmp = require 'cmp'
      local types = require("cmp.types")
      local luasnip = require("luasnip")
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

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
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              vim.api.nvim_feedkeys(t("<Up>"), "n", true)
            end
          end, { "i" }),
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              vim.api.nvim_feedkeys(t("<Down>"), "n", true)
            end
          end, { "i" }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-Down>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-Up>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ["<C-q>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
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
          { name = "nvim_lsp", priority = 100 },
          { name = 'vsnip' }, -- For vsnip users.
          { name = 'luasnip' }, -- For LuaSnip users.
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
          { name = "mocword", priority = 10 },
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
      -- exclusively for :, without !, uses the default keyword_length
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=], keyword_length = 3 }
        })
      })
      --- for :!, sets keyword_length to 3
      cmp.setup.cmdline(':!', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline', keyword_length = 3 }
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
  use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
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
  use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })
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
    "williamboman/nvim-lsp-installer",
    -- requires = { { "RRethy/vim-illuminate", opt = true }, { "simrat39/rust-tools.nvim", opt = true } },
    -- after = { "nvim-lspconfig", "vim-illuminate", "nlsp-settings.nvim", "rust-tools.nvim" },
    after = { "nvim-lspconfig", "nvim-navic" },
    config = function()
      -- https://github.com/yutkat/dotfiles/blob/91c57ee62856ea314093a52f3d47a627965877f5/.config/nvim/lua/rc/pluginconfig/nvim-lsp-installer.lua
      -- require("rc/pluginconfig/nvim-lsp-installer")
      require("nvim-lsp-installer").setup({})

      local lspconfig = require("lspconfig")
      local navic = require('nvim-navic')
      local on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
      end

      local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = require("nvim-lsp-installer").get_installed_servers()
      for _, server in ipairs(servers) do
        local opts = { capabilities = default_capabilities, on_attach = on_attach }

        if server.name == "rust_analyzer" then
          require("rust-tools").setup({ server = opts })
          lspconfig[server.name].setup(opts)
        elseif server.name == "yamlls" then
          -- lspconfig[server.name].setup(opts)

          lspconfig.yamlls.setup({
            capabilities = default_capabilities,
            on_attach = on_attach,
            settings = {
            yamlls = {
              customTags = {
                "!Ref",
                "!Sub scalar",
                "!Sub sequence",
                "!Join sequence",
                "!FindInMap sequence",
                "!GetAtt scalar",
                "!GetAtt sequence",
                "!Base64 mapping",
                "!GetAZs",
                "!Select scalar",
                "!Select sequence",
                "!Split sequence",
                "!ImportValue",
                "!Condition",
                "!Equals sequence",
                "!And",
                "!If",
                "!Not",
                "!Or"
              },
              -- https://www.schemastore.org/json/
              schemas = {
                ["AWS CloudFormation"] = { "*.cf.{yml,yaml}", "*.{yml,yaml}", "cloudformation/*.{yml,yaml}" },
                ["docker-compose.yml"] = { "docker-compose.{yml,yaml}", "docker-compose*.{yml,yaml}" },
                -- ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = { "docker-compose.yml", "docker-compose*.yml" },
                ["gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                ["openapi.json"] = "*api*.{yml,yaml}",
              },
              schemaStore = {
                enable = true
              }
            }}
          })
        elseif server.name == "sumneko_lua" then
          local has_lua_dev, neodev = pcall(require, "neodev")
          if has_lua_dev then
            -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
            neodev.setup({})
          end
          lspconfig[server.name].setup(opts)
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
    "glepnir/lspsaga.nvim",
    branch = "main",
    after = "nvim-lsp-installer",
    config = function()
      -- require("rc/pluginconfig/lspsaga")
      local lspsaga = require("lspsaga")

      lspsaga.init_lsp_saga({
        --   debug = false,
        --   use_saga_diagnostic_sign = true,
        --   -- diagnostic sign
        --   error_sign = "",
        --   warn_sign = "",
        --   hint_sign = "",
        --   infor_sign = "",
        --   diagnostic_header_icon = "   ",
        --   -- code action title icon
        --   code_action_icon = " ",
        --   code_action_prompt = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
        --   finder_definition_icon = "  ",
        --   finder_reference_icon = "  ",
        --   max_preview_lines = 10,
        --   finder_action_keys = {
        --     open = "o",
        --     vsplit = "s",
        --     split = "i",
        --     quit = "q",
        --     scroll_down = "<C-f>",
        --     scroll_up = "<C-b>",
        --   },
        --   code_action_keys = { quit = "q", exec = "<CR>" },
        --   rename_action_keys = { quit = "<C-c>", exec = "<CR>" },
        --   definition_preview_icon = "  ",
        -- border_style = "single",
        --   rename_prompt_prefix = "➤",
        --   server_filetype_map = {},
        --   diagnostic_prefix_format = "%d. ",
      })

      -- mapping
      vim.api.nvim_set_keymap("n", "<leader>lf", "<Cmd>Lspsaga lsp_finder<CR>", { silent = true, noremap = true })
      -- vim.api.nvim_set_keymap("n", "<leader>lca", "<Cmd>Lspsaga code_action<CR>", { silent = true, noremap = true }) -- actions-preview.nvimにまかせた
      -- vim.api.nvim_set_keymap("<Cmd>Lspsaga range_code_action<CR>", "<leader>lca", "v", { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>lr", "<Cmd>Lspsaga rename<CR>", { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>lp", "<Cmd>Lspsaga peek_definition<CR>", { silent = true })
      vim.api.nvim_set_keymap("n", "<leader>lld", "<Cmd>Lspsaga show_line_diagnostics<CR>",
        { silent = true, noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>lhd", "<Cmd>Lspsaga hover_doc<CR>", { silent = true })
      vim.api.nvim_set_keymap("n", "<Space>?", "<Cmd>Lspsaga hover_doc<CR>", { silent = true })
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

  use({
    "folke/trouble.nvim",
    after = { "nvim-lsp-installer" },
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
      lightbulb.setup({ autocmd = {enabled = true}})
    end
  }
  --------------------------------------------------------------
  -- FuzzyFinder

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
          mappings = {
            i = {
              ["<C-h>"] = "which_key"
            }
          }
        },
        pickers = {
        },
        extensions = {
        }
      })

      -- nmap <C-u> [denite]
      vim.api.nvim_set_keymap("n", "[FuzzyFinder]", "<Nop>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "[FuzzyFinder]", "<Nop>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "z", "[FuzzyFinder]", {})
      vim.api.nvim_set_keymap("v", "z", "[FuzzyFinder]", {})
      vim.api.nvim_set_keymap("n", "[FuzzyFinder]f", "<Cmd>Telescope find_files<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "[FuzzyFinder]b", "<Cmd>Telescope buffers<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "[FuzzyFinder]p", "<Cmd>Telescope git_files<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "[FuzzyFinder]m", "<Cmd>Telescope frecency<CR>", { noremap = true, silent = true })
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
      require 'nvim-treesitter.configs'.setup {
        matchup = {
          enable = true,
        },
        highlight = {
          enable = true,
          disable = {},
        },
      }
    end,
  })

  use({
    "yioneko/nvim-yati",
    after = "nvim-treesitter",
    -- requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        yati = { enable = true },
      }
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
      vim.api.nvim_set_keymap("n", "<leader>f<Space>", "<Cmd>Neotree %:p:h:h %p<CR>", { noremap = true, silent = true })
    end,
  }

  --------------------------------
  -- text object
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = { "nvim-treesitter" },
    config = function()
      require 'nvim-treesitter.configs'.setup {
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
        }
      }
    end,
  })

  --------------------------------
  -- operator
  -- use 'mopp/vim-operator-convert-case'

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
      -- require("rc/pluginconfig/which-key")
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = false, -- shows a list of your marks on ' and `
          registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          -- the presets plugin, adds help for a bunch of default keybindings in Neovim
          -- No actual key bindings are created
          presets = {
            operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = false, -- default bindings on <c-w>
            nav = false, -- misc bindings to work with windows
            z = false, -- bindings for folds, spelling and others prefixed with z
            g = false, -- bindings for prefixed with g
          },
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        operators = { gc = "Comments" },
        icons = {
          breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
          separator = "➜", -- symbol used between a key and it's label
          group = "+", -- symbol prepended to a group
        },
        window = {
          border = "none", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
        },
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        -- triggers = { "<Leader>", "[FuzzyFinder]" }, -- or specify a list manually
      })

      vim.api.nvim_set_keymap("n", "<leader><CR>", "<Cmd>WhichKey <CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "[FuzzyFinder]<CR>", "<Cmd>WhichKey [FuzzyFinder]<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "[myleader]<CR>", "<Cmd>WhichKey [myleader]<CR>", { noremap = true })

      wk.register({
        f = {
          name = 'file',
          e = {
            n = {
              name = 'nvim',
              i = { ':e ~/.config/nvim/init.vim<cr>', 'init.vim' },
              p = { ':e ~/.config/nvim/lua/plugins.lua<cr>', 'packer conf' },
            },
            t = { ':e ~/.tmux.conf<cr>', 'tmux conf' },
            z = {
              name = 'zsh',
              e = { ':e ~/.zshenv<cr>', 'zshenv' },
              r = { ':e ~/.zshrc<cr>', 'zshrc' },
            }
          }
        }
      }, { prefix = "<leader>" })
    end,
  })

  --------------------------------
  -- Lint
  -- use({
  --   "jose-elias-alvarez/null-ls.nvim",
  --   after = "nvim-lsp-installer",
  --   config = function()
  --     require("rc/pluginconfig/null-ls")
  --
  --     local null_ls = require("null-ls")
  --
  --     -- local function file_exists(fname)
  --     --   local stat = vim.loop.fs_stat(vim.fn.expand(fname))
  --     --   return (stat and stat.type) or false
  --     -- end
  --     local ignored_filetypes = {
  --       "TelescopePrompt",
  --       "diff",
  --       "gitcommit",
  --       "unite",
  --       "qf",
  --       "help",
  --       "markdown",
  --       "minimap",
  --       "packer",
  --       "dashboard",
  --       "telescope",
  --       "lsp-installer",
  --       "lspinfo",
  --       "NeogitCommitMessage",
  --       "NeogitCommitView",
  --       "NeogitGitCommandHistory",
  --       "NeogitLogView",
  --       "NeogitNotification",
  --       "NeogitPopup",
  --       "NeogitStatus",
  --       "NeogitStatusNew",
  --       "aerial",
  --       "null-ls-info",
  --     }
  --
  --     local sources = {
  --       null_ls.builtins.formatting.trim_whitespace.with({
  --         disabled_filetypes = ignored_filetypes,
  --         runtime_condition = function()
  --           local count = tonumber(vim.api.nvim_exec("execute 'silent! %s/\\v\\s+$//gn'", true):match("%w+"))
  --           if count then
  --             return vim.fn.confirm("Whitespace found, delete it?", "&No\n&Yes", 1, "Question") == 2
  --           end
  --         end,
  --       }),
  --       null_ls.builtins.diagnostics.cfn_lint,
  --       null_ls.builtins.diagnostics.markdownlint,
  --       null_ls.builtins.diagnostics.yamllint,
  --       null_ls.builtins.diagnostics.zsh,
  --       -- null_ls.builtins.diagnostics.rubocop,
  --       null_ls.builtins.formatting.prettier.with({
  --         condition = function()
  --           return vim.fn.executable("prettier") > 0
  --         end,
  --       }),
  --       null_ls.builtins.diagnostics.eslint.with({
  --         condition = function()
  --           return vim.fn.executable("eslint") > 0
  --         end,
  --       }),
  --       null_ls.builtins.formatting.shfmt.with({
  --         condition = function()
  --           return vim.fn.executable("shfmt") > 0
  --         end,
  --       }),
  --       null_ls.builtins.diagnostics.shellcheck.with({
  --         condition = function()
  --           return vim.fn.executable("shellcheck") > 0
  --         end,
  --       }),
  --       null_ls.builtins.formatting.markdownlint.with({
  --         condition = function()
  --           return vim.fn.executable("markdownlint") > 0
  --         end,
  --       }),
  --     }
  --     local lsp_formatting = function(bufnr)
  --       vim.lsp.buf.format({
  --         filter = function(client)
  --           return client.name ~= "tsserver"
  --         end,
  --         bufnr = bufnr,
  --       })
  --     end
  --     local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
  --     local on_attach = function(client, bufnr)
  --       if client.supports_method("textDocument/formatting") then
  --         vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --         vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  --           group = augroup,
  --           buffer = bufnr,
  --           callback = function()
  --             lsp_formatting(bufnr)
  --           end,
  --           once = false,
  --         })
  --       end
  --     end
  --     null_ls.setup({
  --       sources = sources,
  --       on_attach = on_attach
  --     })
  --   end,
  -- })

  use ({
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
        hashfile = vim.fn.stdpath("data") .. "/config-local", -- Where the plugin keeps files data
        autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
        commands_create = true, -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
        silent = false, -- Disable plugin messages (Config loaded/ignored)
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
      require("toggleterm").setup({
        -- size can be a number or function which is passed the current terminal
        size = function(term)
          if term.direction == "horizontal" then
            return vim.fn.float2nr(vim.o.lines * 0.25)
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-z>]],
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = false,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        persist_size = false,
        direction = "float",
        close_on_exit = false, -- close the terminal window when the process exits
        shell = vim.o.shell, -- change the default shell
        -- This field is only relevant if direction is set to 'float'
        float_opts = {
          -- The border key is *almost* the same as 'nvim_win_open'
          -- see :h nvim_win_open for details on borders however
          -- the 'curved' border is a custom border type
          -- not natively supported but implemented in this plugin.
          border = "single",
          width = math.floor(vim.o.columns * 0.9),
          height = math.floor(vim.o.lines * 0.9),
          winblend = 3,
          highlights = { border = "ColorColumn", background = "ColorColumn" },
        },
      })

      vim.api.nvim_set_keymap("n", "<C-z>", '<Cmd>execute v:count1 . "ToggleTerm"<CR>', { noremap = true, silent = true })

      vim.g.toglleterm_win_num = vim.fn.winnr()
      local groupname = "vimrc_toggleterm"
      vim.api.nvim_create_augroup(groupname, { clear = true })
      vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter", "BufEnter" }, {
        group = groupname,
        pattern = "term://*/zsh;#toggleterm#*",
        callback = function()
          vim.cmd([[startinsert]])
        end,
        once = false,
      })
      vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
        group = groupname,
        pattern = "term://*#toggleterm#[^9]",
        callback = function()
          vim.keymap.set("n", "<Esc>", "<Cmd>exe 'ToggleTerm'<CR>", { noremap = true, silent = true, buffer = true })
        end,
        once = false,
      })
      vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
        group = groupname,
        pattern = "term://*#toggleterm#[^9]",
        callback = function()
          vim.keymap.set(
            "t",
            "<C-z>",
            "<C-\\><C-n>:exe 'ToggleTerm'<CR>",
            { noremap = true, silent = true, buffer = true }
          )
        end,
        once = false,
      })
      vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
        group = groupname,
        pattern = "term://*#toggleterm#*",
        callback = function()
          vim.keymap.set("n", "gf", function()
            local function go_to_file_from_terminal()
              local r = vim.fn.expand("<cfile>")
              if vim.fn.filereadable(vim.fn.expand(r)) ~= 0 then
                return r
              end
              vim.cmd([[normal! j]])
              local r1 = vim.fn.expand("<cfile>")
              if vim.fn.filereadable(vim.fn.expand(r .. r1)) ~= 0 then
                return r .. r1
              end
              vim.cmd([[normal! 2k]])
              local r2 = vim.fn.expand("<cfile>")
              if vim.fn.filereadable(vim.fn.expand(r2 .. r)) ~= 0 then
                return r2 .. r
              end
              vim.cmd([[normal! j]])
              return r
            end

            local function open_file_with_line_col(file, word)
              local f = vim.fn.findfile(file)
              local num = vim.fn.matchstr(word, file .. ":" .. "\zsd*\ze")
              if vim.fn.empty(f) ~= 1 then
                vim.cmd([[ wincmd p ]])
                vim.fn.execute("e " .. f)
                if vim.fn.empty(num) ~= 1 then
                  vim.fn.execute(num)
                  local col = vim.fn.matchstr(word, file .. ":\\d*:" .. "\\zs\\d*\\ze")
                  if vim.fn.empty(col) ~= 1 then
                    vim.fn.execute("normal! " .. col .. "|")
                  end
                end
              end
            end

            local function toggle_term_open_in_normal_window()
              local file = go_to_file_from_terminal()
              local word = vim.fn.expand("<cWORD>")
              if vim.fn.has_key(vim.api.nvim_win_get_config(vim.fn.win_getid()), "anchor") ~= 0 then
                vim.cmd([[ToggleTerm]])
              end
              open_file_with_line_col(file, word)
            end

            toggle_term_open_in_normal_window()
          end, { noremap = true, silent = true, buffer = true })
        end,
        once = false,
      })
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

  --------------------------------
  -- Neovim Lua development
  -- do not customize K mapping
  -- use({ "tjdevries/nlua.nvim", event = "VimEnter" })
  -- use({ "tjdevries/manillua.nvim", event = "VimEnter" })
  use({ "bfredl/nvim-luadev", event = "VimEnter" })
  use({ "folke/neodev.nvim", module = "neodev" })
  use({ "wadackel/nvim-syntax-info", cmd = { "SyntaxInfo" } })
end)
