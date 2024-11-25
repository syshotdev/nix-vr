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
    outputs.homeModules.art.video_editing
    outputs.homeModules.art.video_recording
    outputs.homeModules.development.neovim
    outputs.homeModules.games.minecraft
    #outputs.homeModules.games.age_of_empires
  ];

  home.packages = with pkgs; [ 
    file # Package to distinguish appimages
    appimage-run

    autokey # Macro creator

    # Printer slicer
    cura

    # Godot
    # dotnet-sdk # To run godot
    # Compile this when you need it (pkgs.callPackage outputs.customPackages.godot4-mono { })

    gdb # temporary C debugger
  ];
}
