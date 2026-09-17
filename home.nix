{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.omarchy-theme.homeManagerModules.default ];

  home.username = "sanchit";
  home.homeDirectory = "/home/sanchit";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
  };

  home.packages = with pkgs; [ htop ];

  programs.git = {
    enable = true;
    userName = "sanchit";
    # userEmail = "you@example.com"; # fill in if you want commits to work out of the box
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
  };

  programs.alacritty.enable = true;
  # NOTE: mako's config file is left to the theme switcher below (it writes
  # ~/.config/mako/config itself) — enabling programs.mako here too would
  # fight it for the same file, so mako is just installed as a package
  # (configuration.nix) and started via exec-once.

  programs.waybar = {
    enable = true;
    style = ''
      @import "colors.css"; /* written by the theme switcher */
    '';
    settings.mainBar = {
      layer = "top";
      height = 34;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];
    };
  };

  # ---- Hyprland: window manager + keybinds (Omarchy's general feel) ----
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [ ",preferred,auto,1" ];

      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$menu" = "walker --dmenu";

      exec-once = [
        "waybar"
        "mako"
        "hypridle"
        "swaybg -i ~/.local/share/themes/current-background -m fill"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(89b4faee)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
        };
      };

      animations.enabled = true;

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      bind =
        [
          "$mod, Return, exec, $terminal"
          "$mod, Q, killactive,"
          "$mod SHIFT, Q, exit,"
          "$mod, Space, exec, $menu"
          "$mod, F, fullscreen,"
          "$mod, V, togglefloating,"
          "$mod, L, exec, hyprlock"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"
        ]
        ++ (builtins.concatLists (builtins.genList
          (i:
            let ws = toString (i + 1); in [
              "$mod, ${ws}, workspace, ${ws}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
            ])
          9));

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      source = "~/.config/hypr/hyprlock-theme.conf"; # colors from the theme switcher
      background = [{ path = "screenshot"; blur_passes = 3; }];
      input-field = [{
        size = "250, 50";
        outline_thickness = 2;
        placeholder_text = "Password";
      }];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        { timeout = 300; on-timeout = "hyprlock"; }
        { timeout = 600; on-timeout = "systemctl suspend"; }
      ];
    };
  };

  # ---- Theme switcher: github.com/niedch/nix-omarchy-theme ----
  # Pulls real Omarchy theme repos and renders waybar/alacritty/mako/hyprlock
  # etc. to match. `theme-switcher` (or `ts`) switches at runtime.
  omarchy-themes = {
    enable = true;
    defaultTheme = "catppuccin";
    selectorCommand = "walker --dmenu";

    themes = {
      catppuccin = {
        url = "https://github.com/basecamp/omarchy.git";
        ref = "9cf1852525a5f7de26d3162db9d61e2f5c1d5523";
        hash = "sha256-9zkIEgD/L5+eK5fuQNXbBd5XXO+NwH6QWGiDI//kGas=";
        subpath = "themes/catppuccin";
      };

      gruvbox = {
        url = "https://github.com/basecamp/omarchy.git";
        ref = "9cf1852525a5f7de26d3162db9d61e2f5c1d5523";
        hash = "sha256-9zkIEgD/L5+eK5fuQNXbBd5XXO+NwH6QWGiDI//kGas=";
        subpath = "themes/gruvbox";
      };
    };

    # Rendered theme files -> the real config paths the apps read from
    symlinks = {
      "hypr/hyprlock-theme.conf".source = "hyprlock.conf";
      "waybar/colors.css".source = "waybar.css";
      "mako/config".source = "mako.ini";
      "btop/themes/btop.theme".source = "btop.theme";
    };
  };
}
