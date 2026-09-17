{ config, pkgs, ... }:

{
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

  # ---- No display manager, no window manager: boots straight to a TTY login ----

  # ---- Intel iGPU (Ice Lake / Iris Plus G1) ----
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # ---- Essential CLI packages ----
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
  ];

  # ---- User ----
  users.users.sanchit = {
    isNormalUser = true;
    description = "Sanchit";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "26.05"; # matches your NixOS 26.05 "Yarara" install
}
