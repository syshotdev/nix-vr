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
          ];

          shellHook = ''
            #export STEAM_LOCATION="$HOME/.local/share/Steam"
            #export VRCLIENT="$STEAM_LOCATION/steamapps/common/SteamVR/bin/linux64/vrclient.so"
            #export STOREPATH=$(nix-store -qR $(which steam) | grep steam-fhs)/lib64
          '';
        };
      });
}

