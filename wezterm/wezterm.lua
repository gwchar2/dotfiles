local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Start directly inside Ubuntu WSL
config.default_domain = "WSL:Ubuntu"

-- Appearance: Kun Chen-inspired direction
config.color_scheme = "rose-pine-moon"
config.font_size = 12.0
config.max_fps = 120

-- Window
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_background_opacity = 0.9
config.window_close_confirmation = "NeverPrompt"

-- Quality of life
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.adjust_window_size_when_changing_font_size = false

-- Keybindings
config.keys = {
  {
    key = "Enter",
    mods = "ALT",
    action = wezterm.action.ToggleFullScreen,
  },
}

return config
