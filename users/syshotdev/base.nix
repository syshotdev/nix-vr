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

    (import outputs.homeModules.development.git { inherit user nickname email lib; })
    outputs.homeModules.development.neovim
  ];

  home.packages = with pkgs; [ 
  ];
}
