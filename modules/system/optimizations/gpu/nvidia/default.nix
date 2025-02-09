{ config, lib, pkgs, ...} :
{
  # __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
  # Some guy says this will fix "DRM kernel driver 'nvida-drm in use. NVK requires nouveau"
  boot.blacklistedKernelModules = ["nouveau"];
  boot.kernelParams = [ "nouveau.modeset=0" "nvidia-drm.fbdev=1" ];
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];
  environment.systemPackages = with pkgs; [ vulkan-tools mesa-demos ];


  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
}

