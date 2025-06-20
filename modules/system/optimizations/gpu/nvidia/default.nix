{ config, lib, pkgs, ...} :
{
  # __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
  # Some guy says this will fix "DRM kernel driver 'nvida-drm in use. NVK requires nouveau"
  /*
  boot.blacklistedKernelModules = ["nouveau"];
  boot.kernelParams = [ "nouveau.modeset=0" "nvidia-drm.fbdev=1" ];
  */
  environment.systemPackages = with pkgs; [ 
    vulkan-tools 
    mesa-demos 
    #cudatoolkit 
    #cudaPackages.cuda_cudart
    #cudaPackages.cuda_nvcc
    #cudaPackages.cuda_cccl
    #linuxPackages.nvidia_x11
     git gitRepo gnupg autoconf curl
     procps gnumake util-linux m4 gperf unzip
     cudatoolkit linuxPackages.nvidia_x11
     libGLU libGL
     xorg.libXi xorg.libXmu freeglut
     xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
     ncurses5 stdenv.cc binutils
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
}
