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
    #(unstable.blender.override { cudaSupport = true; })
    nvidia-system-monitor-qt

    # VR
    unstable.alvr
    immersed-vr
  ];
}
