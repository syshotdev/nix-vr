# Alright here's the plan:
# Basically, fix this flake to be as simple as physically possible
# Add each required thing for running VR
# Test, test, test.
# Fix issues

{
  description = "Syshotdev's flake for VR";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-24_11.url = "github:nixos/nixpkgs/nixos-24.11";

    modules.url = "github:syshotdev/nixos-modules";
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    nixpkgs-24_11,
    ...
  } @ inputs: 
  let
    inherit (self) outputs;

    computer = "desktop";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      # Add nixpkgs 24.11 to pkgs
      overlays = [
        (final: prev: { pkgs2411 = import inputs.nixpkgs-24_11 { inherit system; };})
      ];
      config = {
        allowUnfree = true;
        # workaround for HM https issue
        allowUnfreePredicate = (_: true);
      };
    };

    specialArgs = {inherit inputs outputs pkgs computer;};
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

