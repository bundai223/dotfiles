-- require("nvim-notify").setup({})
vim.notify = require("notify")

-- vim.cmd([[
--   augroup notify_test
--     autocmd!
--     autocmd VimEnter * lua vim.notify('VimEnter ' .. vim.fn.winnr())
--     autocmd BufRead * lua vim.notify('BufRead ' .. vim.fn.expand('%'))
--     autocmd BufEnter * lua vim.notify('BufEnter ' .. vim.fn.expand('%'))
--     autocmd WinEnter * lua vim.notify('WinEnter ' .. vim.fn.winnr())
--   augroup end
-- ]])

-- local augroup = vim.api.nvim_create_augroup("NotifyTest", { clear = true })
-- vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   group = augroup,
--   buffer = bufnr,
--   callback = function()
--   end,
--   once = false,
-- })
