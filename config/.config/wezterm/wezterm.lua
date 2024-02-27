local wezterm = require 'wezterm';
local keybinds = require("keybinds")
require("on")

------------------------------------------
-- Launch Menu
local default_prog = {}

local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- Main Wsl
  table.insert(launch_menu, {
    label = 'Ubuntu 22.04',
    -- args = { 'wsl.exe', '~ -d Ubuntu-22.04 --' }
    args = { 'wsl.exe', '~' }
  })

  -- Main Powershell
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'pwsh.exe' },
  })

  -- Old Powershell(緊急時用)
  table.insert(launch_menu, {
    label = 'Old PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })


  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  for _, vsvers in
  ipairs(
    wezterm.glob('Microsoft Visual Studio/20*', 'C:/Program Files (x86)')
  )
  do
    local year = vsvers:gsub('Microsoft Visual Studio/', '')
    table.insert(launch_menu, {
      label = 'x64 Native Tools VS ' .. year,
      args = {
        'cmd.exe',
        '/k',
        'C:/Program Files (x86)/'
        .. vsvers
        .. '/BuildTools/VC/Auxiliary/Build/vcvars64.bat',
      },
    })
  end
else
  table.insert(launch_menu, {
    label = 'Zsh',
    args = { 'zsh', '-l' }
  })
end
------------------------------------------

------------------------------------------
-- default_progをdist毎に変更したい時の記述方法
--
-- local wsl_domains = wezterm.default_wsl_domains()

-- for idx, dom in ipairs(wsl_domains) do
--   if dom.name == 'WSL:Ubuntu-22.04' then
--     dom.default_prog = { 'zsh' }
--   end
-- end
------------------------------------------

default_prog = launch_menu[1].args
-- default_prog = { 'wsl.exe', '-d Ubuntu-22.04'}

local config = {
  ------------------------------------------
  -- General
  -- default_cwd = '~',
  -- wsl_domains = wsl_domains,
  default_prog = default_prog,
  launch_menu = launch_menu,
  use_ime = true,
  ------------------------------------------
  -- Appearance
  window_decorations = 'RESIZE', -- OSの制御バー消す
  -- font = wezterm.font("HackGenNerd Console"), -- 自分の好きなフォントいれる
  -- font = wezterm.font("Fira Code"), -- 自分の好きなフォントいれる
  font = wezterm.font_with_fallback {
    'Fira Code',
    "HackGenNerd Console",
    "Symbols Nerd Font Mono"
  },
  font_size = 12.0,
  -- color_scheme = "iceberg-dark", -- 自分の好きなテーマ探す https://wezfurlong.org/wezterm/colorschemes/index.html
  color_scheme = "nord", -- 自分の好きなテーマ探す https://wezfurlong.org/wezterm/colorschemes/index.html
  -- window_background_opacity = 0.8,
  -- window_frame = {
  --   inactive_titlebar_bg = '#353535',
  --   active_titlebar_bg = '#2b2042',
  --   inactive_titlebar_fg = '#cccccc',
  --   active_titlebar_fg = '#ffffff',
  --   inactive_titlebar_border_bottom = '#2b2042',
  --   active_titlebar_border_bottom = '#2b2042',
  --   button_fg = '#cccccc',
  --   button_bg = '#2b2042',
  --   button_hover_fg = '#ffffff',
  --   button_hover_bg = '#3b3052',
  -- },

  text_background_opacity = 1.0,
  hide_tab_bar_if_only_one_tab = false,
  adjust_window_size_when_changing_font_size = false,
  ------------------------------------------
  -- Key Binding
  -- timeout_milliseconds defaults to 1000 and can be omitted
  leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1001 },
  disable_default_key_bindings = true,
  keys = keybinds.create_keybinds(),
  key_tables = keybinds.key_tables,
}

return config
