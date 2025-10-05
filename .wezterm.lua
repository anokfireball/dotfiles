---@type Wezterm
local wezterm = require("wezterm")

local target_os = wezterm.target_triple
---@type Config
local config = wezterm.config_builder()

local base_mono = "JetBrainsMono Nerd Font"

if target_os:find("apple") then
	config.font = wezterm.font_with_fallback({
		base_mono,
		{ family = "Apple Color Emoji", assume_emoji_presentation = true },
	})
	config.font_size = 14
	config.freetype_load_target = "HorizontalLcd"
	config.keys = {
		-- consistent ctrl behaviour between both systems
		{ key = "c", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
		{ key = "v", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
		-- no tabs on the emulator level
		{ key = "t", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	}
elseif target_os:find("windows") then
	config.font = wezterm.font_with_fallback({
		base_mono,
		{ family = "Segoe UI Emoji", assume_emoji_presentation = true },
	})
	config.font_size = 11
	config.wsl_domains = {
		{
			name = "WSL:Debian",
			distribution = "Debian",
			default_cwd = "~",
			default_prog = { "bash" },
		},
	}
	config.default_domain = "WSL:Debian"
	config.keys = {
		-- no tabs on the emulator level
		{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
	}
end
config.line_height = 0.9
config.animation_fps = 144
config.color_scheme = "Dracula (Official)"

config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.scrollback_lines = 250 -- 4K @ 16 pixels per line = ~135 lines
config.enable_scroll_bar = false
config.swallow_mouse_click_on_window_focus = true

return config
