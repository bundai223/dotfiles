require("copilot").setup({
	suggestion = {
		auto_trigger = true,
		keymap = {
			accept = "<C-S-y>",
			accept_word = false,
			accept_line = false,
			next = "<C-S-n>",
			prev = "<C-S-p>",
			dismiss = "<C-S-]>",
		},
	},
})

vim.api.nvim_command("highlight link CopilotAnnotation LineNr")
vim.api.nvim_command("highlight link CopilotSuggestion LineNr")

-- C-fで補完を確定する
vim.keymap.set("i", "<C-f>", function()
	require("cmp").mapping.abort()
	require("copilot.suggestion").accept()
end, {
	desc = "[copilot] accept suggestion",
	silent = true,
})
