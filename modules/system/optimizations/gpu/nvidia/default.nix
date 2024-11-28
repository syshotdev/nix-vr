{ config, lib, pkgs, ...} :
{
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  # Some guy says this will fix "DRM kernel driver 'nvida-drm in use. NVK requires nouveau"
  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];
}

