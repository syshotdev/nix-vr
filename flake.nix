# Alright here's the plan:
# Basically, fix this flake to be as simple as physically possible
# Add each required thing for running VR
# Test, test, test.
# Fix issues

{
  description = "Syshotdev's flake for VR";

  # Removes NVIDIA build times
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    modules.url = "github:syshotdev/nixos-modules";
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
    # Modules from my other config
    modulesSystem = inputs.modules.outputs.systemModules;
    modulesHome = inputs.modules.outputs.homeModules;

    # Local modules
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
          
          # Import config file "computer"
          ./computers/${computer}
        ];
      };
    };
  };
}

