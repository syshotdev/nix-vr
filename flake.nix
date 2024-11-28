# Alright here's the plan:
# Basically, fix this flake to be as simple as physically possible
# nix-collect-garbage
# Add each required thing for running VR
# Test, test, test.
# Fix issues

# Once VR is completely and utterly done, start cleaning up other configs
# Since I have much more knowledge on what the heck everything does in
# nix, I can definitely simplify my config and make it soooo much less of
# a hassle to work with.
#
# Examples:
# Do I neeeed multiple user dirs? I mean, per machine config is nice, but maybe some if statements
# would do better and be simpler.
#
# Share base.nix for all computers from simple-nixos-config
#
# Add unstable packages as a variable, and import that to everything instead of overlaying it in
# the computer/configuration.nix file. 
#
# Instead of using outputs."someModules".development.neovim,
# maybe there's a less verbose way of saying that?
#
# Rename configuration.nix maybe?
#
# Use imports instead of import
#
# Simplify the modules directory. (Add readmes or documentation on how to make things work)
#
# Split beginner-nixos-config into modules and itself
#
# Special lib function for grabbing all folders in a dir, and adding them all as attributes
# with the name of the folder as the name of the attribute, and the path to the folder
#
# Put all of these things into TODO.txt in the other repo

# All the current errors that I am facing (With vr)
/*
 find: ‘/proc/1541968/fd/0’: Permission denied
11/28 20:16:46 /tmp/dumps: is not owned by us - delete and recreate.
11/28 20:16:46 /tmp/dumps: could not delete, skipping.
sh: 1: xdg-mime: not found
vrcompositor-launcher.sh[1551814]: exec /home/syshotdev/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher
Using vrcompositor capability proxy
Failed to raise ambient cap
Launching /home/syshotdev/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor
*** stack smashing detected ***: terminated
Qt: Session management error: None of the authentication protocols specified are supported
sh: 1: xdg-icon-resource: not found
sh: 1: xdg-mime: not found
libpng warning: iCCP: known incorrect sRGB profile
QVRMonitorHeadsetWarning(0x56444565c850)  does not have a property named  "green_color"
CQVRMonitorHeadsetWarning(0x56444565c850)  does not have a property named  "red_color"
Initialize() is failed!!!
qt.network.ssl: QSslSocket: cannot resolve CRYPTO_num_locks
DRM kernel driver 'nvidia-drm' in use. NVK requires nouveau.
Destroy() is failed!!
*/

{
  description = "Syshotdev's flake for VR, gonna be a long rebuild when I Garbage Collect";

  /*
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };*/

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";

    modules = {
      url = "github:syshotdev/nixos-modules";
    };

    #nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: 
  let
    inherit (self) outputs;
    specialArgs = {inherit inputs outputs nixpkgs computer;};
    computer = "desktop";
  in {

    hashedPassword = "...";

    #systemModules = inputs.modules.outputs.systemModules;
    #homeModules = inputs.modules.outputs.homeModules;
    #scriptModules = inputs.modules.outputs.scriptModules;

    # Custom packages (to be built) not in the nix repository
    # This variable *only* lists the paths to the packages, you have to build them and include them into pkgs.
    #customPackages = inputs.modules.outputs.customPackages;

    systemModules = import ./modules/system/default.nix;
    homeModules = import ./modules/home;
    scriptModules = import ./modules/scripts;
    customPackages = import ./modules/custom-packages;

    nixosConfigurations = {
      "${computer}" = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = specialArgs;
          }
          
          ./computers/${computer}
        ];
      };
    };
  };
}

