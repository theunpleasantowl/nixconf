local wezterm = require("wezterm")
local M = {}
local name = "BigBlueTermPlus Nerd Font"

M.init = function()
	return name
end

M.activate = function(config)
	config.font = wezterm.font(name)
	config.font_size = 12.0
	config.line_height = 1.3
	config.harfbuzz_features = { "ss02=1" }
	config.font_rules = {}
end

return M
