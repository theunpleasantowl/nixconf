local wezterm = require("wezterm")
local M = {}
local name = "HeavyData Nerd Font"

M.init = function()
	return name
end

M.activate = function(config)
	config.font = wezterm.font(name)
	config.font_size = 20.0
	config.line_height = 0.9
	config.cell_width = 0.6
	config.font_rules = {}
end

return M
