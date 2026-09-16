{ config, pkgs, inputs, ... }:

{
  # ---- Boot (GRUB, UEFI mode) ----
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";      # UEFI: no MBR device to install to
    efiSupport = true;
    useOSProber = false;   # set true if you dual-boot Windows and want it detected
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ---- Filesystem (btrfs with subvolumes) ----
  # See hardware-configuration.nix for the actual mount definitions and
  # the SSD formatting guide for how the subvolumes were created.

  # ---- Networking ----
  networking.hostName = "nixos-laptop";
  networking.networkmanager.enable = true;

  # ---- Time / locale ----
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # ---- Intel iGPU (Ice Lake / Iris Plus G1) ----
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # helps with Steam/Proton games
    extraPackages = with pkgs; [
      intel-media-driver   # VAAPI driver for iGPU video accel
      vpl-gpu-rt           # QSV support on newer Intel stacks
      intel-compute-runtime
    ];
  };
  # Force iHD driver (better than legacy i965 on Ice Lake)
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # ---- Hyprland ----
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Uses the hyprland flake input package rather than nixpkgs' (often newer)
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # Greeter for a Wayland session
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # XDG portals (screen share, file pickers, etc.)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # ---- Audio (PipeWire) ----
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ---- Fonts (needed for waybar/rofi icons etc.) ----
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # ---- Gaming (since you play on Linux now) ----
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  programs.gamemode.enable = true;

  # ---- System packages for the Hyprland desktop ----
  environment.systemPackages = with pkgs; [
    waybar
    rofi-wayland
    swaylock
    swayidle
    mako            # notifications
    grim slurp      # screenshots
    wl-clipboard
    kitty           # terminal
    networkmanagerapplet
    brightnessctl
    pavucontrol
    git
    vim
  ];

  # ---- User ----
  users.users.sanchit = {
    isNormalUser = true;
    description = "Sanchit";
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # ---- Security note ----
  # This is the concrete win over Arch/Omarchy for your stated concern:
  # NixOS builds are reproducible, config is declarative and version-controlled,
  # and `nixos-rebuild switch` gives you atomic rollbacks if anything breaks.
  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "24.11"; # set to the release you install with, don't change casually
}
