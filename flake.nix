# Alright here's the plan:
# Basically, fix this flake to be as simple as physically possible
# nix-collect-garbage
# Add each required thing for running VR
# Test, test, test.
# Fix issues

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

  # We have computer, we have user. NO MORE
  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";

    modules = {
      url = "github:syshotdev/nixos-modules";
    };

    #nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
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

    modulesSystem = inputs.modules.outputs.systemModules;
    modulesHome = inputs.modules.outputs.homeModules;
    system = import ./modules/system/default.nix;
    scripts = import ./modules/scripts;
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

