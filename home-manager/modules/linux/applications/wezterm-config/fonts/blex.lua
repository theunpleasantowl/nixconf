local wezterm = require("wezterm")
local M = {}
local name = "BlexMono Nerd Font"

M.init = function()
	return name
end

M.activate = function(config)
	config.font = wezterm.font(name)
	config.font_size = 12.0
	config.line_height = 1.2
	config.harfbuzz_features = {}
	config.font_rules = {}
end

return M
