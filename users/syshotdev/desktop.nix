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
    # Nvidia specific stuff
    nvidia-system-monitor-qt

    # VR
    unstable.alvr
    immersed-vr
  ];
}
