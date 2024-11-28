{ config, lib, pkgs, ...} :
{
  # Some guy says this will fix "DRM kernel driver 'nvida-drm in use. NVK requires nouveau"
  boot.blacklistedKernelModules = ["nouveau"];
  boot.kernelParams = [ "nouveau.modeset=0" "nvidia-drm.fbdev=1" ];
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

}

