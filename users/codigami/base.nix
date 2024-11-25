# Games, art programs, codigami stuff
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  user = "codigami";
  nickname = "codigami";
  email = "codigami@gmail.com";
in {
  imports = [
    (import ../base.nix { inherit inputs outputs config lib pkgs user; } )

    (import outputs.homeModules.development.git { inherit user nickname email lib; })
    outputs.homeModules.art.video_editing
    outputs.homeModules.art.video_recording
    outputs.homeModules.games.minecraft
    #outputs.homeModules.games.age_of_empires
    # Age of Empires
    #wineWowPackages.unstableFull
    #dosbox-staging
  ];

  home.packages = with pkgs; [ 
    discord
  ];
}
