{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [ 
    blender
  ];
}
