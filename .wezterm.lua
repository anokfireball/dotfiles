local wezterm = require("wezterm")

local target_os = wezterm.target_triple
local config = wezterm.config_builder()

if target_os:find("apple") then
	config.freetype_load_target = "HorizontalLcd"
elseif target_os:find("windows") then
	config.default_prog = { "wsl.exe", "--cd", "~" }
end
config.font_size = 14
config.color_scheme = "Dracula"
config.hide_tab_bar_if_only_one_tab = true

return config
