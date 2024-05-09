-- vim.cmd([[set completeopt=menu,menuone,noselect]])
vim.g.completeopt = "menu,menuone,noselect"

local cmp = require 'cmp'
local types = require("cmp.types")
local luasnip = require("luasnip")
local has_words_before = function()
  local unpack = unpack or table.unpack ---@diagnostic disable-line: deprecated
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

-- https://github.com/zbirenbaum/copilot-cmp#tab-completion-configuration-highly-recommended
-- local has_words_before = function()
--   if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
-- end

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
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    -- ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    -- ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
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
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    -- ["<Tab>"] = vim.schedule_wrap(function(fallback)
    --   if cmp.visible() and has_words_before() then
    --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --   else
    --     fallback()
    --   end
    -- end),
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
    ["<CR>"] = cmp.mapping.confirm({
      -- this is the important line
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
  },
  -- sources[]はindexが低いほど優先度が高い
  -- 優先される結果が見えている間、group_indexが大きいsourceは見えない
  sources = cmp.config.sources(
    {
      { name = "copilot" },
      { name = "nvim_lsp" },
      -- { name = 'vsnip' },   -- For vsnip users.
      { name = 'luasnip' }, -- For LuaSnip users.
      { name = "path",    option = cmppath_option },
      { name = "emoji",   insert = true },
      { name = "nvim_lua" },
      -- { name = "nvim_lsp_signature_help" },
    },
    {
      { name = "buffer" },
      -- { name = "omni" },
      { name = "spell" },
      { name = "calc" },
      { name = "treesitter" },
      { name = "mocword" },
      { name = "dictionary", keyword_length = 2 },
    }
  ),
  sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,

      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
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

-- appearance
-- " gray
vim.api.nvim_exec("highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080", false)
-- " blue
vim.api.nvim_exec("highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6", false)
vim.api.nvim_exec("highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch", false)
-- " light blue
vim.api.nvim_exec("highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE", false)
vim.api.nvim_exec("highlight! link CmpItemKindInterface CmpItemKindVariable", false)
vim.api.nvim_exec("highlight! link CmpItemKindText CmpItemKindVariable", false)
-- " pink
vim.api.nvim_exec("highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0", false)
vim.api.nvim_exec("highlight! link CmpItemKindMethod CmpItemKindFunction", false)
-- " front
vim.api.nvim_exec("highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4", false)
vim.api.nvim_exec("highlight! link CmpItemKindProperty CmpItemKindKeyword", false)
vim.api.nvim_exec("highlight! link CmpItemKindUnit CmpItemKindKeyword", false)
