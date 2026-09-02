{ lib, pkgs, ... }:
pkgs.writeTextFile {
  name = "hyprlandGaps";
  destination = "/bin/hyprlandGaps";
  executable = true;
  text = ''
    #!${lib.getExe pkgs.lua}

    local hyprctl = "${lib.getExe' pkgs.hyprland "hyprctl"}"
    local config_path = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr/hyprland.lua"
    local interval_in = 2
    local interval_out = 8

    local function shell_quote(value)
      local quote = string.char(39)
      return quote .. tostring(value):gsub(quote, quote .. "\\" .. quote .. quote) .. quote
    end

    local function last_number(text)
      local found

      for token in text:gmatch("%S+") do
        token = token:gsub(",$", "")
        if token:match("^%-?%d+%.?%d*$") then
          found = tonumber(token)
        end
      end

      return found
    end

    local function command_output(command)
      local handle = assert(io.popen(command))
      local output = handle:read("*a")
      handle:close()
      return output
    end

    local function get_option(name)
      return last_number(command_output(hyprctl .. " getoption " .. name))
    end

    local function normalize_line(line)
      return line:gsub("#.*", ""):gsub("%-%-.*", ""):match("^%s*(.-)%s*$")
    end

    local function parse_config_values(path)
      local values = {}
      local stack = {}
      local file = io.open(path, "r")

      if not file then
        return values
      end

      for line in file:lines() do
        line = normalize_line(line)

        while line:match("^}") do
          stack[#stack] = nil
          line = line:gsub("^}%s*,?", ""):match("^%s*(.-)%s*$")
        end

        if line ~= "" and not line:match("^hl%.[%w_]+%(%{%s*$") and not line:match("^%)") then
          local quoted_table = line:match('^%["([^"]+)"%]%s*=%s*{%s*,?$')
          local bare_table = line:match("^([%w_]+)%s*=%s*{%s*,?$")

          if quoted_table or bare_table then
            stack[#stack + 1] = quoted_table or bare_table
          else
            local key, value = line:match('^%["([^"]+)"%]%s*=%s*([^,]+),?$')

            if not key then
              key, value = line:match("^([%w_]+)%s*=%s*([^,]+),?$")
            end

            if key and value then
              local full_key = table.concat(stack, ":") .. ":" .. key

              if full_key == "general:gaps_in" then
                values.gaps_in = tonumber(value)
              elseif full_key == "general:gaps_out" then
                values.gaps_out = tonumber(value)
              elseif full_key == "decoration:rounding" then
                values.rounding = tonumber(value)
              end
            end
          end
        end
      end

      file:close()
      return values
    end

    local function apply(gaps_in, gaps_out, rounding)
      local expr = ("hl.config({ [\"general.gaps_in\"] = %s, [\"general.gaps_out\"] = %s, [\"decoration.rounding\"] = %s })")
        :format(gaps_in, gaps_out, rounding)
      local ok, _, code = os.execute(hyprctl .. " eval " .. shell_quote(expr))

      if ok == true then
        os.exit(0)
      elseif type(ok) == "number" then
        os.exit(ok)
      else
        os.exit(code or 1)
      end
    end

    local function clamp_gap(value)
      return math.max(0, value)
    end

    local action = arg[1]

    if action ~= "tog" and action ~= "dec" and action ~= "inc" then
      io.stderr:write("usage: hyprlandGaps tog|dec|inc\n")
      os.exit(1)
    end

    local current_in = assert(get_option("general:gaps_in"), "failed to read general:gaps_in")
    local current_out = assert(get_option("general:gaps_out"), "failed to read general:gaps_out")
    local defaults = parse_config_values(config_path)

    local gaps_in
    local gaps_out

    if action == "tog" then
      if current_in > 0 then
        gaps_in = 0
        gaps_out = 0
      else
        gaps_in = defaults.gaps_in or current_in
        gaps_out = defaults.gaps_out or current_out
      end
    elseif action == "dec" then
      if current_in <= 0 then
        os.exit(0)
      end

      gaps_in = clamp_gap(current_in - interval_in)
      gaps_out = clamp_gap(current_out - interval_out)
    elseif action == "inc" then
      gaps_in = current_in + interval_in
      gaps_out = current_out + interval_out
    end

    local rounding = 0

    if gaps_in > 0 and gaps_out > 0 then
      rounding = defaults.rounding or get_option("decoration:rounding") or 0
    else
      gaps_in = 0
      gaps_out = 0
    end

    apply(gaps_in, gaps_out, rounding)
  '';
}
