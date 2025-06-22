{
  inputs,
  outputs,
  computer,
  user,
  config,
  lib,
  pkgs,
  ...
}: 
{
  imports = [
    ./hardware-configuration.nix
    ../base.nix

    # Hardware configurations
    outputs.system.optimizations.cpu
    outputs.system.optimizations.gpu
    outputs.system.optimizations.intel-cpu
    outputs.system.optimizations.nvidia-gpu

    # Local packages for quick iteration
    outputs.system.steam
    outputs.system.vr.alvr
    outputs.scripts
  ];

  environment.systemPackages = with pkgs; [
    nvidia-system-monitor-qt
  ];

  users.users = {
    "${user}" = {
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  home-manager.users."${user}" = import ../../users/${user} { inherit inputs outputs user lib config pkgs; };

  nix.settings.trusted-users = ["sudo" "${user}"]; # Who is given sudo permissions

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
