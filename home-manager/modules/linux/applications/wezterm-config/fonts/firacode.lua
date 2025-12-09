local wezterm = require("wezterm")
local M = {}
local name = "FiraCode Nerd Font"

M.init = function()
	return name
end

M.activate = function(config)
	config.font = wezterm.font(name)
	config.font_size = 11.0
	config.line_height = 1.1
	config.harfbuzz_features = { "ss01=1" }
	config.font_rules = {}
end

return M
