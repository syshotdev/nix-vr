# Every single user's base
{outputs, lib, user, pkgs,  ...}:
{
  imports = [
    (import ./home-manager-boilerplate-code.nix { inherit user pkgs outputs; } )
    outputs.homeModules.other.firefox
  ];
  # Make extra directories
  home.activation.createDirs = lib.mkAfter ''
  mkdir -p ${lib.concatMapStrings (dir: " \$HOME/${dir}") ["3d" "Programming" "Programs" "Sounds" "Temporary"]}
'';

  home.packages = with pkgs; [ 
  ];
}
