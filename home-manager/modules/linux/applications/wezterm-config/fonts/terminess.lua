local wezterm = require("wezterm")
local M = {}
local name = "Terminess Nerd Font"

M.init = function()
  return name
end

M.activate = function(config)
  config.font = wezterm.font(name)
  -- config.freetype_load_target = "Light"
  -- config.freetype_render_target = "HorizontalLcd"
  config.font_size = 12.0
  config.line_height = 1.0
  config.harfbuzz_features = { "ss02=1" }
  config.font_rules = {}
end

return M
