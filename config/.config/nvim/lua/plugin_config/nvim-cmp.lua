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

local cmppath_option = {
  trailing_slash = false,
  label_trailing_slash = true
}
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
  sources = cmp.config.sources(
    {
      { name = "nvim_lsp", priority = 100 },
      { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For LuaSnip users.
      { name = "path", priority = 100, option = cmppath_option },
      { name = "emoji", insert = true, priority = 60 },
      { name = "nvim_lua", priority = 50 },
      { name = "nvim_lsp_signature_help", priority = 80 },
    },
    {
      { name = "buffer", priority = 50 },
      -- { name = "omni", priority = 40 },
      { name = "spell", priority = 40 },
      { name = "calc", priority = 50 },
      { name = "treesitter", priority = 30 },
      { name = "mocword", priority = 10 },
      { name = "dictionary", keyword_length = 2, priority = 10 },
    }
  ),
})
-- `/` cmdline setup.
local search_config = {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
}
cmp.setup.cmdline('/', search_config)
cmp.setup.cmdline('?', search_config)

-- `:` cmdline setup.
-- exclusively for :, without !, uses the default keyword_length
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'path', option = cmppath_option }
    }
    , {
    { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=], keyword_length = 3 }
  }
  )
})
--- for :!, sets keyword_length to 3
cmp.setup.cmdline(':!', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path', option = cmppath_option }
  }, {
    { name = 'cmdline', keyword_length = 3 }
  })
})
