local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}
local is_darwin = wezterm.target_triple:find("darwin") ~= nil

-- Windows WezTerm opens directly into WSL Ubuntu in the WSL home directory.
-- macOS WezTerm opens a normal login shell.
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
elseif is_darwin then
	config.default_prog = {
		"/bin/zsh",
		"-l",
	}
end

wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	local gui_window = window:gui_window()

	if is_darwin then
		local screen = wezterm.gui.screens().active
		local inset = 20

		gui_window:set_position(screen.x + inset, screen.y + inset)
		gui_window:set_inner_size(screen.width - (inset * 2), screen.height - (inset * 2))
	else
		gui_window:maximize()
	end
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
config.font_size = 10.0
config.window_decorations = "RESIZE"

if is_darwin then
	config.window_background_opacity = 0.94
	config.macos_window_background_blur = 24
end

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
		key = "c",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\x1b[13;2u"),
	},
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

-- Open hyperlinks with Ctrl + left-click.
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
