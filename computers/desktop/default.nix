{
  inputs,
  outputs,
  computer,
  config,
  lib,
  pkgs,
  ...
}: 
{
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    outputs.system.optimizations.cpu
    outputs.system.optimizations.gpu
    outputs.system.optimizations.intel-cpu
    outputs.system.optimizations.nvidia-gpu
    #outputs.system.steam
    outputs.modulesSystem.kitty

    #outputs.system.vr.alvr

    outputs.scripts
  ];

  environment.systemPackages = with pkgs; [
    nvidia-system-monitor-qt
  ];

  users.users = {
    "syshotdev" = {
 
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  home-manager.users.syshotdev = import ../../users/syshotdev { inherit inputs outputs lib config pkgs; };

  nix.settings.trusted-users = ["sudo" "syshotdev"]; # Who is given sudo permissions

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
