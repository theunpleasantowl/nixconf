{
  config,
  pkgs,
  lib,
  ...
}:
let
  useStylix = config.stylix.enable or false;
  colors = config.lib.stylix.colors or { };
  lua = lib.generators.mkLuaInline;
  rgb = color: "rgb(${color})";
  rgba = color: alpha: "rgba(${color}${alpha})";
  mkBind = keys: dispatcher: {
    _args = [
      keys
      (lua dispatcher)
    ];
  };
  mkBindWith = keys: dispatcher: opts: {
    _args = [
      keys
      (lua dispatcher)
      opts
    ];
  };
  exec = command: "hl.dsp.exec_cmd(${builtins.toJSON command})";
  focus = direction: "hl.dsp.focus({ direction = ${builtins.toJSON direction} })";
  moveWindow = direction: "hl.dsp.window.move({ direction = ${builtins.toJSON direction} })";
  resizeWindow =
    x: y: "hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })";
  workspace = value: "hl.dsp.focus({ workspace = ${builtins.toJSON value} })";
  moveToWorkspace = value: "hl.dsp.window.move({ workspace = ${builtins.toJSON value} })";
  onStart = commands: {
    _args = [
      "hyprland.start"
      (lua ''
        function()
        ${lib.concatMapStrings (command: "  hl.exec_cmd(${builtins.toJSON command})\n") commands}end
      '')
    ];
  };
  shaderSourceDir = ./shaders;
  shaderExtensions = [
    ".frag"
    ".glsl"
    ".shader"
  ];
  mkHyprShaderConfigFiles =
    dir:
    lib.mapAttrs'
      (
        name: _:
        lib.nameValuePair "hypr/shaders/${name}" {
          source = dir + "/${name}";
        }
      )
      (
        lib.filterAttrs (
          name: type: type == "regular" && lib.any (extension: lib.hasSuffix extension name) shaderExtensions
        ) (builtins.readDir dir)
      );

  hyprGaps = import ./scripts/hyprlandGaps.nix { inherit lib pkgs; };
  noctaliaDmenu = pkgs.writeShellScriptBin "noctalia-dmenu" ''
    set -euo pipefail

    prompt=""
    separator="\n"
    timeout=30
    items_file=""
    result_file="$(${pkgs.coreutils}/bin/mktemp -t noctalia-dmenu-result.XXXXXX)"

    qs_ipc() {
      runtime_dir="''${XDG_RUNTIME_DIR:-/run/user/$(${pkgs.coreutils}/bin/id -u)}/quickshell"

      for pid_link in "$runtime_dir"/by-pid/*; do
        [ -e "$pid_link" ] || continue

        pid="$(${pkgs.coreutils}/bin/basename "$pid_link")"
        instance="$(${pkgs.coreutils}/bin/basename "$(${pkgs.coreutils}/bin/readlink "$pid_link")")"
        exe="$(${pkgs.coreutils}/bin/readlink -f "/proc/$pid/exe" 2>/dev/null || true)"

        if [ -n "$instance" ] && [ -n "$exe" ] && [ -x "$exe" ]; then
          "$exe" ipc --id "$instance" "$@"
          return
        fi
      done

      noctalia-shell ipc "$@"
    }

    while [ "$#" -gt 0 ]; do
      case "$1" in
        -p|--prompt)
          prompt="$2"
          shift 2
          ;;
        -t|--timeout)
          timeout="$2"
          shift 2
          ;;
        -s|--separator)
          separator="$2"
          shift 2
          ;;
        -f|--file)
          items_file="$2"
          shift 2
          ;;
        *)
          printf 'noctalia-dmenu: unknown option: %s\n' "$1" >&2
          exit 2
          ;;
      esac
    done

    ${pkgs.coreutils}/bin/rm -f "$result_file" "$result_file.tmp"
    options="$(${lib.getExe pkgs.jq} -cn \
      --arg resultFile "$result_file" \
      --arg prompt "$prompt" \
      --arg separator "$separator" \
      '{ resultFile: $resultFile, resultFormat: "plain", separator: $separator } + if $prompt == "" then {} else { prompt: $prompt } end')"

    if [ -n "$items_file" ]; then
      qs_ipc call plugin:dmenu showFromFile "$items_file" "$options"
    else
      input="$(${pkgs.coreutils}/bin/cat)"
      [ -n "$input" ] || exit 2
      qs_ipc call plugin:dmenu showItems "$input" "$options"
    fi

    elapsed=0
    timeout_ms=$((timeout * 1000))
    while true; do
      if [ -f "$result_file" ]; then
        ${pkgs.coreutils}/bin/cat "$result_file"
        ${pkgs.coreutils}/bin/rm -f "$result_file" "$result_file.tmp"
        exit 0
      fi

      if [ "$timeout" -gt 0 ] && [ "$elapsed" -ge "$timeout_ms" ]; then
        ${pkgs.coreutils}/bin/rm -f "$result_file" "$result_file.tmp"
        exit 1
      fi

      ${pkgs.coreutils}/bin/sleep 0.1
      elapsed=$((elapsed + 100))
    done
  '';
  selectScreenShader = pkgs.writeShellScriptBin "select-screen-shader" ''
    set -euo pipefail

    shader_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/shaders"
    menu="$(${pkgs.coreutils}/bin/mktemp)"
    trap '${pkgs.coreutils}/bin/rm -f "$menu"' EXIT

    {
      printf 'Disable\n'
      if [ -d "$shader_dir" ]; then
        ${pkgs.findutils}/bin/find "$shader_dir" -maxdepth 1 \( -type f -o -type l \) \
          \( -name '*.frag' -o -name '*.glsl' -o -name '*.shader' \) \
          -printf '%f\n' | ${pkgs.coreutils}/bin/sort
      fi
    } > "$menu"

    selection="$(${lib.getExe noctaliaDmenu} --prompt 'Screen shader' --file "$menu" || true)"

    [ -n "$selection" ] || exit 0

    if [ "$selection" = "Disable" ]; then
      ${pkgs.hyprland}/bin/hyprctl eval 'hl.config({ decoration = { screen_shader = "[[EMPTY]]" } })'
      ${pkgs.hyprland}/bin/hyprctl seterror disable
      exit 0
    fi

    shader_path="$shader_dir/$selection"
    shader_lua="$(${pkgs.jq}/bin/jq -Rn --arg shader "$shader_path" '$shader')"
    ${pkgs.hyprland}/bin/hyprctl eval "hl.config({ decoration = { screen_shader = $shader_lua } })"
  '';

  newbeeOcr = import ../../../../../packages/newbee-ocr-nix { inherit pkgs; };
  ocrRegion = pkgs.writeShellScriptBin "ocr-region" ''
    set -euo pipefail

    language="''${1:-chinese}"
    image="$(${pkgs.coreutils}/bin/mktemp --suffix=.png)"
    text="$(${pkgs.coreutils}/bin/mktemp)"
    freeze_pid=""
    cleanup() {
      [ -z "$freeze_pid" ] || ${pkgs.procps}/bin/pkill -P "$freeze_pid" 2>/dev/null || true
      [ -z "$freeze_pid" ] || ${pkgs.coreutils}/bin/kill "$freeze_pid" 2>/dev/null || true
      ${pkgs.coreutils}/bin/rm -f "$image" "$text"
    }
    trap cleanup EXIT

    ${lib.getExe pkgs.hyprpicker} -r -z &
    freeze_pid="$!"
    ${pkgs.coreutils}/bin/sleep 0.2

    geometry="$(${lib.getExe pkgs.slurp} || true)"
    [ -n "$geometry" ] || exit 0

    ${lib.getExe pkgs.grim} -g "$geometry" "$image"

    ${lib.getExe newbeeOcr} recognize --language "$language" --precision fast --format text "$image" \
      | ${pkgs.gawk}/bin/awk 'match($0, /^\[[0-9]+\] (.*) \([0-9.]+%\)$/, line) { print line[1] }' \
      > "$text"

    ${pkgs.wl-clipboard}/bin/wl-copy < "$text"
  '';
  ocrLanguage = pkgs.writeShellScriptBin "ocr-language" ''
    set -euo pipefail

    language="$(printf 'english|japanese' | ${lib.getExe noctaliaDmenu} --prompt 'OCR language' --separator '|' || true)"
    [ -n "$language" ] || exit 0

    image="$(${pkgs.coreutils}/bin/mktemp --suffix=.png)"
    text="$(${pkgs.coreutils}/bin/mktemp)"
    freeze_pid=""
    cleanup() {
      [ -z "$freeze_pid" ] || ${pkgs.procps}/bin/pkill -P "$freeze_pid" 2>/dev/null || true
      [ -z "$freeze_pid" ] || ${pkgs.coreutils}/bin/kill "$freeze_pid" 2>/dev/null || true
      ${pkgs.coreutils}/bin/rm -f "$image" "$text"
    }
    trap cleanup EXIT

    ${lib.getExe pkgs.hyprpicker} -r -z &
    freeze_pid="$!"
    ${pkgs.coreutils}/bin/sleep 0.2

    geometry="$(${lib.getExe pkgs.slurp} || true)"
    [ -n "$geometry" ] || exit 0

    ${lib.getExe pkgs.grim} -g "$geometry" "$image"

    ${lib.getExe newbeeOcr} recognize --language "$language" --precision fast --format text "$image" \
      | ${pkgs.gawk}/bin/awk 'match($0, /^\[[0-9]+\] (.*) \([0-9.]+%\)$/, line) { print line[1] }' \
      > "$text"

    ${pkgs.wl-clipboard}/bin/wl-copy < "$text"
  '';

in
{
  stylix.targets.hyprland.enable = lib.mkIf useStylix (lib.mkDefault false);

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      config = lib.mkMerge [
        {
          input = {
            kb_layout = "us";
            follow_mouse = 1;
            touchpad = {
              natural_scroll = true;
            };
            sensitivity = 0;
          };

          general = {
            gaps_in = 4;
            gaps_out = 5;
            border_size = 1;
            layout = "dwindle";
          };

          decoration = {
            rounding = 10;
            blur = {
              enabled = true;
              size = 6;
              passes = 2;
              popups = true;
            };
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = lib.mkDefault "rgba(1a1a1aee)";
            };
          };

          animations = {
            enabled = true;
          };

          dwindle = {
            preserve_split = true;
          };

          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };

          misc = {
            disable_splash_rendering = true;
            force_default_wallpaper = 3;
          };
        }
        (lib.mkIf useStylix {
          decoration.shadow.color = rgba colors.base00 "99";
          general.col = {
            active_border = rgb colors.base0D;
            inactive_border = rgb colors.base03;
          };
          group = {
            col = {
              border_inactive = rgb colors.base03;
              border_active = rgb colors.base0D;
              border_locked_active = rgb colors.base0C;
            };
            groupbar = {
              text_color = rgb colors.base05;
              col = {
                active = rgb colors.base0D;
                inactive = rgb colors.base03;
              };
            };
          };
          misc.background_color = rgb colors.base00;
        })
      ];

      monitor = lib.mkDefault [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      curve = [
        {
          _args = [
            "myBezier"
            (lua ''{ type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } }'')
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 7;
          bezier = "myBezier";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 7;
          bezier = "default";
          style = "popin 80%";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "borderangle";
          enabled = true;
          speed = 8;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 7;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 6;
          bezier = "default";
        }
      ];

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
      ];

      layer_rule = {
        name = "noctalia-shell";
        match.namespace = "noctalia-(background|notifications)-.*$";
        ignore_alpha = 0.5;
        blur = true;
        blur_popups = true;
      };

      on = onStart [
        "noctalia-shell"
        "${lib.getExe pkgs.keepassxc}"
      ];

      bind = [
        (mkBind "SUPER + M" "hl.dsp.window.fullscreen(1)")
        (mkBind "SUPER + F" "hl.dsp.window.fullscreen(0)")

        (mkBind "SUPER + G" (exec "${lib.getExe hyprGaps} tog"))
        (mkBind "SUPER + MINUS" (exec "${lib.getExe hyprGaps} dec"))
        (mkBind "SUPER + EQUAL" (exec "${lib.getExe hyprGaps} inc"))
        (mkBind "SUPER + SHIFT + G" (exec "${lib.getExe selectScreenShader}"))

        (mkBind "SUPER + C" "hl.dsp.window.close()")
        (mkBind "SUPER + E" (exec "${lib.getExe pkgs.nautilus}"))
        (mkBind "SUPER + SHIFT + F" ''hl.dsp.window.float({ action = "toggle" })'')
        (mkBind "SUPER + P" "hl.dsp.window.pseudo()")
        (mkBind "SUPER + SHIFT + P" "hl.dsp.window.pin()")
        (mkBind "SUPER + T" ''hl.dsp.layout("togglesplit")'')

        # Move focus (arrows + vim)
        (mkBind "SUPER + left" (focus "left"))
        (mkBind "SUPER + right" (focus "right"))
        (mkBind "SUPER + up" (focus "up"))
        (mkBind "SUPER + down" (focus "down"))
        (mkBind "SUPER + h" (focus "left"))
        (mkBind "SUPER + l" (focus "right"))
        (mkBind "SUPER + k" (focus "up"))
        (mkBind "SUPER + j" (focus "down"))

        # Move window
        (mkBind "SUPER + SHIFT + left" (moveWindow "left"))
        (mkBind "SUPER + SHIFT + right" (moveWindow "right"))
        (mkBind "SUPER + SHIFT + up" (moveWindow "up"))
        (mkBind "SUPER + SHIFT + down" (moveWindow "down"))
        (mkBind "SUPER + SHIFT + h" (moveWindow "left"))
        (mkBind "SUPER + SHIFT + l" (moveWindow "right"))
        (mkBind "SUPER + SHIFT + k" (moveWindow "up"))
        (mkBind "SUPER + SHIFT + j" (moveWindow "down"))

        # Resize
        (mkBind "SUPER + ALT + left" (resizeWindow (-10) 0))
        (mkBind "SUPER + ALT + right" (resizeWindow 10 0))
        (mkBind "SUPER + ALT + up" (resizeWindow 0 (-10)))
        (mkBind "SUPER + ALT + down" (resizeWindow 0 10))
        (mkBind "SUPER + ALT + h" (resizeWindow (-10) 0))
        (mkBind "SUPER + ALT + l" (resizeWindow 10 0))
        (mkBind "SUPER + ALT + k" (resizeWindow 0 (-10)))
        (mkBind "SUPER + ALT + j" (resizeWindow 0 10))

        # Workspace navigation
        (mkBind "SUPER + code:34" (workspace "-1"))
        (mkBind "SUPER + code:35" (workspace "+1"))
        (mkBind "SUPER + 1" (workspace 1))
        (mkBind "SUPER + 2" (workspace 2))
        (mkBind "SUPER + 3" (workspace 3))
        (mkBind "SUPER + 4" (workspace 4))
        (mkBind "SUPER + 5" (workspace 5))
        (mkBind "SUPER + 6" (workspace 6))
        (mkBind "SUPER + 7" (workspace 7))
        (mkBind "SUPER + 8" (workspace 8))
        (mkBind "SUPER + 9" (workspace 9))
        (mkBind "SUPER + 0" (workspace 10))

        # Move window to workspace
        (mkBind "SUPER + SHIFT + code:34" (moveToWorkspace "-1"))
        (mkBind "SUPER + SHIFT + code:35" (moveToWorkspace "+1"))
        (mkBind "SUPER + SHIFT + 1" (moveToWorkspace 1))
        (mkBind "SUPER + SHIFT + 2" (moveToWorkspace 2))
        (mkBind "SUPER + SHIFT + 3" (moveToWorkspace 3))
        (mkBind "SUPER + SHIFT + 4" (moveToWorkspace 4))
        (mkBind "SUPER + SHIFT + 5" (moveToWorkspace 5))
        (mkBind "SUPER + SHIFT + 6" (moveToWorkspace 6))
        (mkBind "SUPER + SHIFT + 7" (moveToWorkspace 7))
        (mkBind "SUPER + SHIFT + 8" (moveToWorkspace 8))
        (mkBind "SUPER + SHIFT + 9" (moveToWorkspace 9))
        (mkBind "SUPER + SHIFT + 0" (moveToWorkspace 10))

        # Scroll workspaces
        (mkBind "SUPER + mouse_down" (workspace "e+1"))
        (mkBind "SUPER + mouse_up" (workspace "e-1"))

        # Core Noctalia binds
        (mkBind "ALT + SPACE" (exec "noctalia-shell ipc call launcher toggle"))
        (mkBind "SUPER + S" (exec "noctalia-shell ipc call controlCenter toggle"))
        (mkBind "SUPER + D" (exec "noctalia-shell ipc call calendar toggle"))
        (mkBind "SUPER + comma" (exec "noctalia-shell ipc call settings toggle"))
        (mkBind "SUPER + SHIFT + V" (exec "noctalia-shell ipc call launcher clipboard"))
        (mkBind "SUPER + period" (exec "noctalia-shell ipc call launcher emoji"))
        (mkBind "SUPER + F1" (exec "noctalia-shell ipc call plugin:hyprlandvisuals toggle"))

        # Volume/media controls - using wireplumber for better Wayland support
        (mkBindWith "XF86AudioRaiseVolume" (exec "noctalia-shell ipc call volume increase") {
          locked = true;
          repeating = true;
        })
        (mkBindWith "XF86AudioLowerVolume" (exec "noctalia-shell ipc call volume decrease") {
          locked = true;
          repeating = true;
        })
        (mkBindWith "XF86AudioMute" (exec "noctalia-shell ipc call volume muteOutput") {
          locked = true;
          repeating = true;
        })
        (mkBindWith "XF86AudioMicMute"
          (exec "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
          {
            locked = true;
            repeating = true;
          }
        )
        (mkBindWith "XF86AudioPlay" (exec "${lib.getExe pkgs.playerctl} play-pause") { locked = true; })
        (mkBindWith "XF86AudioPause" (exec "${lib.getExe pkgs.playerctl} play-pause") { locked = true; })
        (mkBindWith "XF86AudioNext" (exec "${lib.getExe pkgs.playerctl} next") { locked = true; })
        (mkBindWith "XF86AudioPrev" (exec "${lib.getExe pkgs.playerctl} previous") { locked = true; })

        # Brightness controls
        (mkBindWith "XF86MonBrightnessUp" (exec "noctalia-shell ipc call brightness increase") {
          locked = true;
          repeating = true;
        })
        (mkBindWith "XF86MonBrightnessDown" (exec "noctalia-shell ipc call brightness decrease") {
          locked = true;
          repeating = true;
        })

        # Lock screen
        (mkBind "CONTROL + ALT + Q" (exec "noctalia-shell ipc call lockScreen lock"))

        # Power menu
        (mkBind "CONTROL + ALT + DELETE" (exec "noctalia-shell ipc call sessionMenu toggle"))
        #"CONTROLALT, DELETE, exec, ${lib.getExe pkgs.wlogout}"

        # Screenshots
        (mkBind "PRINT" (
          exec "${lib.getExe pkgs.hyprshot} --output ~/Pictures/Screenshots --freeze --mode output"
        ))
        (mkBind "SUPER + PRINT" (
          exec "${lib.getExe pkgs.hyprshot} --output ~/Pictures/Screenshots --freeze --mode window"
        ))
        (mkBind "SUPER + SHIFT + S" (
          exec "${lib.getExe pkgs.hyprshot} --output ~/Pictures/Screenshots --freeze --mode region"
        ))
        (mkBind "SUPER + SHIFT + T" (exec "${lib.getExe ocrLanguage}"))

        # Color picker
        (mkBind "SUPER + SHIFT + C" (exec "${lib.getExe pkgs.hyprpicker} --autocopy"))

        # Notification center toggle
        (mkBind "SUPER + N" (exec "noctalia-shell ipc call notifications toggleHistory"))
        (mkBind "SUPER + SHIFT + A" (exec "noctalia-shell ipc call plugin:companions toggle"))

        # Misc Shortcuts
        (mkBind "SUPER + W" (exec "noctalia-shell ipc call wallpaper toggle"))
        (mkBind "SUPER + SHIFT + W" (exec "noctalia-shell ipc call plugin:videowallpaper openPanel"))

        # Applications
        (mkBind "SUPER + Q" (exec "${lib.getExe pkgs.wezterm}"))
        (mkBind "SUPER + Return" (exec "${lib.getExe pkgs.wezterm}"))
        (mkBind "SUPER + Y" (exec "${lib.getExe pkgs.wezterm} start -- ${lib.getExe pkgs.yazi}"))
        (mkBind "SUPER + U" (exec "${lib.getExe pkgs.wezterm} start -- ${lib.getExe pkgs.youtube-tui}"))

        # Mouse and lid switch bindings
        (mkBindWith "SUPER + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
        (mkBindWith "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; })
        (mkBindWith "switch:on:Lid Switch" (exec "noctalia-shell ipc call sessionMenu lockAndSuspend") {
          locked = true;
        })
      ];
    };
  };

  xdg.configFile = mkHyprShaderConfigFiles shaderSourceDir;

  services = {
    gnome-keyring.enable = true;
    hyprpolkitagent.enable = true;
  };

  #  home.packages = with pkgs; [
  #  libnotify
  #  pavucontrol
  #];

  #  services.gnome-keyring = {
  #    enable = true;
  #    components = [
  #      "pkcs11"
  #      "secrets"
  #      "ssh"
  #    ];
  #  };
}
