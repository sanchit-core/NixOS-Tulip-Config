{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";

  # No window manager, no desktop packages — just a couple of CLI conveniences.
  home.packages = with pkgs; [
    htop
  ];

  programs.git = {
    enable = true;
    userName = "sanchit";
    # userEmail = "you@example.com"; # fill in if you want commits to work out of the box
  };
}
