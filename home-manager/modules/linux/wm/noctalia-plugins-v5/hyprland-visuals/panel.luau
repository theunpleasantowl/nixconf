local options = {
  { key = "decoration:blur:enabled", type = "bool", label = "Blur", default = true },
  { key = "decoration:blur:passes", type = "number", label = "Blur passes", min = 0, max = 8, step = 1, default = 2 },
  { key = "decoration:blur:size", type = "number", label = "Blur size", min = 0, max = 24, step = 1, default = 6 },
  { key = "decoration:blur:xray", type = "bool", label = "Blur x-ray", default = false },
  { key = "decoration:blur:ignore_opacity", type = "bool", label = "Ignore opacity", default = false },
  { key = "decoration:blur:noise", type = "number", label = "Blur noise", min = 0, max = 0.1, step = 0.005, default = 0.02 },
  { key = "decoration:blur:contrast", type = "number", label = "Blur contrast", min = 0.5, max = 2, step = 0.05, default = 1 },
  { key = "decoration:blur:brightness", type = "number", label = "Blur brightness", min = 0.2, max = 1.5, step = 0.05, default = 1 },
  { key = "decoration:blur:vibrancy", type = "number", label = "Blur vibrancy", min = 0, max = 1, step = 0.05, default = 0 },
  { key = "decoration:shadow:enabled", type = "bool", label = "Shadows", default = true },
  { key = "decoration:shadow:range", type = "number", label = "Shadow range", min = 0, max = 30, step = 1, default = 4 },
  { key = "decoration:shadow:render_power", type = "number", label = "Shadow render power", min = 1, max = 8, step = 1, default = 3 },
  { key = "decoration:shadow:scale", type = "number", label = "Shadow scale", min = 0.5, max = 2, step = 0.05, default = 1 },
  { key = "decoration:rounding", type = "number", label = "Corner radius", min = 0, max = 24, step = 1, default = 10 },
  { key = "decoration:active_opacity", type = "number", label = "Active opacity", min = 0.2, max = 1, step = 0.05, default = 1 },
  { key = "decoration:inactive_opacity", type = "number", label = "Inactive opacity", min = 0.2, max = 1, step = 0.05, default = 1 },
  { key = "decoration:fullscreen_opacity", type = "number", label = "Fullscreen opacity", min = 0.2, max = 1, step = 0.05, default = 1 },
  { key = "decoration:dim_inactive", type = "bool", label = "Dim inactive", default = false },
  { key = "decoration:dim_strength", type = "number", label = "Dim strength", min = 0, max = 1, step = 0.05, default = 0 },
  { key = "decoration:dim_special", type = "number", label = "Dim special", min = 0, max = 1, step = 0.05, default = 0 },
  { key = "decoration:dim_around", type = "number", label = "Dim around", min = 0, max = 1, step = 0.05, default = 0 },
  { key = "general:gaps_in", type = "number", label = "Inner gaps", min = 0, max = 64, step = 1, default = 4 },
  { key = "general:gaps_out", type = "number", label = "Outer gaps", min = 0, max = 96, step = 1, default = 5 },
}

local values = {}
local loaded = false

for _, opt in ipairs(options) do
  values[opt.key] = opt.default
end

local function safeKey(key)
  return key:gsub(":", "_")
end

local function lastToken(text)
  local last = ""
  for w in tostring(text):gmatch("%S+") do
    last = w
  end
  return last
end

local function parseValue(opt, text)
  local token = lastToken(text)
  if opt.type == "bool" then
    local lower = token:lower()
    return lower == "true" or lower == "1" or lower == "on" or lower == "yes"
  else
    return tonumber(token) or opt.default or 0
  end
end

local function readAll()
  loaded = false
  local remaining = #options
  for _, opt in ipairs(options) do
    noctalia.runAsync("hyprctl getoption " .. opt.key, function(result)
      remaining = remaining - 1
      if result and result.exitCode == 0 then
        values[opt.key] = parseValue(opt, result.stdout)
      else
        values[opt.key] = opt.default
      end
      if remaining == 0 then
        loaded = true
        render()
      end
    end)
  end
end

local function apply(key, value)
  values[key] = value
  local v = tostring(value)
  if type(value) == "boolean" then
    v = value and "true" or "false"
  end
  noctalia.runAsync("hyprctl keyword " .. key .. " " .. v)
end

