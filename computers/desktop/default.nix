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
    outputs.systemModules.optimizations.nvidia-gpu
    outputs.systemModules.steam
    outputs.systemModules.kitty

    outputs.systemModules.vr.alvr

    outputs.scriptModules
    ./hardware-configuration.nix
    ../base.nix
  ];

  # This don't work?
  environment.variables = {
    TEST_THING_Y_1  = "It\ works!!!";
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
  };

  users.users = {
    "syshotdev" = {
 
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  # Create the users. /users/{user}/{computer}.nix (Works on every nixos rebuild)
  home-manager.users.syshotdev = import ../../users/syshotdev/${computer}.nix;

  nix.settings.trusted-users = ["sudo" "syshotdev"]; # Who is given sudo permissions

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
