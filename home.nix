{ config, pkgs, ... }:

{
  home.stateVersion = "24.11";

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1"; # 1920x1080 14" panel, auto scale

      "$mod" = "SUPER";

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(88c0d0ff)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 6;
        blur.enabled = true;
        drop_shadow = true;
      };

      bind = [
        # Terminal / apps (Omarchy: SUPER+Return = terminal, SUPER+Alt+Return = terminal+tmux, SUPER+Shift+Return = browser)
        "$mod, Return, exec, kitty"
        "$mod ALT, Return, exec, kitty tmux new"
        "$mod SHIFT, Return, exec, firefox"
        "$mod, E, exec, dolphin"

        # Window management
        "$mod, Q, killactive"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, pseudo"
        "$mod, M, exit"

        # Launcher (Omarchy default app launcher is Walker; rofi substituted here)
        "$mod, SPACE, exec, rofi -show drun"
        # Keybind cheat-sheet, closest rofi equivalent (Omarchy: SUPER+K opens a searchable bind list)
        "$mod, K, exec, rofi -show keys"

        # Waybar toggle (Omarchy: SUPER+Shift+Space)
        "$mod SHIFT, SPACE, exec, pkill -SIGUSR1 waybar"

        # Clipboard manager (Omarchy: SUPER+Ctrl+V, Walker-based; cliphist substituted here)
        "$mod CTRL, V, exec, kitty --class clipboard -e sh -c 'cliphist list | rofi -dmenu | cliphist decode | wl-copy'"

        # Screenshots (Omarchy: Print / Shift+Print family)
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Move workspace to another monitor (Omarchy: SUPER+Shift+Alt+Arrow)
        "$mod SHIFT ALT, left, movecurrentworkspacetomonitor, l"
        "$mod SHIFT ALT, right, movecurrentworkspacetomonitor, r"
        "$mod SHIFT ALT, up, movecurrentworkspacetomonitor, u"
        "$mod SHIFT ALT, down, movecurrentworkspacetomonitor, d"

        # Focus movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ];

      exec-once = [
        "waybar"
        "mako"
        "nm-applet"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
    };
  };

  programs.kitty.enable = true;
  programs.waybar.enable = true;

  home.packages = with pkgs; [
    firefox
    cliphist
  ];
}
