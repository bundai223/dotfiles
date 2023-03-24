-- https://github.com/yutkat/dotfiles/blob/main/.config/wezterm/on.lua

local wezterm = require("wezterm")
-- local act = wezterm.action
local utils = require("utils")
-- local keybinds = require("keybinds")
local scheme = wezterm.get_builtin_color_schemes()["iceberg-dark"]

local function create_tab_title(tab, tabs, panes, config, hover, max_width)
  local user_title = tab.active_pane.user_vars.panetitle
  if user_title ~= nil and #user_title > 0 then
    return tab.tab_index + 1 .. ":" .. user_title
  end
  -- pane:get_foreground_process_info().status

  local title = wezterm.truncate_right(utils.basename(tab.active_pane.foreground_process_name), max_width)
  if title == "" then
    local dir = string.gsub(tab.active_pane.title, "(.*[: ])(.*)]", "%2")
    dir = utils.convert_useful_path(dir)
    title = wezterm.truncate_right(dir, max_width)
  end

  local copy_mode, n = string.gsub(tab.active_pane.title, "(.+) mode: .*", "%1", 1)
  if copy_mode == nil or n == 0 then
    copy_mode = ""
  else
    copy_mode = copy_mode .. ": "
  end
  return copy_mode .. tab.tab_index + 1 .. ":" .. title
end

---------------------------------------------------------------
--- wezterm on
---------------------------------------------------------------
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = create_tab_title(tab, tabs, panes, config, hover, max_width)

  local solid_left_arrow = utf8.char(0x2590)
  local solid_right_arrow = utf8.char(0x258c)
  -- https://github.com/wez/wezterm/issues/807
  -- local edge_background = scheme.background
  -- https://github.com/wez/wezterm/blob/61f01f6ed75a04d40af9ea49aa0afe91f08cb6bd/config/src/color.rs#L245
  local edge_background = "#2e3440"
  local background = scheme.ansi[1]
  local foreground = scheme.ansi[5]

  if tab.is_active then
    background = scheme.brights[1]
    foreground = scheme.brights[8]
  elseif hover then
    background = scheme.cursor_bg
    foreground = scheme.cursor_fg
  end
  local edge_foreground = background

  return {
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = solid_left_arrow },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = solid_right_arrow },
    { Attribute = { Intensity = "Normal" } },
  }
end)
