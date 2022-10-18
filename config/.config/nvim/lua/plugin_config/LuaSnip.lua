-- refs: https://github.com/L3MON4D3/LuaSnip/blob/master/lua/luasnip/loaders/init.lua
-- refs: https://github.com/yutkat/dotfiles/blob/main/.config/nvim/lua/rc/pluginconfig/LuaSnip.lua
local ls = require("luasnip")
local types = require("luasnip.util.types")
-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = { [types.choiceNode] = { active = { virt_text = { { "choiceNode", "Comment" } } } } },
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	-- store_selection_keys = "<Tab>",
	-- luasnip uses this function to get the currently active filetype. This
	-- is the (rather uninteresting) default, but it's possible to use
	-- eg. treesitter for getting the current filetype by setting ft_func to
	-- require("luasnip.extras.filetype_functions").from_cursor (requires
	-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
	-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})


local format = function(path, _)
  -- print(path .. " : " .. source_name)
  -- print(vim.fn.stdpath("data"))

	path = path:gsub(
		vim.pesc(vim.fn.stdpath("data") .. "/site/pack/packer/start"),
		"$PLUGINS"
	)
	if vim.env.HOME then
    local config_path = vim.cmd('silent !readlink -f ~/.config/nvim')
		path = path:gsub(vim.pesc(config_path), "$CONFIG")
	end
	return path
end

MY_LUASNIP_EDIT_SNIPPET_OPTIONS = {
  format = format
}

vim.api.nvim_create_user_command('LuaSnipEdit', ':lua require("luasnip.loaders").edit_snippet_files(MY_LUASNIP_EDIT_SNIPPET_OPTIONS)', {})
-- vim.api.nvim_create_user_command('LuaSnipEditNoOp', ':lua require("luasnip.loaders").edit_snippet_files()', {})

vim.cmd([[imap <silent><expr> <C-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-k>']])
vim.cmd([[smap <silent><expr> <C-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-k>']])

-- choice
-- vim.cmd([[imap <silent><expr> <C-q> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-q>']])
-- vim.cmd([[smap <silent><expr> <C-q> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-q>']])
vim.api.nvim_set_keymap("i", "<C-q>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-q>", "<Plug>luasnip-next-choice", {})

-- ~/.config/nvim/lua/snippetsからsnippetは読み込む
require('luasnip.loaders.from_lua').lazy_load({ paths = '~/.config/nvim/lua/snippets' })
