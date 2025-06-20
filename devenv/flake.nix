{
  description = "Nix shell with graphics and SteamVR patching";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixGL.url = "github:nix-community/nixGL";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Try:
  #__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
  # Look at logs, what packages missing
  # Set different vars
  # Make sure paths to vrclient and things are in right place
  # Reinstall steamvr
  # ~/.local/share/Steam/steamapps/common/SteamVR/bin/vrwebhelper/linux64/ export LD_LIBRARY_PATH="${DIR}:${STEAM_RUNTIME_HEAVY}${LD_LIBRARY_PATH+:$LD_LIBRARY_PATH}"
  # $XDG_CONFIG_HOME/openxr/1/active_runtime.json /home/josh/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrclient.so SteamVR
  #

  outputs = { self, nixpkgs, nixGL, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        nixgl = nixGL.packages.${system}.nixGLIntel or nixGL.packages.${system}.nixGLDefault;
        vrRun = pkgs.writeShellScriptBin "vr-run" (builtins.readFile ../modules/scripts/VrRun.sh);
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alvr
            vulkan-tools
            glxinfo
            patchelf
            steam-run
            nixgl
            vrRun
            usbutils
          ];

          shellHook = ''
            #export STEAM_LOCATION="$HOME/.local/share/Steam"
            #export VRCLIENT="$STEAM_LOCATION/steamapps/common/SteamVR/bin/linux64/vrclient.so"
            #export STOREPATH=$(nix-store -qR $(which steam) | grep steam-fhs)/lib64
          '';
        };
      });
}

# Tried:
/*
# TODO: For next time: Create a checklist for all the things I need to do, in order, add every single step that I did ever.
# As well as that, add trying monado, changing config files, stuff like enableVulkanFoviation or whatever
https://github.com/alvr-org/ALVR/wiki/Linux-Troubleshooting#black-screen-even-when-steamvr-shows-movement
https://steamcommunity.com/app/250820/discussions/2/1640917625015598552/
https://xeiaso.net/blog/nixos-vr-hell-2021-12-02/
https://curiouslynerdy.com/nixos-steamvr-openxr/
https://discourse.nixos.org/t/troubleshooting-steamvr/17406
https://simulavr.com/blog/simula-on-nixos/
*/
