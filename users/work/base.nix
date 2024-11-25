# Specifically school related stuff, no coding or games
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  user = "work";
  nickname = "work";
  email = "this_doesnt_exist@gmail.com";
in {
  imports = [
    (import ../base.nix { inherit inputs outputs config lib pkgs user; } )

    (import outputs.homeModules.development.git { inherit user nickname email lib; })
  ];

  home.packages = with pkgs; [ 
    zoom-us
  ];
}
