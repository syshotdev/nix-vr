# Syshotdev user, coding, games, blender, video editing, fully fledged.
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  user = "syshotdev";
  nickname = "syshotdev";
  email = "syshotdev@gmail.com";
in {
  imports = [
    (import ../base.nix { inherit inputs outputs config lib pkgs user; } )

    outputs.modulesHome.other.firefox
    (import outputs.modulesHome.development.git { inherit user nickname email lib; })
    outputs.modulesHome.development.neovim
  ];

  # Useful packages
  home.packages = with pkgs; [ 
    rhythmbox
    wget
    ripgrep
    openssl
    gnome.gnome-system-monitor
  ];
}
