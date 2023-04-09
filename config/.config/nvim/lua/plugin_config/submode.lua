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
