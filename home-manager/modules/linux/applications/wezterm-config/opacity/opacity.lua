local M = {}

M.init = function()
	local opacity = {}
	for i = 10, 90, 10 do
		table.insert(opacity, { label = string.format("%2d%%", i), value = i / 100 })
	end
	table.insert(opacity, { label = "Full", value = 100 })
	return opacity
end

M.activate = function(config, _, value)
	config.window_background_opacity = value
	config.macos_window_background_blur = 25
end

return M
