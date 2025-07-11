local wezterm = require("wezterm")

local target_os = wezterm.target_triple
local config = wezterm.config_builder()

if target_os:find("apple") then
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
config.animation_fps = 144
config.color_scheme = "Dracula (Official)"
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

return config
