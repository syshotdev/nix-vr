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
    outputs.systemModules.optimizations.cpu
    outputs.systemModules.optimizations.gpu
    outputs.systemModules.optimizations.intel-cpu
    outputs.systemModules.optimizations.nvidia
    outputs.systemModules.steam
    outputs.systemModules.kitty
    outputs.systemModules.vr.monado

    outputs.scriptModules
    ./hardware-configuration.nix
    ../base.nix
  ];

  users.users = {
    "syshotdev" = {
 
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  # Create the users. /users/{user}/{computer}.nix (Works on every nixos rebuild)
  home-manager.users.syshotdev = import ../../users/syshotdev/${computer}.nix;

  nix.settings.trusted-users = ["sudo" "syshotdev"]; # Who is given sudo permissions

  nixpkgs.overlays = [outputs.overlays.unstable-packages]; # I think this adds unstable packages

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
