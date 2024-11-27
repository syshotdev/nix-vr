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
# Put all of these things into TODO.txt in the other repo


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
    # https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
    # Add unstable packages
    nixpkgs.overlays = [
      (final: _: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (final) config;
        };
      })
    ];
    nixpkgs.config = {
      allowUnfree = true; # Allow proprietary packages
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true); # Ima be honest Idk if it was an issue in the first place
    };

    hashedPassword = "...";

    #systemModules = inputs.modules.outputs.systemModules;
    #homeModules = inputs.modules.outputs.homeModules;
    #scriptModules = inputs.modules.outputs.scriptModules;
    systemModules = import ./modules-repo/modules/system;
    homeModules = import ./modules-repo/modules/home;
    scriptModules = import ./modules-repo/modules/scripts;
    customPackages = import ./modules-repo/modules/custom-packages;

    # Custom packages (to be built) not in the nix repository
    # This variable *only* lists the paths to the packages, you have to build them and include them into pkgs.
    #customPackages = inputs.modules.outputs.customPackages;

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

