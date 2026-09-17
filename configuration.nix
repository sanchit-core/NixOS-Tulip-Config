{ config, pkgs, ... }:

{
  # ---- Nix itself ----
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---- Boot (GRUB, UEFI mode) ----
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev"; # UEFI: no MBR device to install to
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # ---- Filesystem (btrfs, see hardware-configuration.nix for mounts) ----

  # ---- Networking: wifi only ----
  networking.hostName = "nixos-laptop";
  networking.networkmanager.enable = true;

  # ---- Time / locale ----
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # ---- Hyprland (Omarchy is Hyprland + Wayland under the hood) ----
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # So GTK/Qt apps, screen-sharing, etc. behave correctly under Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };
  security.polkit.enable = true;
  programs.hyprlock.enable = true;

  # ---- Login: boot straight to a TUI greeter that launches Hyprland ----
  services.greetd = {
    enable = true;
    settings.default_session.command =
      "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
  };

  # ---- Audio (pipewire, like a modern Arch/Omarchy setup) ----
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ---- Intel iGPU (Ice Lake / Iris Plus G1) ----
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # ---- Fonts: Omarchy leans on a Nerd Font for its bar/terminal icons ----
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
  ];

  # ---- Essential CLI + Hyprland-ecosystem packages ----
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    waybar
    mako
    walker
    hypridle
    swaybg
    swayosd
    wl-clipboard
    grim
    slurp
    brightnessctl
    playerctl
    btop
  ];

  # ---- User ----
  users.users.sanchit = {
    isNormalUser = true;
    description = "Sanchit";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "26.05"; # matches your NixOS 26.05 "Yarara" install
}
