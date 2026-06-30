local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Windows WezTerm opens directly into WSL Ubuntu in the WSL home directory.
-- macOS WezTerm opens into a persistent tmux session.
if wezterm.target_triple:find("windows") then
  config.default_prog = {
    "wsl.exe",
    "--distribution",
    "Ubuntu",
    "--cd",
    "~",
    "--exec",
    "zsh",
    "-l",
  }
elseif wezterm.target_triple:find("darwin") then
  config.default_prog = {
    "/bin/zsh",
    "-l",
    "-c",
    "exec tmux new-session -A -s main",
  }
end

wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- General behavior
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.check_for_updates = false
config.default_cursor_style = "SteadyBar"
config.max_fps = 120

-- Appearance
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_background_opacity = 0.97
config.text_background_opacity = 1.0
config.font_size = 12.0

config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
  "JetBrains Mono",
  "Cascadia Mono",
  "Consolas",
})

local schemes = wezterm.color.get_builtin_schemes()
if schemes["Nord (Gogh)"] then
  config.color_scheme = "Nord (Gogh)"
elseif schemes["nord"] then
  config.color_scheme = "nord"
else
  config.color_scheme = "rose-pine-moon"
end

config.colors = {
  background = "#111827",
  tab_bar = {
    background = "#111827",
    active_tab = {
      bg_color = "#1F2937",
      fg_color = "#E5E7EB",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#111827",
      fg_color = "#9CA3AF",
    },
    inactive_tab_hover = {
      bg_color = "#263244",
      fg_color = "#E5E7EB",
    },
    new_tab = {
      bg_color = "#111827",
      fg_color = "#9CA3AF",
    },
    new_tab_hover = {
      bg_color = "#263244",
      fg_color = "#E5E7EB",
    },
  },
}

config.window_padding = {
  left = 6,
  right = 2,
  top = 4,
  bottom = 2,
}

-- Keys
config.keys = {
  {
    key = "Enter",
    mods = "ALT",
    action = wezterm.action.ToggleFullScreen,
  },
}

-- macOS: Cmd + Enter also toggles fullscreen.
if wezterm.target_triple:find("darwin") then
  table.insert(config.keys, {
    key = "Enter",
    mods = "SUPER",
    action = wezterm.action.ToggleFullScreen,
  })
end

-- Right-click paste
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
}

return config
