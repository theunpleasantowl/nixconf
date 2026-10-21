{ osConfig ? null, lib, ... }:
let
  lua = lib.generators.mkLuaInline;
  # Connector names (DP-1, DP-3, ...) are re-enumerated on every boot, so
  # workspaces are bound to monitors by position instead of by name:
  # leftmost monitor gets 1-5, the one next to it gets 6-10.
  assignWorkspaces = ''
    function()
      local mons = hl.get_monitors()
      if #mons == 0 then return end
      table.sort(mons, function(a, b) return a.x < b.x end)
      local left = mons[1].name
      local right = mons[2] and mons[2].name or left
      for i = 1, 5 do
        hl.workspace_rule({
          workspace = tostring(i),
          monitor = left,
          persistent = true,
          default = i == 1,
        })
      end
      for i = 6, 10 do
        hl.workspace_rule({
          workspace = tostring(i),
          monitor = right,
          persistent = true,
          default = i == 6,
        })
      end
    end
  '';
in
lib.mkIf ((osConfig.networking.hostName or null) == "neptune") {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1;
      }
    ];

    on = lib.mkAfter [
      {
        _args = [
          "hyprland.start"
          (lua assignWorkspaces)
        ];
      }
      {
        _args = [
          "config.reloaded"
          (lua assignWorkspaces)
        ];
      }
      {
        _args = [
          "monitor.added"
          (lua assignWorkspaces)
        ];
      }
      {
        _args = [
          "monitor.removed"
          (lua assignWorkspaces)
        ];
      }
    ];

    config.general = {
      gaps_in = lib.mkForce 8;
      gaps_out = lib.mkForce 32;
      border_size = lib.mkForce 2;
    };
    config.decoration = {
      blur = {
        size = lib.mkForce 8;
        passes = lib.mkForce 3;
      };
      rounding = lib.mkForce 0;
    };
  };
  programs.noctalia.settings.bar.main.position = lib.mkForce "top";
  programs.noctalia.settings.bar.main.concave_edge_corners = lib.mkForce false;
}
