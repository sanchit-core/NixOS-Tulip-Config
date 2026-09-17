# NixOS-Tulip-Config
# What changed, and what to check

## Fixed vs. what you said you'd done
Your uploaded `configuration.nix` didn't actually have flakes/`nix-command`
enabled yet, and `home.nix` still installed `vim`, not `neovim` — I added
`nix.settings.experimental-features` and swapped in `programs.neovim`.

## flake.nix
Added `omarchy-theme` (github.com/niedch/nix-omarchy-theme) as an input and
imported its home-manager module into your `sanchit` user config.

## configuration.nix
- `programs.hyprland.enable = true` + xwayland
- `xdg.portal` with `xdg-desktop-portal-hyprland` (screen share, file pickers)
- `services.greetd` + `tuigreet` so you boot straight into a TUI login that
  launches Hyprland (swap for SDDM if you'd rather have a graphical greeter)
- pipewire for audio, polkit, a Nerd Font for the bar/terminal icons
- system packages for the rest of the Omarchy-ish stack: `waybar`, `mako`,
  `walker`, `hypridle`, `swaybg`, `swayosd`, `grim`/`slurp`, `btop`, etc.

## home.nix
- Hyprland config (`wayland.windowManager.hyprland`) with gaps/rounding/blur
  and Omarchy-style `SUPER`-based binds: `SUPER+Return` terminal,
  `SUPER+Space` walker (app launcher), `SUPER+Q` close, `SUPER+F` fullscreen,
  `SUPER+L` lock, `SUPER+1..9` workspaces.
- `programs.waybar`, `programs.hyprlock`, `services.hypridle`, `programs.alacritty`
- `omarchy-themes` module enabled with two real Omarchy theme repos
  (catppuccin, gruvbox — same commit/hash as the project's own README
  example) wired to waybar/mako/hyprlock/btop. Run `theme-switcher` (alias
  `ts`) once logged in to switch.

## You still need to
1. **`hardware-configuration.nix` is untouched** — I don't have it, so the
   flake still expects your real UUIDs there.
2. **Build it**: `sudo nixos-rebuild switch --flake .#laptop`. If Nix
   complains about a wrong hash for the theme repos, paste the hash it
   prints into `home.nix` and rebuild — that's normal on the first pull.
3. **This isn't a byte-for-byte clone of Omarchy** — no repo/tool exposes
   Omarchy's actual dotfiles as a Nix module, so I rebuilt the same stack
   (Hyprland, Waybar, Walker, Mako, Hyprlock, hypridle) with similar
   keybinds/gaps/blur and wired in the real theme colors via the
   theme-switcher flake. Tell me what specifically looks off once it's
   running and I'll tune it — down to individual Waybar modules or binds.
4. **Add more themes**: copy the `catppuccin`/`gruvbox` block in `home.nix`
   for any theme repo listed at github.com/basecamp/omarchy/tree/master/themes.
