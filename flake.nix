{
  description = "Syshotdev's flake for VR";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-24_11.url = "github:nixos/nixpkgs/nixos-24.11";
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

    # Shortcuts for editing user/computer
    computer = "desktop";
    user = "syshotdev";

    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      # Add nixpkgs 24.11 to pkgs
      overlays = [
        (final: prev: { pkgs2411 = import inputs.nixpkgs-24_11 { inherit system; };})
      ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true); # <-- Workaround
      };
    };

    specialArgs = { inherit inputs outputs pkgs computer user; };
  in {
    # Local modules
    system = import ./modules/system/default.nix;
    scripts = import ./modules/scripts;

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

