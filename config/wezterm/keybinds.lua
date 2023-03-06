-- https://github.com/yutkat/dotfiles/blob/main/.config/wezterm/keybinds.lua

local M = {}
local wezterm = require("wezterm")
local utils = require("utils")
local act = wezterm.action

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------
M.tmux_keybinds = {
    -- create pane
    { key = '|', mods = 'LEADER|SHIFT', action = act({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
    { key = '_', mods = 'LEADER|SHIFT', action = act({ SplitVertical = { domain = 'CurrentPaneDomain' } }) },
    -- move pane
    { key = "h", mods = "LEADER",       action = act({ ActivatePaneDirection = "Left" }) },
    { key = "l", mods = "LEADER",       action = act({ ActivatePaneDirection = "Right" }) },
    { key = "k", mods = "LEADER",       action = act({ ActivatePaneDirection = "Up" }) },
    { key = "j", mods = "LEADER",       action = act({ ActivatePaneDirection = "Down" }) },
    -- resize pane
    -- key_tablesと合わせてtmuxっぽくなった
    { key = "h", mods = "LEADER|SHIFT", action = act({ ActivateKeyTable = { name = 'resize_pane', one_shot = false, timeout_milliseconds = 1000 } }) },
    { key = "l", mods = "LEADER|SHIFT", action = act({ ActivateKeyTable = { name = 'resize_pane', one_shot = false, timeout_milliseconds = 1000 } }) },
    { key = "k", mods = "LEADER|SHIFT", action = act({ ActivateKeyTable = { name = 'resize_pane', one_shot = false, timeout_milliseconds = 1000 } }) },
    { key = "j", mods = "LEADER|SHIFT", action = act({ ActivateKeyTable = { name = 'resize_pane', one_shot = false, timeout_milliseconds = 1000 } }) },
    -- Change Active Tab
    { key = "p", mods = "LEADER",       action = act({ ActivateTabRelative = -1 }) },
    { key = "n", mods = "LEADER",       action = act({ ActivateTabRelative = 1 }) },
    -- tab management
    { key = "c", mods = "LEADER",       action = act({ SpawnTab = "CurrentPaneDomain" }) }, -- create tab
    { key = "k", mods = "LEADER|CTRL",  action = act({ CloseCurrentTab = { confirm = true } }) },
    -- example
    { key = "h", mods = "ALT|CTRL",     action = act({ MoveTabRelative = -1 }) },
    { key = "l", mods = "ALT|CTRL",     action = act({ MoveTabRelative = 1 }) },
    --{ key = "k", mods = "ALT|CTRL", action = act.ActivateCopyMode },
    {
        key = "k",
        mods = "ALT|CTRL",
        action = act.Multiple({ act.CopyMode("ClearSelectionMode"), act.ActivateCopyMode, act.ClearSelection }),
    },
    { key = "j",     mods = "ALT|CTRL",       action = act({ PasteFrom = "PrimarySelection" }) },
    { key = "1",     mods = "ALT",            action = act({ ActivateTab = 0 }) },
    { key = "2",     mods = "ALT",            action = act({ ActivateTab = 1 }) },
    { key = "3",     mods = "ALT",            action = act({ ActivateTab = 2 }) },
    { key = "4",     mods = "ALT",            action = act({ ActivateTab = 3 }) },
    { key = "5",     mods = "ALT",            action = act({ ActivateTab = 4 }) },
    { key = "6",     mods = "ALT",            action = act({ ActivateTab = 5 }) },
    { key = "7",     mods = "ALT",            action = act({ ActivateTab = 6 }) },
    { key = "8",     mods = "ALT",            action = act({ ActivateTab = 7 }) },
    { key = "9",     mods = "ALT",            action = act({ ActivateTab = 8 }) },
    { key = "h",     mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Left", 1 } }) },
    { key = "l",     mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Right", 1 } }) },
    { key = "k",     mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Up", 1 } }) },
    { key = "j",     mods = "ALT|SHIFT|CTRL", action = act({ AdjustPaneSize = { "Down", 1 } }) },
    { key = "Enter", mods = "ALT",            action = "QuickSelect" },
    { key = "/",     mods = "ALT",            action = act.Search("CurrentSelectionOrEmptyString") },
}

M.default_keybinds = {
    -- checked
    { key = "=",        mods = "CTRL",       action = "ResetFontSize" },
    { key = "+",        mods = "CTRL",       action = "IncreaseFontSize" },
    { key = "-",        mods = "CTRL",       action = "DecreaseFontSize" },
    -- checking
    { key = "c",        mods = "CTRL|SHIFT", action = act({ CopyTo = "Clipboard" }) },
    { key = "v",        mods = "CTRL|SHIFT", action = act({ PasteFrom = "Clipboard" }) },
    { key = "Insert",   mods = "SHIFT",      action = act({ PasteFrom = "PrimarySelection" }) },
    { key = "PageUp",   mods = "ALT",        action = act({ ScrollByPage = -1 }) },
    { key = "PageDown", mods = "ALT",        action = act({ ScrollByPage = 1 }) },
    { key = "z",        mods = "ALT",        action = "ReloadConfiguration" },
    { key = "z",        mods = "ALT|SHIFT",  action = act({ EmitEvent = "toggle-tmux-keybinds" }) },
    { key = "e",        mods = "ALT",        action = act({ EmitEvent = "trigger-nvim-with-scrollback" }) },
    { key = "q",        mods = "ALT",        action = act({ CloseCurrentPane = { confirm = true } }) },
    { key = "x",        mods = "ALT",        action = act({ CloseCurrentPane = { confirm = true } }) },
    {
        key = "r",
        mods = "ALT",
        action = act({
            ActivateKeyTable = {
                name = "resize_pane",
                one_shot = false,
                timeout_milliseconds = 3000,
                replace_current = false,
            },
        }),
    },
    { key = "s", mods = "ALT", action = act.PaneSelect({
        alphabet = "1234567890",
    }) },
    {
        key = "b",
        mods = "ALT",
        action = act.RotatePanes("CounterClockwise"),
    },
    { key = "f", mods = "ALT", action = act.RotatePanes("Clockwise") },
}

function M.create_keybinds()
  return utils.merge_lists(M.default_keybinds, M.tmux_keybinds)
end

M.key_tables = {
    resize_pane = {
        -- { key = "LeftArrow",  action = act({ AdjustPaneSize = { "Left", 1 } }) },
        -- { key = "RightArrow", action = act({ AdjustPaneSize = { "Right", 1 } }) },
        -- { key = "UpArrow",    action = act({ AdjustPaneSize = { "Up", 1 } }) },
        -- { key = "DownArrow",  action = act({ AdjustPaneSize = { "Down", 1 } }) },
        -- Cancel the mode by pressing escape
        -- { key = "Escape", action = "PopKeyTable" },
        { key = "h", mods = "SHIFT", action = act({ AdjustPaneSize = { "Left", 1 } }) },
        { key = "l", mods = "SHIFT", action = act({ AdjustPaneSize = { "Right", 1 } }) },
        { key = "k", mods = "SHIFT", action = act({ AdjustPaneSize = { "Up", 1 } }) },
        { key = "j", mods = "SHIFT", action = act({ AdjustPaneSize = { "Down", 1 } }) },
    },
}

return M
