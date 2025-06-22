# Syshotdev user, coding, games, blender, video editing, fully fledged.
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    (import ../base.nix { inherit inputs outputs config lib pkgs user; } )
  ];

  # Useful packages
  home.packages = with pkgs; [ 
    git
    neovim
    wget
    ripgrep
    openssl
    gnome.gnome-system-monitor
  ];
}
