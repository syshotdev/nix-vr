{ config, lib, pkgs, ...} :
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
}