local function makeControl(opt)
  local key = opt.key
  local v = values[key]
  local safe = safeKey(key)
  if opt.type == "bool" then
    return ui.row({ align = "center", justify = "space_between" }, {
      ui.label({ text = opt.label, flexGrow = 1 }),
      ui.toggle({ checked = v == true, onChange = "onToggle_" .. safe }),
    })
  else
    return ui.column({ gap = 4, fillWidth = true }, {
      ui.row({ align = "center", justify = "space_between" }, {
        ui.label({ text = opt.label, flexGrow = 1 }),
        ui.label({ text = tostring(v), key = "val-" .. safe }),
      }),
      ui.slider({ min = opt.min, max = opt.max, step = opt.step, value = v, onChange = "onSlider_" .. safe }),
    })
  end
end

function render()
  local controlCol = ui.column({ gap = 12 }, {})
  for _, opt in ipairs(options) do
    table.insert(controlCol.children, makeControl(opt))
  end

  panel.render(ui.column({ gap = 12, padding = 16, fill = true }, {
    ui.row({ align = "center", justify = "space_between" }, {
      ui.label({ text = "Hyprland Visuals", fontSize = 18, fontWeight = "bold", color = "primary", flexGrow = 1 }),
      ui.button({ glyph = "refresh", onClick = "onReset", tooltip = "Reset to config" }),
      ui.button({ glyph = "x", onClick = "onClose", tooltip = "Close" }),
    }),
    ui.separator(),
    ui.scroll({ fill = true }, { controlCol }),
    ui.row({ align = "center", justify = "center" }, {
      ui.label({ text = loaded and "" or "Loading…", color = "on_surface/0.6" }),
    }),
  }))
end

function onToggle_decoration_blur_enabled(value)
  apply("decoration:blur:enabled", value == "true")
  render()
end

function onSlider_decoration_blur_passes(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:blur:passes", n)
    render()
  end
end

function onSlider_decoration_blur_size(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:blur:size", n)
    render()
  end
end

function onToggle_decoration_blur_xray(value)
  apply("decoration:blur:xray", value == "true")
  render()
end

function onToggle_decoration_blur_ignore_opacity(value)
  apply("decoration:blur:ignore_opacity", value == "true")
  render()
end

function onSlider_decoration_blur_noise(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:blur:noise", n)
    render()
  end
end

function onSlider_decoration_blur_contrast(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:blur:contrast", n)
    render()
  end
end

function onSlider_decoration_blur_brightness(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:blur:brightness", n)
    render()
  end
end

function onSlider_decoration_blur_vibrancy(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:blur:vibrancy", n)
    render()
  end
end

function onToggle_decoration_shadow_enabled(value)
  apply("decoration:shadow:enabled", value == "true")
  render()
end

function onSlider_decoration_shadow_range(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:shadow:range", n)
    render()
  end
end

function onSlider_decoration_shadow_render_power(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:shadow:render_power", n)
    render()
  end
end

function onSlider_decoration_shadow_scale(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:shadow:scale", n)
    render()
  end
end

function onSlider_decoration_rounding(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:rounding", n)
    render()
  end
end

function onSlider_decoration_active_opacity(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:active_opacity", n)
    render()
  end
end

function onSlider_decoration_inactive_opacity(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:inactive_opacity", n)
    render()
  end
end

function onSlider_decoration_fullscreen_opacity(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:fullscreen_opacity", n)
    render()
  end
end

function onToggle_decoration_dim_inactive(value)
  apply("decoration:dim_inactive", value == "true")
  render()
end

function onSlider_decoration_dim_strength(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:dim_strength", n)
    render()
  end
end

function onSlider_decoration_dim_special(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:dim_special", n)
    render()
  end
end

function onSlider_decoration_dim_around(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("decoration:dim_around", n)
    render()
  end
end

function onSlider_general_gaps_in(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("general:gaps_in", n)
    render()
  end
end

function onSlider_general_gaps_out(value)
  local n = tonumber(value)
  if n ~= nil then
    apply("general:gaps_out", n)
    render()
  end
end

function onOpen(context)
  readAll()
end

function onReset()
  noctalia.runAsync("hyprctl reload", function(_result)
    readAll()
  end)
end

function onClose()
  panel.close()
end

function onIpc(event, _payload)
  if event == "toggle" or event == "openPanel" then
    noctalia.togglePanel("hibiki/hyprland-visuals:panel")
  elseif event == "reset" then
    onReset()
  end
end

readAll()
